using FlutterCandiesJsonToDart.Models;
using FlutterCandiesJsonToDart.Utils;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.Net.Http;
using System.Net.Http.Headers;


#if WINDOWS_UWP
using Windows.UI;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Media;
using Windows.ApplicationModel.DataTransfer;
using System.Xml.Linq;
using Windows.Data.Xml.Dom;
using Windows.UI.Notifications;
#else
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows;
using System.Windows.Data;
using System.Windows.Input;
#endif



// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=402352&clcid=0x409

namespace FlutterCandiesJsonToDart
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
#if WINDOWS_UWP
    public sealed partial class MainPage : Page
#elif SILVERLIGHT
    public partial class MainPage : UserControl
#else
    public partial class MainWindow : Window
#endif

    {
        List<DartType> DartTypes = Enum.GetValues(typeof(DartType)).Cast<DartType>().ToList();

        List<PropertyAccessorType> PropertyAccessorTypes = Enum.GetValues(typeof(PropertyAccessorType)).Cast<PropertyAccessorType>().ToList();

        ExtendedJObject extendedJObject;
        JObject obj;
#if WINDOWS_UWP
        public MainPage()
#elif SILVERLIGHT
        public MainPage()
#else
        public MainWindow()
#endif

        {
            this.InitializeComponent();
            settingSp.DataContext = propertyAccessorComboBox.DataContext = ConfigHelper.Instance.Config;
            TraverseArrayCountComboBox.ItemsSource = new List<int>() { 1, 20, 99 };
            propertyAccessorComboBox.ItemsSource = PropertyAccessorTypes;
            Column1.Width = new GridLength(ConfigHelper.Instance.Config.Column1Width, GridUnitType.Star);
            Column2.Width = new GridLength(ConfigHelper.Instance.Config.Column2Width, GridUnitType.Star);
#if !WINDOWS_UWP
            //this.Background = new SolidColorBrush(Color.FromArgb(1, 0, 0, 0));
            this.MouseMove += GridSplitter_ManipulationDelta;
#if SILVERLIGHT
            this.MouseLeftButtonUp += GridSplitter_PointerReleased;
#else
            this.MouseUp += GridSplitter_PointerReleased;
            WindowStartupLocation = WindowStartupLocation.CenterScreen;
#endif
#endif

        }

        //Dictionary<String, ExtendedJObject> objects = new Dictionary<string, ExtendedJObject>();

        private string FormatJson(string str)
        {
            if (str == null || str == "")
                return "";

            obj = null;
            extendedJObject = null;
            ShowProgressRing();
            try
            {
                //格式化json字符串
                JsonSerializer serializer = new JsonSerializer();

                obj = JObject.Parse(str);
                GenerateExtendOject();
                HideProgressRing();
                if (obj != null)
                {
                    StringWriter textWriter = new StringWriter();
                    JsonTextWriter jsonWriter = new JsonTextWriter(textWriter)
                    {
                        Formatting = Formatting.Indented,
                        Indentation = 4,
                        IndentChar = ' '
                    };
                    serializer.Serialize(jsonWriter, obj);
                    return textWriter.ToString();
                }
                else
                {
                    return str;
                }
            }
            catch (Exception ex)
            {
                HideProgressRing();
                obj = null;
                extendedJObject = null;
                sp.Children.Clear();
                MyMessageBox.Show(ex.Message + "\n" + ex.StackTrace);
                return str;
            }



        }

        private void GenerateExtendOject()
        {
            try
            {
                extendedJObject = null;
                extendedJObject = new ExtendedJObject("Root", new KeyValuePair<string, JToken>("Root", obj), 0);
                //PrepareOject(extendedJObject);
                sp.Children.Clear();
                DrawOject(extendedJObject);
            }
            catch (Exception ex)
            {
                HideProgressRing();
                obj = null;
                extendedJObject = null;
                sp.Children.Clear();
                MyMessageBox.Show(ex.Message + "\n" + ex.StackTrace);
            }

        }

        void DrawOject(ExtendedJObject s, int depth = 0)
        {
            ///root
            if (s.Depth == 0)
            {
                DrawPoperty(s, s, false, isObject: true, depth: -1);
            }

            foreach (var item in s.Properties)
            {

                bool isArray = item.JType == JTokenType.Array;
                bool isObject = item.JType == JTokenType.Object && item.Value.Count() > 0;

                DrawPoperty(s, item, isArray: isArray, isObject: isObject, depth: depth);

                if (isObject)
                {
                    DrawOject(s.ObjectKeys[item.Key], depth: depth);
                }
                else if (isArray)
                {
                    var array = item.Value as JArray;
                    if (s.ObjectKeys.ContainsKey(item.Key))
                    {
                        var oject = s.ObjectKeys[item.Key];
                        DrawPoperty(s, oject, depth: depth + 1, isArrayOject: true, isObject: true);
                        DrawOject(oject, depth: depth + 2);
                    }

                }

            }
        }

        private void DrawPoperty(ExtendedJObject s, ExtendedProperty property, bool isArray = false, bool isObject = false, int depth = 0, bool isArrayOject = false)
        {

            var finalDepth = s.Depth + depth + 1;

            double w = 20.0;

            Grid grid = new Grid()
            {
                Height = 40.0,
#if WINDOWS_UWP
                BorderBrush = new SolidColorBrush() { Color = Colors.Black },
                BorderThickness = new Thickness() { Bottom = 1.0 },
#endif


                HorizontalAlignment = HorizontalAlignment.Stretch,
                VerticalAlignment = VerticalAlignment.Stretch
            };
            grid.ColumnDefinitions.Add(new ColumnDefinition() { Width = new GridLength(3, GridUnitType.Star) });
            grid.ColumnDefinitions.Add(new ColumnDefinition() { Width = new GridLength(1, GridUnitType.Star) });
            grid.ColumnDefinitions.Add(new ColumnDefinition() { Width = new GridLength(1, GridUnitType.Star) });
            grid.ColumnDefinitions.Add(new ColumnDefinition() { Width = new GridLength(1, GridUnitType.Star) });

            var tb = new TextBlock() { VerticalAlignment = VerticalAlignment.Center, Text = isArrayOject ? DartType.Object.ToString() : property.Key, Padding = new Thickness() { Left = w * finalDepth } };

            Grid.SetColumn(tb, 0);

            grid.Children.Add(tb);



            if (isArray)
            {
                var array = property.Value as JArray;
                Border border = new Border() { Padding = new Thickness() { Left = 10.0 }, BorderBrush = new SolidColorBrush(Colors.Black), HorizontalAlignment = HorizontalAlignment.Stretch, VerticalAlignment = VerticalAlignment.Stretch, BorderThickness = new Thickness() { Left = 1.0 } };

                if (s.ObjectKeys.ContainsKey(property.Key))
                {
                    var oject = s.ObjectKeys[property.Key];
                    var typeString = property.GetTypeString(className: oject.ClassName);
                    String[] ss;
                    String start;
                    String end;
                    if (oject.ClassName != "")
                    {
                        typeString = typeString.Replace($"<{oject.ClassName}>", "<>");
                    }

                    ss = typeString.Split(new string[] { "<>" }, StringSplitOptions.None);
                    start = ss[0] + "<";
                    end = ">" + ss[1];


                    StackPanel sp = new StackPanel() { Orientation = Orientation.Horizontal, VerticalAlignment = VerticalAlignment.Center };
                    sp.Children.Add(new TextBlock() { Text = start });
                    var temp = new TextBlock();
                    Binding binding = new Binding();
                    binding.Source = oject;
                    binding.Mode = BindingMode.OneWay;
                    binding.UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged;
                    binding.Path = new PropertyPath("ClassName");
                    temp.SetBinding(TextBlock.TextProperty, binding);
                    sp.Children.Add(temp);
                    sp.Children.Add(new TextBlock() { Text = end });
                    border.Child = sp;

                }
                else
                {
                    tb = new TextBlock() { Text = property.GetTypeString(), VerticalAlignment = VerticalAlignment.Center };
                    border.Child = tb;
                }


                Grid.SetColumn(border, 1);
                grid.Children.Add(border);

            }
            else if (isObject)
            {
                Border border = new Border()
                {

#if !WINDOWS_UWP
                    Padding = new Thickness() { Left = 8.0 },
#endif
                    BorderBrush = new SolidColorBrush(Colors.Black),
                    HorizontalAlignment = HorizontalAlignment.Stretch,
                    VerticalAlignment = VerticalAlignment.Stretch,
                    BorderThickness = new Thickness() { Left = 1.0 }
                };
                var textBox = new TextBox() { VerticalContentAlignment = VerticalAlignment.Center, HorizontalAlignment = HorizontalAlignment.Stretch, VerticalAlignment = VerticalAlignment.Center, BorderThickness = new Thickness() };
                border.Child = textBox;

                Binding binding = new Binding();
                binding.Source = property;
                binding.Mode = BindingMode.TwoWay;
                binding.UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged;
                binding.Path = new PropertyPath("ClassName");
                textBox.SetBinding(TextBox.TextProperty, binding);

                Binding colorBinding = new Binding();
                colorBinding.Source = property;
                colorBinding.Mode = BindingMode.TwoWay;
                colorBinding.UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged;
                colorBinding.Path = new PropertyPath("ClassNameColor");
                border.SetBinding(Border.BackgroundProperty, colorBinding);
                textBox.SetBinding(TextBox.BackgroundProperty, colorBinding);

                Grid.SetColumn(border, 1);
                grid.Children.Add(border);
            }
            else
            {
                ComboBox combo = new ComboBox() { VerticalContentAlignment = VerticalAlignment.Center, HorizontalAlignment = HorizontalAlignment.Stretch, VerticalAlignment = VerticalAlignment.Stretch, BorderThickness = new Thickness() { Left = 1.0 } };
                Binding binding = new Binding();
                binding.Source = property;
                binding.Mode = BindingMode.TwoWay;
                binding.UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged;
                binding.Path = new PropertyPath("Type");
                combo.SetBinding(ComboBox.SelectedItemProperty, binding);
                combo.ItemsSource = DartTypes;
                Grid.SetColumn(combo, 1);
                grid.Children.Add(combo);
            }


            if (finalDepth > 0 && !isArrayOject)
            {

                Border border = new Border() { BorderBrush = new SolidColorBrush(Colors.Black), HorizontalAlignment = HorizontalAlignment.Stretch, VerticalAlignment = VerticalAlignment.Stretch, BorderThickness = new Thickness() { Left = 1.0 } };
                var textBox = new TextBox()
                {
#if !WINDOWS_UWP
                    //Margin = new Thickness() { Left = 10.0 },
#endif
                    VerticalContentAlignment = VerticalAlignment.Center,
                    HorizontalAlignment = HorizontalAlignment.Center,
                    VerticalAlignment = VerticalAlignment.Center,
                    HorizontalContentAlignment = HorizontalAlignment.Center,
                    BorderThickness = new Thickness()
                };
                border.Child = textBox;
                Binding binding = new Binding();
                binding.Source = property;
                binding.Mode = BindingMode.TwoWay;
                binding.UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged;
                binding.Path = new PropertyPath("Name");
                textBox.SetBinding(TextBox.TextProperty, binding);

                Binding colorBinding = new Binding();
                colorBinding.Source = property;
                colorBinding.Mode = BindingMode.TwoWay;
                colorBinding.UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged;
                colorBinding.Path = new PropertyPath("Color");
                border.SetBinding(Border.BackgroundProperty, colorBinding);
                textBox.SetBinding(TextBox.BackgroundProperty, colorBinding);

                Grid.SetColumn(border, 2);

                grid.Children.Add(border);
            }
            else
            {
                Border border = new Border() { Background = new SolidColorBrush(Colors.Gray), HorizontalAlignment = HorizontalAlignment.Stretch, VerticalAlignment = VerticalAlignment.Stretch, };
                Grid.SetColumn(border, 2);

                grid.Children.Add(border);
            }
            if (finalDepth > 0 && !isArrayOject)
            {

                ComboBox typeCombo = new ComboBox() { ItemsSource = PropertyAccessorTypes, VerticalContentAlignment = VerticalAlignment.Center, HorizontalAlignment = HorizontalAlignment.Stretch, VerticalAlignment = VerticalAlignment.Stretch, BorderThickness = new Thickness() { Left = 1.0 }, BorderBrush = new SolidColorBrush(Colors.Black) };
                Binding typeBinding = new Binding();
                typeBinding.Source = property;
                typeBinding.Mode = BindingMode.TwoWay;
                typeBinding.UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged;
                typeBinding.Path = new PropertyPath("PropertyAccessorType");
                typeCombo.SetBinding(ComboBox.SelectedItemProperty, typeBinding);
                ToolTipService.SetPlacement(typeCombo,
#if WINDOWS_UWP
                    Windows.UI.Xaml.Controls.Primitives.PlacementMode.Mouse
#else
                    System.Windows.Controls.Primitives.PlacementMode.Mouse
#endif

                    );
                ToolTipService.SetToolTip(typeCombo, new ToolTip() { Content = "属性访问器的类型，无，Get，GetSet" });
                //oolTipService.se
                Grid.SetColumn(typeCombo, 3);
                grid.Children.Add(typeCombo);
            }
            else
            {
                Border border = new Border() { Background = new SolidColorBrush(Colors.Gray), HorizontalAlignment = HorizontalAlignment.Stretch, VerticalAlignment = VerticalAlignment.Stretch, };
                Grid.SetColumn(border, 3);

                grid.Children.Add(border);
            }
#if WINDOWS_UWP
            sp.Children.Add(grid);
#else

            sp.Children.Add(new Border() { Child = grid, BorderBrush = new SolidColorBrush() { Color = Colors.Black }, BorderThickness = new Thickness() { Bottom = 1.0 }, });
#endif



        }

        private void FormatButton_Click(object sender, RoutedEventArgs e)
        {
            tb.Text = FormatJson(tb.Text);
        }

        private async void GenerateButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (extendedJObject != null)
                {
                    var msg = extendedJObject.HasEmptyProperties();
                    if (msg != null)
                    {
                        MyMessageBox.Show(msg);
                        return;
                    }

                }
                if (extendedJObject != null)
                {
                    StringBuilder sb = new StringBuilder();
                    if (!String.IsNullOrWhiteSpace(ConfigHelper.Instance.Config.FileHeaderInfo))
                    {
                        var info = ConfigHelper.Instance.Config.FileHeaderInfo;
                        //[Date MM-dd HH:mm]
                        try
                        {
                            var start = info.IndexOf("[Date");
                            var startIndex = start;
                            if (start >= 0)
                            {
                                start = start + "[Date".Length;
                                var end = info.IndexOf("]", start);
                                if (end >= start)
                                {
                                    var format = info.Substring(start, end - start).Trim();

                                    var replaceString = info.Substring(startIndex, end - startIndex + 1);
                                    if (format == null || format == "")
                                    {
                                        format = "yyyy MM-dd";
                                    }

                                    info = info.Replace(replaceString, DateTime.Now.ToString(format));
                                }
                            }

                        }
                        catch (Exception ex)
                        {

                            MyMessageBox.Show("[Date]时间格式有问题");
                        }

                        sb.AppendLine(info);
                        sb.AppendLine("");
                    }

                    sb.AppendLine(DartHelper.JsonImport);
   
                    if(ConfigHelper.Instance.Config.AddMethod)
                    {
                        if(ConfigHelper.Instance.Config.EnableArrayProtection)
                        {
                            sb.AppendLine(DartHelper.DebugPrintImport);
                            sb.AppendLine("");
                            sb.AppendLine(DartHelper.TryCatchMethod);
                            sb.AppendLine("");
                        }
                        sb.AppendLine(ConfigHelper.Instance.Config.EnableDataProtection ? DartHelper.AsTMethodWithDataProtection : DartHelper.AsTMethod);
                        sb.AppendLine("");
                    }
                 


                    sb.AppendLine(extendedJObject.ToString());

                    var result = sb.ToString();
#if WINDOWS_UWP || WPF


                    result =await DartHelper.FormatCode(result);

#endif

                    tb.Text = result;

#if WINDOWS_UWP
                    var dp = new DataPackage();
                    dp.SetText(result);
                    Clipboard.SetContent(dp);


                    XDocument xd = XDocument.Load("Assets/Toast.xml");
                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(xd.ToString());
                    ToastNotification notification = new ToastNotification(doc);
                    notification.ExpirationTime = DateTime.Now.AddSeconds(2);
                    ToastNotificationManager.CreateToastNotifier().Show(notification);
#else


                    Clipboard.SetText(result);
                    MyMessageBox.Show("Dart生成成功\n已复制到剪切板");
#endif
                }
            }
            catch (Exception ex)
            {
                HideProgressRing();
                MyMessageBox.Show(ex.Message + "\n" + ex.StackTrace);
            }

        }

        void ShowProgressRing()
        {
            progressRing.Visibility = Visibility.Visible;
        }

        void HideProgressRing()
        {
            progressRing.Visibility = Visibility.Collapsed;
        }

        private void PropertyNamingConventionsTypeComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            extendedJObject?.UpdateNameByNamingConventionsType();
        }

        private void PropertyNameSortingTypeComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (extendedJObject != null && obj != null)
            {
                sp.Children.Clear();
                if (ConfigHelper.Instance.Config.PropertyNameSortingType == PropertyNameSortingType.None)
                {
                    extendedJObject = new ExtendedJObject("Root", new KeyValuePair<string, JToken>("Root", obj), 0);
                }
                else
                {
                    extendedJObject.OrderPropeties();
                }


                DrawOject(extendedJObject);
            }
        }

        private void TraverseArrayCountComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (obj != null)
            {
                GenerateExtendOject();
            }
        }

        private void PropertyAccessorComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (extendedJObject != null)
            {
                extendedJObject.UpdatePropertyAccessorType();
            }
        }

        private void SettingButton_Click(object sender, RoutedEventArgs e)
        {
            if (settingSp.Visibility == Visibility.Collapsed)
            {
                settingSp.Visibility = Visibility.Visible;
            }
            else
            {
                settingSp.Visibility = Visibility.Collapsed;
            }

        }



