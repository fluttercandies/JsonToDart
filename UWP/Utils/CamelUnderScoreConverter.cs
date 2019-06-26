using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FlutterCandiesJsonToDart.Utils
{
    /// <summary>
    /// https://dart.dev/guides/language/effective-dart/style
    /// UpperCamelCase names capitalize the first letter of each word, including the first.

    /// lowerCamelCase names capitalize the first letter of each word, except the first which is always lowercase, even if it’s an acronym.

    /// lowercase_with_underscores use only lowercase letters, even for acronyms, and separate words with _.
    /// 
    /// 对于属性，方法推荐是lowerCamelCase
    /// </summary>
    public class CamelUnderScoreConverter
    {
        /// <summary>
        /// 驼峰转大写+下划线，abcAbcaBc->abc_abca_bc
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public static String UnderScoreName(String name)
        {
            if (String.IsNullOrWhiteSpace(name))
            {
                return "";
            }
            StringBuilder result = new StringBuilder();

            result.Append(name.Substring(0, 1).ToLower());
            for (int i = 1; i < name.Length; i++)
            {
                Char s = name[i];
                var temp = s.ToString();
                if ((temp.Equals(temp.ToUpper()) && (!Char.IsDigit(s))))
                {
                    result.Append("_");
                }
                result.Append(temp.ToLower());
            }


            return result.ToString();
        }

        /// <summary>
        /// 下划线转驼峰，abc_abca_bc->abcAbcaBc
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>

        public static String CamelName(String name)
        {
            StringBuilder result = new StringBuilder();
            if (String.IsNullOrWhiteSpace(name))
            {
                return "";
            }
            if (!name.Contains("_"))
            {
                result.Append(name.Substring(0, 1).ToLower());
                result.Append(name.Substring(1));
                return result.ToString();
            }
            String[] camels = name.Split('_');
            foreach (var camel in camels)
            {
                if (!String.IsNullOrWhiteSpace(name))
                {
                    if (result.Length == 0)
                    {
                        result.Append(camel.ToLower());
                    }
                    else
                    {
                        result.Append(camel.Substring(0, 1).ToUpper());
                        result.Append(camel.Substring(1).ToLower());
                    }
                }
            }

            return result.ToString();
        }

        /// <summary>
        /// 下划线转首字母大写驼峰，abc_abca_bc->AbcAbcaBc
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public static String UpcaseCamelName(String name)
        {
            StringBuilder result = new StringBuilder();
            if (String.IsNullOrWhiteSpace(name))
            {
                return "";
            }
            if (!name.Contains("_"))
            {
                result.Append(name.Substring(0, 1).ToUpper());
                result.Append(name.Substring(1));
                return result.ToString();
            }
            String[] camels = name.Split('_');
            foreach (var camel in camels)
            {
                if (!String.IsNullOrWhiteSpace(name))
                {
                    result.Append(camel.Substring(0, 1).ToUpper());
                    result.Append(camel.Substring(1).ToLower());
                }
            }

            return result.ToString();
        }
    }
}
