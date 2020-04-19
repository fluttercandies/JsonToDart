using FlutterCandiesJsonToDart.Utils;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FlutterCandiesJsonToDart.Models
{
    public class Config : BindableBase
    {
        private bool addMethod = true;
        /// <summary>
        /// 是否添加数据类型保护和数组保护的方法
        /// 第一次使用了之后，后面不必须再添加
        /// </summary>
        public bool AddMethod
        {
            get { return addMethod; }
            set
            {
                addMethod = value;
                OnPropertyChanged(nameof(AddMethod));
            }
        }


        private bool enableDataProtection;
        /// <summary>
        /// 数据类型保护
        /// </summary>
        public bool EnableDataProtection
        {
            get { return enableDataProtection; }
            set
            {
                enableDataProtection = value;
                OnPropertyChanged(nameof(EnableDataProtection));
            }
        }

        private bool enableArrayProtection;
        /// <summary>
        /// 循环数组的时候，防止出错一个，全部挂掉
        /// </summary>
        public bool EnableArrayProtection
        {
            get { return enableArrayProtection; }
            set
            {
                enableArrayProtection = value;
                OnPropertyChanged(nameof(EnableArrayProtection));
            }
        }

        private int traverseArrayCount = 1;

        /// <summary>
        /// 数组循环次数，通过遍历数组来merge属性，防止漏掉属性（有时候同一个类有不同的属性）
        /// List<T>
        /// 1,20,99
        /// </summary>
        public int TraverseArrayCount
        {
            get { return traverseArrayCount; }
            set
            {
                traverseArrayCount = value;
                OnPropertyChanged(nameof(TraverseArrayCount));
            }
        }

        private string fileHeaderInfo;
        /// <summary>
        /// 文件头部信息，作者，时间，详情等
        /// [time]
        /// </summary>
        public string FileHeaderInfo
        {
            get { return fileHeaderInfo; }
            set
            {
                fileHeaderInfo = value;
                OnPropertyChanged(nameof(FileHeaderInfo));
            }
        }


        private PropertyNamingConventionsType propertyNamingConventionsType;
        /// <summary>
        /// 属性命名规则
        /// </summary>
        public PropertyNamingConventionsType PropertyNamingConventionsType
        {
            get { return propertyNamingConventionsType; }
            set
            {
                propertyNamingConventionsType = value;
                OnPropertyChanged(nameof(PropertyNamingConventionsType));
            }
        }

        private PropertyAccessorType propertyAccessorType;
        /// <summary>
        /// 属性访问器
        /// </summary>
        public PropertyAccessorType PropertyAccessorType
        {
            get { return propertyAccessorType; }
            set
            {
                propertyAccessorType = value;
                OnPropertyChanged(nameof(PropertyAccessorType));
            }
        }

        private PropertyNameSortingType propertyNameSortingType;

        /// <summary>
        /// 根据属性名字升序/降序/不变排序
        /// </summary>
        public PropertyNameSortingType PropertyNameSortingType
        {
            get { return propertyNameSortingType; }
            set
            {
                propertyNameSortingType = value;
                OnPropertyChanged(nameof(PropertyAccessorType));
            }
        }


        private double column1Width = 1.5;

        public double Column1Width
        {
            get { return column1Width; }
            set { column1Width = value; }
        }

        private double column2Width = 2.0;

        public double Column2Width
        {
            get { return column2Width; }
            set { column2Width = value; }
        }


    }
}
