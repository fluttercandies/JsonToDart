using FlutterCandiesJsonToDart.Utils;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


#if WINDOWS_UWP
using Windows.UI;
using Windows.UI.Xaml.Media;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
#else
using System.Windows.Media;
#endif


namespace FlutterCandiesJsonToDart.Models
{
    public class ExtendedJObject : ExtendedProperty
    {

        private JObject jObject;

        public JObject JObject => mergeOject != null ? mergeOject : jObject;


        private Brush classNameColor;
        public Brush ClassNameColor
        {
            get { return classNameColor; }
            set
            {
                if (classNameColor != value)
                {
                    classNameColor = value;
                    OnPropertyChanged(nameof(ClassNameColor));
                }

            }
        }


        private string className;
        public string ClassName
        {
            get { return className; }
            set
            {
                if (String.IsNullOrWhiteSpace(value))
                {
                    ClassNameColor = new SolidColorBrush(Colors.Red);
                }
                else
                {
                    ClassNameColor = new SolidColorBrush(Colors.Yellow);
                }
                className = value;
                OnPropertyChanged(nameof(ClassName));
            }
        }

        public List<ExtendedProperty> Properties { get; private set; }

        public Dictionary<String, ExtendedJObject> ObjectKeys { get; private set; }


        public override string GetTypeString(string className = null)
        {
            return ClassName;
        }

        public ExtendedJObject(string uid, KeyValuePair<string, JToken> keyValuePair, int depth) : base(uid, keyValuePair, depth)
        {
            this.jObject = keyValuePair.Value as JObject;
            this.Depth = depth;
            var key = keyValuePair.Key;
            var className = key.Substring(0, 1).ToUpper() + key.Substring(1);
            this.ClassName = className;
            this.Uid = uid;
            //this.Name = uid;
            Properties = new List<ExtendedProperty>();
            ObjectKeys = new Dictionary<string, ExtendedJObject>();

            InitializeProperties();
            UpdateNameByNamingConventionsType();
        }

        private void InitializeProperties()
        {
            Properties.Clear();
            ObjectKeys.Clear();
            if (JObject.Count > 0)
            {
                foreach (var item in JObject)
                {
                    InitializeProperty(item, Depth);
                }
                OrderPropeties();
            }
        }

        private void InitializeProperty(KeyValuePair<string, JToken> item, int depth, bool addProperty = true)
        {
            if (item.Value.Type == JTokenType.Object && item.Value.Count() > 0)
            {

                if (ObjectKeys.ContainsKey(item.Key))
                {
                    var temp = ObjectKeys[item.Key];
                    temp.Merge(item.Value as JObject);
                    ObjectKeys[item.Key] = temp;
                }
                else
                {
                    var temp = new ExtendedJObject(Uid + "_" + item.Key, item, depth + 1);
                    if (addProperty)
                        Properties.Add(temp);
                    ObjectKeys[item.Key] = temp;
                }
            }
            else if (item.Value.Type == JTokenType.Array)
            {
                if (addProperty)
                    Properties.Add(new ExtendedProperty(Uid, item, depth));
                var array = item.Value as JArray;
                if (array.Count > 0)
                {
                    var count = ConfigHelper.Instance.Config.TraverseArrayCount;
                    if (count == 99)
                    {
                        count = array.Count();
                    }

                    for (int i = 0; i < array.Count() && i < count; i++)
                    {
                        InitializeProperty(new KeyValuePair<string, JToken>(item.Key, array[i]), depth, addProperty: false);
                    }
                }
            }
            else
            {
                if (addProperty)
                    Properties.Add(new ExtendedProperty(Uid, item, depth));
            }
        }

        public override bool Equals(object obj)
        {
            if (obj is ExtendedJObject other && other.Key == this.Key)
            {

                return true;
            }
            return false;
        }

        public override int GetHashCode()
        {
            var hashCode = 1878600528;
            hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(Key);
            //hashCode = hashCode * -1521134295 + EqualityComparer<JObject>.Default.GetHashCode(jObject);
            //hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(Name);
            //hashCode = hashCode * -1521134295 + EqualityComparer<JObject>.Default.GetHashCode(JObject);
            return hashCode;
        }

        private JObject mergeOject;
        public void Merge(JObject other)
        {
            if (this.jObject != null)
            {
                if (mergeOject == null)
                    mergeOject = new JObject();

                mergeOject.Merge(this.jObject);
            }

            if (other != null)
            {
                if (mergeOject == null)
                    mergeOject = new JObject();
                mergeOject.Merge(other);
            }

            if (mergeOject != null)
            {
                InitializeProperties();
            }
        }