#if WINDOWS_UWP
        private void GridSplitter_ManipulationDelta(object sender, Windows.UI.Xaml.Input.ManipulationDeltaRoutedEventArgs e)
        {
            UpdateGridSplitter(e.Delta.Translation.X);
        }

        private void GridSplitter_PointerPressed(object sender, Windows.UI.Xaml.Input.PointerRoutedEventArgs e)
        {
            pointerPressed = true;
            Window.Current.CoreWindow.PointerCursor = new Windows.UI.Core.CoreCursor(Windows.UI.Core.CoreCursorType.SizeWestEast, 1);
        }

        private void GridSplitter_PointerReleased(object sender, Windows.UI.Xaml.Input.PointerRoutedEventArgs e)
        {
            pointerPressed = false;
            Window.Current.CoreWindow.PointerCursor = new Windows.UI.Core.CoreCursor(Windows.UI.Core.CoreCursorType.Arrow, 1);
        }

        private void GridSplitter_PointerEntered(object sender, Windows.UI.Xaml.Input.PointerRoutedEventArgs e)
        {
            Window.Current.CoreWindow.PointerCursor = new Windows.UI.Core.CoreCursor(Windows.UI.Core.CoreCursorType.SizeWestEast, 1);
        }

        private void GridSplitter_PointerExited(object sender, Windows.UI.Xaml.Input.PointerRoutedEventArgs e)
        {
            if (pointerPressed)
                return;
            Window.Current.CoreWindow.PointerCursor = new Windows.UI.Core.CoreCursor(Windows.UI.Core.CoreCursorType.Arrow, 1);
        }
