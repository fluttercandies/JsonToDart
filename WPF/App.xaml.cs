using FlutterCandiesJsonToDart.Utils;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;

namespace FlutterCandiesJsonToDart
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        public App()
        {
            Startup += App_Startup;
            Exit += App_Exit;
        }

        private void App_Exit(object sender, ExitEventArgs e)
        {
            ConfigHelper.Instance.Save();
        }

        private void App_Startup(object sender, StartupEventArgs e)
        {
            ConfigHelper.Instance.Initialize();
        }
    }
}
