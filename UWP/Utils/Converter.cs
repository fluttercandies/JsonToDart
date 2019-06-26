using System;
using System.Globalization;
#if WINDOWS_UWP
using Windows.UI.Xaml.Data;
#else
using System.Windows.Data;
#endif



namespace FlutterCandiesJsonToDart.Utils
{
#if WINDOWS_UWP
    public class PropertyNameSortingTypeConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, string language)
        {
            return (int)value;
        }

        public object ConvertBack(object value, Type targetType, object parameter, string language)
        {
            return (PropertyNameSortingType)value;
        }
    }
    public class PropertyNamingConventionsTypeConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, string language)
        {
            return (int)value;
        }

        public object ConvertBack(object value, Type targetType, object parameter, string language)
        {
            return (PropertyNamingConventionsType)value;
        }
    }
#else
    public class PropertyNameSortingTypeConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return (int)value;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return (PropertyNameSortingType)value;
        }
    }
    public class PropertyNamingConventionsTypeConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return (int)value;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return (PropertyNamingConventionsType)value;
        }
    }
#endif

}
