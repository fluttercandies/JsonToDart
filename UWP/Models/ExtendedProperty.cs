using FlutterCandiesJsonToDart.Utils;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

using System.Text;
#if WINDOWS_UWP
using Windows.UI;
using System.Linq;
using Windows.UI.Xaml.Media;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
#else
using System.Windows.Media;
#endif

namespace FlutterCandiesJsonToDart.Models
{
    public class ExtendedProperty : BindableBase
    {
        public String Uid { get; protected set; }
        public int Depth { get; protected set; }
        public String Key => KeyValuePair.Key;

        public JToken Value => KeyValuePair.Value;
        public JTokenType JType => KeyValuePair.Value.Type;

        public KeyValuePair<string, JToken> KeyValuePair { get; private set; }

        private string name;
        public string Name
        {
            get { return name; }
            set
            {
                if (String.IsNullOrWhiteSpace(value))
                {
                    Color = new SolidColorBrush(Colors.Red);
                }
                else
                {
                    Color = null;
                }
                name = value;
                OnPropertyChanged(nameof(Name));
            }
        }

        private Brush color;
        public Brush Color
        {
            get { return color; }
            set
            {
                if (color != value)
                {
                    color = value;
                    OnPropertyChanged(nameof(Color));
                }

            }
        }

        private DartType type;

        public DartType Type
        {
            get { return type; }
            set
            {
                type = value;
                OnPropertyChanged(nameof(Type));
            }
        }



        public virtual String GetTypeString(String className = null)
        {

            var temp = Value;
            String result = null;

            while (temp is JArray)
            {
                if (result == null)
                    result = "List<{0}>";
                else
                    result = String.Format("List<{0}>", result);
                temp = temp.First;
            }

            if (result != null)
            {
                result = String.Format(result, className ?? DartHelper.GetDartTypeString(DartHelper.ConverDartType(temp?.Type ?? JTokenType.Object)));
            }

            return result ?? (className ?? DartHelper.GetDartTypeString(Type));
        }

        public virtual String GetBaseTypeString(String className = null)
        {
            if (className != null)
                return className;
            var temp = Value;
    
            while (temp is JArray)
            {
                temp = temp.First;
            }
            return DartHelper.GetDartTypeString(DartHelper.ConverDartType(temp?.Type ?? JTokenType.Object));
        }

        public String GetArraySetPropertyString(String setName, String typeString,String baseType=null, String className = null)
        {

            var temp = Value;
            StringBuilder sb = new StringBuilder();
           
            sb.AppendLine($"  final {typeString} {setName} = jsonRes['{Key}'] is List ? {typeString.Substring("List".Length)}[]: null; ");
            sb.AppendLine($"    if({setName}!=null) {{");
            bool enableTryCatch = ConfigHelper.Instance.Config.EnableArrayProtection;
            int count = 0;
            String result = null;
            while (temp is JArray)
            {
                temp = temp.First;
                //删掉List<
                typeString = typeString.Substring("List<".Length);
                //删掉>
                typeString = typeString.Substring(0, typeString.Length - 1);

               
                ///下层为数组
                if (temp != null && temp is JArray)
                {
                   // String type = className != null ? "List<dynamic>" : typeString.Replace(baseType, "dynamic");
                    if (count == 0)
                        result = $" for (final dynamic item{count} in asT<List<dynamic>>(jsonRes['{Key}'])) {{ if (item{count} != null) {{ final {typeString} items{count + 1} = {typeString.Substring("List".Length)}[]; {DartHelper.ReplaceSymbol} {setName}.add(items{count + 1}); }}}}";
                    else
                    {   
                        result = result.Replace(DartHelper.ReplaceSymbol, $" for (final dynamic item{count} in asT<List<dynamic>>(item{count - 1})) {{ if (item{count} != null) {{ final {typeString} items{count + 1} ={typeString.Substring("List".Length)} []; {DartHelper.ReplaceSymbol} items{count}.add(items{count + 1}); }}}}");
                    }
                }
                ///下层不为数组
                else
                {
                    String type = "dynamic";
                    var item = ("item" + (count == 0 ? "" : count.ToString()));
                    var addString = "";
                    if (className != null)
                    {
                        item = $"{className}.fromJson(asT<Map<String,dynamic>>({item}))";
                    }
                    else
                    {
                        item = $"asT<{baseType}>({item})";
                    }
            
                    if (count == 0)
                    {
                        addString = $"{setName}.add({item}); ";
                        if (enableTryCatch)
                        {
                            addString = $"tryCatch(() {{ {addString} }}); ";
                        }
                     
                        result = $" for (final {type} item in jsonRes['{Key}']) {{ if (item != null) {{ {addString} }} }}";
                    }
                    else
                    {
                        addString = $"items{count}.add({item}); ";

                        if (enableTryCatch)
                        {
                            addString = $"tryCatch(() {{ {addString} }}); ";
                        }

                     
                        result = result.Replace(DartHelper.ReplaceSymbol, $" for (final dynamic item{count} in asT<List<dynamic>>(item{count - 1}) ) {{ if (item{count} != null) {{ {addString} }} }}");
                    }
                }

                count++;
            }

            sb.AppendLine(result);
           // sb.AppendLine("    }");
            sb.AppendLine("    }\n");



            return sb.ToString();
        }

        private PropertyAccessorType propertyAccessorType;

        public PropertyAccessorType PropertyAccessorType
        {
            get { return propertyAccessorType; }
            set
            {
                propertyAccessorType = value;
                OnPropertyChanged(nameof(PropertyAccessorType));
            }
        }


        public ExtendedProperty(string uid, KeyValuePair<string, JToken> keyValuePair, int depth)
        {
            //this.depth = depth;
            this.Uid = uid + "_" + keyValuePair.Key;
            this.KeyValuePair = keyValuePair;
            UpdateNameByNamingConventionsType();
            this.type = DartHelper.ConverDartType(keyValuePair.Value.Type);
            PropertyAccessorType = ConfigHelper.Instance.Config.PropertyAccessorType;
        }

        public virtual void UpdateNameByNamingConventionsType()
        {
            switch (ConfigHelper.Instance.Config.PropertyNamingConventionsType)
            {
                case PropertyNamingConventionsType.None:
                    this.Name = KeyValuePair.Key;
                    break;
                case PropertyNamingConventionsType.CamelCase:
                    this.Name = CamelUnderScoreConverter.CamelName(KeyValuePair.Key);
                    break;
                case PropertyNamingConventionsType.Pascal:
                    this.Name = CamelUnderScoreConverter.UpcaseCamelName(KeyValuePair.Key);
                    break;
                case PropertyNamingConventionsType.HungarianNotation:
                    this.Name = CamelUnderScoreConverter.UnderScoreName(KeyValuePair.Key);
                    break;
                default:
                    this.Name = KeyValuePair.Key;
                    break;
            }
        }

        public virtual void UpdatePropertyAccessorType()
        {
            PropertyAccessorType = ConfigHelper.Instance.Config.PropertyAccessorType;
        }

    }
}
