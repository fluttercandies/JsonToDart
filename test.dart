import 'dart:convert' show json;

T asT<T>(dynamic value, [T defaultValue]) {
  if (value is T) {
    return value;
  }

  return defaultValue;
}

class Root {
  Root({
    this.status,
    this.data,
  });

  factory Root.fromJson(Map<dynamic, dynamic> jsonRes) => jsonRes == null
      ? null
      : Root(
          status: asT<String>(jsonRes['status']),
          data: Data.fromJson(asT<Map<dynamic, dynamic>>(jsonRes['data'])),
        );

  String status;
  Data data;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': status,
        'data': data,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class Data {
  Data({
    this.code,
    this.timestamp,
    this.version,
    this.result,
    this.message,
    this.dataItem,
  });

  factory Data.fromJson(Map<dynamic, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }
    final List<DataItem> dataItem =
        jsonRes['dataItem'] is List ? <DataItem>[] : null;
    if (dataItem != null) {
      for (final dynamic item in jsonRes['dataItem']) {
        if (item != null) {
          dataItem.add(DataItem.fromJson(asT<Map<dynamic, dynamic>>(item)));
        }
      }
    }

    return Data(
      code: asT<String>(jsonRes['code']),
      timestamp: asT<String>(jsonRes['timestamp']),
      version: asT<String>(jsonRes['version']),
      result: asT<String>(jsonRes['result']),
      message: asT<String>(jsonRes['message']),
      dataItem: dataItem,
    );
  }

  String code;
  String timestamp;
  String version;
  String result;
  String message;
  List<DataItem> dataItem;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'timestamp': timestamp,
        'version': version,
        'result': result,
        'message': message,
        'dataItem': dataItem,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class DataItem {
  DataItem({
    this.reportTime,
    this.live,
    this.forecastDate,
    this.weekday,
    this.forecastData,
  });

  factory DataItem.fromJson(Map<dynamic, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }
    final List<ForecastData> forecastData =
        jsonRes['forecastData'] is List ? <ForecastData>[] : null;
    if (forecastData != null) {
      for (final dynamic item in jsonRes['forecastData']) {
        if (item != null) {
          forecastData
              .add(ForecastData.fromJson(asT<Map<dynamic, dynamic>>(item)));
        }
      }
    }

    return DataItem(
      reportTime: asT<String>(jsonRes['report_time']),
      live: Live.fromJson(asT<Map<dynamic, dynamic>>(jsonRes['live'])),
      forecastDate: asT<String>(jsonRes['forecast_date']),
      weekday: asT<int>(jsonRes['weekday']),
      forecastData: forecastData,
    );
  }

  String reportTime;
  Live live;
  String forecastDate;
  int weekday;
  List<ForecastData> forecastData;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'report_time': reportTime,
        'live': live,
        'forecast_date': forecastDate,
        'weekday': weekday,
        'forecastData': forecastData,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class Live {
  Live({
    this.weatherName,
    this.list,
    this.list1,
    this.list2,
    this.list4,
    this.list3,
    this.list5,
    this.weatherCode,
    this.temperature,
  });

  factory Live.fromJson(Map<dynamic, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }
    final List<int> list = jsonRes['list'] is List ? <int>[] : null;
    if (list != null) {
      for (final dynamic item in jsonRes['list']) {
        if (item != null) {
          list.add(asT<int>(item));
        }
      }
    }

    final List<List<int>> list1 =
        jsonRes['list1'] is List ? <List<int>>[] : null;
    if (list1 != null) {
      for (final dynamic item0 in asT<List<dynamic>>(jsonRes['list1'])) {
        if (item0 != null) {
          final List<int> items1 = <int>[];
          for (final dynamic item1 in asT<List<dynamic>>(item0)) {
            if (item1 != null) {
              items1.add(asT<int>(item1));
            }
          }
          list1.add(items1);
        }
      }
    }

    final List<List2> list2 = jsonRes['list2'] is List ? <List2>[] : null;
    if (list2 != null) {
      for (final dynamic item in jsonRes['list2']) {
        if (item != null) {
          list2.add(List2.fromJson(asT<Map<dynamic, dynamic>>(item)));
        }
      }
    }

    final List<List<List4>> list4 =
        jsonRes['list4'] is List ? <List<List4>>[] : null;
    if (list4 != null) {
      for (final dynamic item0 in asT<List<dynamic>>(jsonRes['list4'])) {
        if (item0 != null) {
          final List<List4> items1 = <List4>[];
          for (final dynamic item1 in asT<List<dynamic>>(item0)) {
            if (item1 != null) {
              items1.add(List4.fromJson(asT<Map<dynamic, dynamic>>(item1)));
            }
          }
          list4.add(items1);
        }
      }
    }

    final List<List<List<List3>>> list3 =
        jsonRes['list3'] is List ? <List<List<List3>>>[] : null;
    if (list3 != null) {
      for (final dynamic item0 in asT<List<dynamic>>(jsonRes['list3'])) {
        if (item0 != null) {
          final List<List<List3>> items1 = <List<List3>>[];
          for (final dynamic item1 in asT<List<dynamic>>(item0)) {
            if (item1 != null) {
              final List<List3> items2 = <List3>[];
              for (final dynamic item2 in asT<List<dynamic>>(item1)) {
                if (item2 != null) {
                  items2.add(List3.fromJson(asT<Map<dynamic, dynamic>>(item2)));
                }
              }
              items1.add(items2);
            }
          }
          list3.add(items1);
        }
      }
    }

    final List<List<List<List<double>>>> list5 =
        jsonRes['list5'] is List ? <List<List<List<double>>>>[] : null;
    if (list5 != null) {
      for (final dynamic item0 in asT<List<dynamic>>(jsonRes['list5'])) {
        if (item0 != null) {
          final List<List<List<double>>> items1 = <List<List<double>>>[];
          for (final dynamic item1 in asT<List<dynamic>>(item0)) {
            if (item1 != null) {
              final List<List<double>> items2 = <List<double>>[];
              for (final dynamic item2 in asT<List<dynamic>>(item1)) {
                if (item2 != null) {
                  final List<double> items3 = <double>[];
                  for (final dynamic item3 in asT<List<dynamic>>(item2)) {
                    if (item3 != null) {
                      items3.add(asT<double>(item3));
                    }
                  }
                  items2.add(items3);
                }
              }
              items1.add(items2);
            }
          }
          list5.add(items1);
        }
      }
    }

    return Live(
      weatherName: asT<String>(jsonRes['weather_name']),
      list: list,
      list1: list1,
      list2: list2,
      list4: list4,
      list3: list3,
      list5: list5,
      weatherCode: asT<String>(jsonRes['weather_code']),
      temperature: asT<String>(jsonRes['temperature']),
    );
  }

