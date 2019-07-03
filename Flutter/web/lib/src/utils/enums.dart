    enum DartType 
    {
        string,
        int,
        object,
        bool,
        double,
    }


     enum PropertyAccessorType 
    {
        /// <summary>
        /// 默认
        /// </summary>
        none, 
        /// <summary>
        /// 只读
        /// </summary>
        Final,
        /// <summary>
        /// get
        /// </summary>
        get,
        /// <summary>
        /// get和set
        /// </summary>
        getSet,
    }


     enum PropertyNamingConventionsType 
    {
        /// <summary>
        /// 保持原样
        /// </summary>
        none ,
        /// <summary>
        /// 驼峰式命名小驼峰
        /// </summary>
        camelCase,
        /// <summary>
        /// 帕斯卡命名大驼峰
        /// </summary>
        pascal,
        /// <summary>
        /// 匈牙利命名下划线
        /// </summary>
        hungarianNotation
    }

    enum PropertyNameSortingType
    {
        None,
        Ascending,
        Descending,
    }