using FlutterCandiesJsonToDart.Models;
using Newtonsoft.Json;
using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;
#if WINDOWS_UWP
using Windows.Storage;
#endif


namespace FlutterCandiesJsonToDart.Utils
{
    public class ConfigHelper
    {
        public static ConfigHelper Instance;
        public const string FileName = "JsonToDartConfig.txt";
        private object sync = new object();
        static ConfigHelper()
        {
            Instance = new ConfigHelper();
        }

#if WINDOWS_UWP
        private StorageFile file;
#else
        private FileStream file;
#endif


        public Config Config { get; private set; }
        private ConfigHelper()
        {
            Config = new Config();
        }
#if WINDOWS_UWP
       
        private StreamWriter _streamWriter;
        public async Task Initialize()
        {
            try
            {
                var localFolder = ApplicationData.Current.LocalFolder;
                file = await localFolder.CreateFileAsync(FileName, CreationCollisionOption.OpenIfExists);
                if (file != null)
                {
                    using (Stream stream = await file.OpenStreamForReadAsync())
                    {
                        byte[] result = new byte[stream.Length];
                        await stream.ReadAsync(result, 0, (int)stream.Length);
                        var content = Encoding.UTF8.GetString(result, 0, result.Length);

                        var temp = JsonConvert.DeserializeObject<Config>(content);
                        if (temp != null)
                        {
                            this.Config = temp;
                        }
                    }
                    _streamWriter?.Dispose();
                    var stream1 = await file.OpenStreamForWriteAsync();
                    stream1.Seek(0, SeekOrigin.Begin);
                    _streamWriter = new StreamWriter(stream1);
                }

            }
            catch (Exception e)
            {
            }
        }
        public void Dispose()
        {
            _streamWriter?.Dispose();
        }

        public void Save()
        {
            lock (sync)
            {
                try
                {
                    var json = JsonConvert.SerializeObject(Config);
                    if (json != preJson)
                    {
                        if (_streamWriter != null)
                        {
                            _streamWriter.BaseStream?.SetLength(0);
                            _streamWriter.BaseStream?.Seek(0, SeekOrigin.Begin);
                            _streamWriter.Write(json);
                            _streamWriter.Flush();
                        }
                        preJson = json;
                    }
                }
                catch (Exception e)
                {
                }
            }
        }

#else

        public void Initialize()
        {
            try
            {

                if (File.Exists(AppDomain.CurrentDomain.BaseDirectory + FileName))
                {
                    System.IO.StreamReader sr = new System.IO.StreamReader(AppDomain.CurrentDomain.BaseDirectory + FileName, Encoding.UTF8);
                    String content = sr.ReadToEnd();
                    var temp = JsonConvert.DeserializeObject<Config>(content);
                    if (temp != null)
                    {
                        this.Config = temp;
                    }
                    sr.Close();
                }
                else
                {
                    File.Create(AppDomain.CurrentDomain.BaseDirectory + FileName);
                }
            }
            catch (Exception e)
            {
            }
        }
        public void Save()
        {
            lock (sync)
            {
                try
                {
                    var json = JsonConvert.SerializeObject(Config);
                    if (json != preJson)
                    {
                        FileStream fs = new FileStream(AppDomain.CurrentDomain.BaseDirectory + FileName, FileMode.Append);
                        StreamWriter sw = new StreamWriter(fs);
                        sw.Write(json);
                        sw.Flush();
                        sw.Close();
                        fs.Close();

                        preJson = json;
                    }
                }
                catch (Exception e)
                {
                }
            }
        }

#endif
        string preJson = "";



    }
}