#else


        private void GridSplitter_ManipulationDelta(object sender, MouseEventArgs e)
        {
            if (pointerPressed)
                UpdateGridSplitter(e.GetPosition(GridSplitter).X - point.X);
        }

        private void GridSplitter_PointerExited(object sender, System.Windows.Input.MouseEventArgs e)
        {
            if (pointerPressed)
                return;
#if SILVERLIGHT
            this.Cursor = Cursors.Arrow;
#else
            Application.Current.MainWindow.Cursor = Cursors.Arrow;
#endif
        }

        private void GridSplitter_PointerEntered(object sender, System.Windows.Input.MouseEventArgs e)
        {
#if SILVERLIGHT
            this.Cursor = Cursors.SizeWE;
#else
            Application.Current.MainWindow.Cursor = Cursors.SizeWE;
#endif
        }

        private void GridSplitter_PointerReleased(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            pointerPressed = false;
#if SILVERLIGHT
            this.Cursor = Cursors.Arrow;
#else
            Application.Current.MainWindow.Cursor = Cursors.Arrow;
#endif
        }
        Point point;

        private void GridSplitter_PointerPressed(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            pointerPressed = true;
            point = e.GetPosition(GridSplitter);
#if SILVERLIGHT
            this.Cursor = Cursors.SizeWE;
#else
            Application.Current.MainWindow.Cursor = Cursors.SizeWE;
#endif
        }

#endif

        bool pointerPressed = false;
        private void UpdateGridSplitter(double x)
        {
            var width1 = Math.Max(Column1.ActualWidth + x, 50.0);
            var width2 = Math.Max(Column2.ActualWidth - x, 50.0);
            ConfigHelper.Instance.Config.Column1Width = width1 / (width1 + width2);
            ConfigHelper.Instance.Config.Column2Width = width2 / (width1 + width2);
            Column1.Width = new GridLength(ConfigHelper.Instance.Config.Column1Width, GridUnitType.Star);
            Column2.Width = new GridLength(ConfigHelper.Instance.Config.Column2Width, GridUnitType.Star);
        }

    }
}