  String weatherName;
  List<int> list;
  List<List<int>> list1;
  List<List2> list2;
  List<List<List4>> list4;
  List<List<List<List3>>> list3;
  List<List<List<List<double>>>> list5;
  String weatherCode;
  String temperature;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'weather_name': weatherName,
        'list': list,
        'list1': list1,
        'list2': list2,
        'list4': list4,
        'list3': list3,
        'list5': list5,
        'weather_code': weatherCode,
        'temperature': temperature,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class List2 {
  List2({
    this.index,
  });

  factory List2.fromJson(Map<dynamic, dynamic> jsonRes) => jsonRes == null
      ? null
      : List2(
          index: asT<int>(jsonRes['index']),
        );

  int index;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'index': index,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class List4 {
  List4({
    this.index,
  });

  factory List4.fromJson(Map<dynamic, dynamic> jsonRes) => jsonRes == null
      ? null
      : List4(
          index: asT<int>(jsonRes['index']),
        );

  int index;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'index': index,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class List3 {
  List3({
    this.index,
  });

  factory List3.fromJson(Map<dynamic, dynamic> jsonRes) => jsonRes == null
      ? null
      : List3(
          index: asT<int>(jsonRes['index']),
        );

  int index;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'index': index,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class ForecastData {
  ForecastData({
    this.windDirectionCode,
    this.windPowerCode,
    this.maxTemp,
    this.weatherCode,
    this.minTemp,
    this.weatherName,
    this.windPowerDesc,
    this.daynight,
    this.windDirectionDesc,
  });

  factory ForecastData.fromJson(Map<dynamic, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : ForecastData(
              windDirectionCode: asT<String>(jsonRes['wind_direction_code']),
              windPowerCode: asT<String>(jsonRes['wind_power_code']),
              maxTemp: asT<String>(jsonRes['max_temp']),
              weatherCode: asT<String>(jsonRes['weather_code']),
              minTemp: asT<String>(jsonRes['min_temp']),
              weatherName: asT<String>(jsonRes['weather_name']),
              windPowerDesc: asT<String>(jsonRes['wind_power_desc']),
              daynight: asT<int>(jsonRes['daynight']),
              windDirectionDesc: asT<String>(jsonRes['wind_direction_desc']),
            );

  String windDirectionCode;
  String windPowerCode;
  String maxTemp;
  String weatherCode;
  String minTemp;
  String weatherName;
  String windPowerDesc;
  int daynight;
  String windDirectionDesc;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'wind_direction_code': windDirectionCode,
        'wind_power_code': windPowerCode,
        'max_temp': maxTemp,
        'weather_code': weatherCode,
        'min_temp': minTemp,
        'weather_name': weatherName,
        'wind_power_desc': windPowerDesc,
        'daynight': daynight,
        'wind_direction_desc': windDirectionDesc,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}
