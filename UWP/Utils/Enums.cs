using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FlutterCandiesJsonToDart.Utils
{

    public enum DartType : int
    {
        String=0,
        Int,
        Object,
        Bool,
        Double,
    }


    public enum PropertyAccessorType : int
    {
        /// <summary>
        /// 默认
        /// </summary>
        None=0,
        /// <summary>
        /// 只读
        /// </summary>
        Get,
        /// <summary>
        /// get和set
        /// </summary>
        GetSet,
    }


    public enum PropertyNamingConventionsType : int
    {
        /// <summary>
        /// 保持原样
        /// </summary>
        None=0,
        /// <summary>
        /// 驼峰式命名小驼峰
        /// </summary>
        CamelCase,
        /// <summary>
        /// 帕斯卡命名大驼峰
        /// </summary>
        Pascal,
        /// <summary>
        /// 匈牙利命名下划线
        /// </summary>
        HungarianNotation
    }

    public enum PropertyNameSortingType : int
    {
        None,
        Ascending,
        Descending,
    }
}
