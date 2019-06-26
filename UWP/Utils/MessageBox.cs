using System;



#if WINDOWS_UWP
using System.Threading.Tasks;
using Windows.Foundation;
using Windows.UI.Popups;
using System.Linq;
#else
using System.Windows;
#endif

namespace FlutterCandiesJsonToDart.Utils
{
#if WINDOWS_UWP
    public static class MyMessageBox
    {
        public static async Task<MessageBoxResult> AskAsync(string content, string title = null, bool reverseIndex = false)
        {
            return (MessageBoxResult)(await AskAsync(content, title, reverseIndex, "确认", "取消"));
        }

        public static async Task<int> AskAsync(string content, string title = null, bool reverseIndex = false, params string[] labels)
        {
            IUICommand[] commands = labels?.Select(label => new UICommand(label)).ToArray();
            IUICommand command = await Show(content, title, reverseIndex, commands);
            return (commands == null ? 0 : Array.IndexOf(commands, command));
        }

        public static IAsyncOperation<IUICommand> Show(string content, string title = null, bool reverseIndex = false, params IUICommand[] commands)
        {
            var dialog = (title == null ? new MessageDialog(content) : new MessageDialog(content, title));
            if (commands?.Length > 0)
            {
                foreach (IUICommand command in commands)
                {
                    dialog.Commands.Add(command);
                }

                if (reverseIndex)
                {
                    dialog.CancelCommandIndex = 0;
                    dialog.DefaultCommandIndex = (uint)(commands.Length - 1);
                }
                else
                {
                    dialog.DefaultCommandIndex = 0;
                    dialog.CancelCommandIndex = (uint)(commands.Length - 1);
                }
            }
            //dialog.Options = MessageDialogOptions.AcceptUserInputAfterDelay; // 对话框弹出后，短时间内禁止用户单击命令按钮，以防止用户的误操作
            return dialog.ShowAsync();
        }
    }

    public enum MessageBoxResult
    {
        OK,
        Cancel
    }
#else
    public static class MyMessageBox
    {
        public static void Show(String msg)
        {
            MessageBox.Show(msg);
        }
    }
#endif

}