        public override string ToString()
        {
            OrderPropeties();
            StringBuilder sb = new StringBuilder();

            sb.AppendLine(String.Format(DartHelper.ClassHeader, this.ClassName));

            if (Properties.Count > 0)
            {
                StringBuilder factorySb = new StringBuilder();
                StringBuilder factorySb1 = new StringBuilder();
                StringBuilder propertySb = new StringBuilder();
                StringBuilder propertySb1 = new StringBuilder();
                StringBuilder fromJsonSb = new StringBuilder();
                //Array
                StringBuilder fromJsonSb1 = new StringBuilder();
                StringBuilder toJsonSb = new StringBuilder();

                factorySb.AppendLine(String.Format(DartHelper.FactoryStringHeader, this.ClassName));

                //fromJsonSb.AppendLine(String.Format(DartHelper.FromJsonHeader, this.ClassName));

                toJsonSb.AppendLine(DartHelper.ToJsonHeader);


                foreach (var item in Properties)
                {
                    var lowName = item.Name.Substring(0, 1).ToLower() + item.Name.Substring(1);
                    var name = item.Name;
                    String className = null;
                    String typeString;
                    var setName = DartHelper.GetSetPropertyString(item);
                    var setString = "";
                    var fss = DartHelper.FactorySetString(item.PropertyAccessorType);
                    bool isGetSet = fss.StartsWith("{");


                    if (item is ExtendedJObject)
                    {
                        className = (item as ExtendedJObject).ClassName;
                        setString = String.Format(DartHelper.SetObjectProperty, lowName, item.Key, className);
                        typeString = className;
                    }
                    else if (item.JType == JTokenType.Array)
                    {
                        if (ObjectKeys.ContainsKey(item.Key))
                        {
                            className = ObjectKeys[item.Key].ClassName;
                        }
                        typeString = item.GetTypeString(className: className);

                        fromJsonSb1.AppendLine(item.GetArraySetPropertyString(lowName, typeString, className: className));

                        setString = $" {(isGetSet ? lowName : item.Name)}:{lowName},";

                    }
                    else
                    {
                        setString = DartHelper.SetProperty(lowName, item, ClassName);
                        typeString = DartHelper.GetDartTypeString(item.Type);
                    }


                    if (isGetSet)
                    {
                        factorySb.AppendLine(String.Format(fss, typeString, lowName));
                        if (factorySb1.Length == 0)
                        {
                            factorySb1.Append("}):");
                        }
                        else
                        {
                            factorySb1.Append(",");
                        }
                        factorySb1.Append($"{setName}={lowName}");
                    }
                    else
                    {
                        factorySb.AppendLine(String.Format(fss, item.Name));
                    }


                    propertySb.AppendLine(String.Format(DartHelper.PropertyS(item.PropertyAccessorType), typeString, name, lowName));
                    fromJsonSb.AppendLine(setString);
                    toJsonSb.AppendLine(String.Format(DartHelper.ToJsonSetString, item.Key, setName));
                }

                if (factorySb1.Length == 0)
                {
                    factorySb.AppendLine(DartHelper.FactoryStringFooter);
                }
                else
                {
                    factorySb1.Append(";");
                    factorySb.Append(factorySb1.ToString());
                }

                var fromJson = "";
                if (fromJsonSb1.Length != 0)
                {
                    fromJson = String.Format(DartHelper.FromJsonHeader1, this.ClassName) + fromJsonSb1.ToString() + String.Format(DartHelper.FromJsonFooter1, this.ClassName, fromJsonSb.ToString());
                }
                else
                {
                    fromJson = String.Format(DartHelper.FromJsonHeader, this.ClassName) + fromJsonSb.ToString() + DartHelper.FromJsonFooter;
                }


                //fromJsonSb.AppendLine(DartHelper.FromJsonFooter);

                toJsonSb.AppendLine(DartHelper.ToJsonFooter);


                sb.AppendLine(propertySb.ToString());

                sb.AppendLine(factorySb.ToString());

                sb.AppendLine(fromJson);

                sb.AppendLine(toJsonSb.ToString());

                sb.AppendLine(DartHelper.ClassToString);
            }


            sb.AppendLine(DartHelper.ClassFooter);


            foreach (var item in ObjectKeys)
            {
                sb.AppendLine(item.Value.ToString());
            }

            return sb.ToString();
        }

        public void OrderPropeties()
        {
            if (JObject.Count > 0)
            {
                var sortingType = ConfigHelper.Instance.Config.PropertyNameSortingType;
                if (sortingType != PropertyNameSortingType.None)
                {
                    if (sortingType == PropertyNameSortingType.Ascending)
                    {
                        Properties = Properties.OrderBy(x => x.Name).ToList();
                    }
                    else
                    {
                        Properties = Properties.OrderByDescending(x => x.Name).ToList();
                    }
                }

                if (ObjectKeys != null)
                {
                    foreach (var item in ObjectKeys)
                    {
                        item.Value.OrderPropeties();
                    }
                }
            }
        }

        public string HasEmptyProperties()
        {
            if (String.IsNullOrWhiteSpace(ClassName))
                return Uid + "的类名为空";

            foreach (var item in Properties)
            {
                if (item is ExtendedJObject)
                {
                    if (Depth > 0 && !item.Uid.EndsWith("_Array") && String.IsNullOrWhiteSpace(item.Name))
                    {
                        return item.Uid + "的属性名为空";
                    }
                }
                else if (String.IsNullOrWhiteSpace(item.Name))
                {
                    return item.Uid + "的属性名为空";
                }
            }

            foreach (var item in ObjectKeys)
            {
                var msg = item.Value.HasEmptyProperties();
                if (msg != null)
                    return msg;
            }
            return null;
        }


        public override void UpdateNameByNamingConventionsType()
        {
            base.UpdateNameByNamingConventionsType();
            if (Properties != null)
            {
                foreach (var item in Properties)
                {
                    item.UpdateNameByNamingConventionsType();
                }
            }

        }

        public override void UpdatePropertyAccessorType()
        {
            base.UpdatePropertyAccessorType();
            if (Properties != null)
            {
                foreach (var item in Properties)
                {
                    item.UpdatePropertyAccessorType();
                }
            }

            if (ObjectKeys != null)
            {
                foreach (var item in ObjectKeys)
                {
                    item.Value.UpdatePropertyAccessorType();
                }
            }
        }
    }
}
