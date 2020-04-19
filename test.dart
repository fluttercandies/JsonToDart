import 'dart:convert' show json;
//import 'package:flutter/foundation.dart';

void tryCatch(Function f) {
  try {
    f?.call();
  } catch (e, stack) {
    // debugPrint('$e');
    // debugPrint('$stack');
  }
}

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  if (value != null) {
    final String valueS = value.toString();
    if (0 is T) {
      return int.tryParse(valueS) as T;
    } else if (0.0 is T) {
      return double.tryParse(valueS) as T;
    } else if ('' is T) {
      return valueS as T;
    } else if (false is T) {
      if (valueS == '0' || valueS == '1') {
        return (valueS == '1') as T;
      }
      return bool.fromEnvironment(value.toString()) as T;
    }
  }
  return null;
}

class Root {
  Root({
    this.data,
    this.status,
  });

  factory Root.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : Root(
          data: Data.fromJson(asT<Map<String, dynamic>>(jsonRes['data'])),
          status: asT<String>(jsonRes['status']),
        );

  final Data data;
  final String status;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data,
        'status': status,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Data {
  Data({
    this.code,
    this.dataItem,
    this.message,
    this.result,
    this.timestamp,
    this.version,
  });

  factory Data.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<DataItem> dataItem =
        jsonRes['dataItem'] is List ? <DataItem>[] : null;
    if (dataItem != null) {
      for (final dynamic item in jsonRes['dataItem']) {
        if (item != null) {
          tryCatch(() {
            dataItem.add(DataItem.fromJson(asT<Map<String, dynamic>>(item)));
          });
        }
      }
    }
    return Data(
      code: asT<String>(jsonRes['code']),
      dataItem: dataItem,
      message: asT<String>(jsonRes['message']),
      result: asT<String>(jsonRes['result']),
      timestamp: asT<String>(jsonRes['timestamp']),
      version: asT<String>(jsonRes['version']),
    );
  }

  final String code;
  final List<DataItem> dataItem;
  final String message;
  final String result;
  final String timestamp;
  final String version;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'dataItem': dataItem,
        'message': message,
        'result': result,
        'timestamp': timestamp,
        'version': version,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class DataItem {
  DataItem({
    this.forecastData,
    this.forecastDate,
    this.live,
    this.reportTime,
    this.weekday,
  });

  factory DataItem.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<ForecastData> forecastData =
        jsonRes['forecastData'] is List ? <ForecastData>[] : null;
    if (forecastData != null) {
      for (final dynamic item in jsonRes['forecastData']) {
        if (item != null) {
          tryCatch(() {
            forecastData
                .add(ForecastData.fromJson(asT<Map<String, dynamic>>(item)));
          });
        }
      }
    }
    return DataItem(
      forecastData: forecastData,
      forecastDate: asT<String>(jsonRes['forecast_date']),
      live: Live.fromJson(asT<Map<String, dynamic>>(jsonRes['live'])),
      reportTime: asT<String>(jsonRes['report_time']),
      weekday: asT<int>(jsonRes['weekday']),
    );
  }

  final List<ForecastData> forecastData;
  final String forecastDate;
  final Live live;
  final String reportTime;
  final int weekday;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'forecastData': forecastData,
        'forecast_date': forecastDate,
        'live': live,
        'report_time': reportTime,
        'weekday': weekday,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Live {
  Live({
    this.list,
    this.list1,
    this.list2,
    this.list3,
    this.list4,
    this.list5,
    this.temperature,
    this.weatherCode,
    this.weatherName,
  });

  factory Live.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<int> list = jsonRes['list'] is List ? <int>[] : null;
    if (list != null) {
      for (final dynamic item in jsonRes['list']) {
        if (item != null) {
          tryCatch(() {
            list.add(asT<int>(item));
          });
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
              tryCatch(() {
                items1.add(asT<int>(item1));
              });
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
          tryCatch(() {
            list2.add(List2.fromJson(asT<Map<String, dynamic>>(item)));
          });
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
                  tryCatch(() {
                    items2
                        .add(List3.fromJson(asT<Map<String, dynamic>>(item2)));
                  });
                }
              }
              items1.add(items2);
            }
          }
          list3.add(items1);
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
              tryCatch(() {
                items1.add(List4.fromJson(asT<Map<String, dynamic>>(item1)));
              });
            }
          }
          list4.add(items1);
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
                      tryCatch(() {
                        items3.add(asT<double>(item3));
                      });
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
      list: list,
      list1: list1,
      list2: list2,
      list3: list3,
      list4: list4,
      list5: list5,
      temperature: asT<String>(jsonRes['temperature']),
      weatherCode: asT<String>(jsonRes['weather_code']),
      weatherName: asT<String>(jsonRes['weather_name']),
    );
  }

  final List<int> list;
  final List<List<int>> list1;
  final List<List2> list2;
  final List<List<List<List3>>> list3;
  final List<List<List4>> list4;
  final List<List<List<List<double>>>> list5;
  final String temperature;
  final String weatherCode;
  final String weatherName;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'list': list,
        'list1': list1,
        'list2': list2,
        'list3': list3,
        'list4': list4,
        'list5': list5,
        'temperature': temperature,
        'weather_code': weatherCode,
        'weather_name': weatherName,
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

  factory List2.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : List2(
          index: asT<int>(jsonRes['index']),
        );

  final int index;

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

  factory List4.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : List4(
          index: asT<int>(jsonRes['index']),
        );

  final int index;

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

  factory List3.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : List3(
          index: asT<int>(jsonRes['index']),
        );

  final int index;

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
    this.daynight,
    this.maxTemp,
    this.minTemp,
    this.weatherCode,
    this.weatherName,
    this.windDirectionCode,
    this.windDirectionDesc,
    this.windPowerCode,
    this.windPowerDesc,
  });

  factory ForecastData.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : ForecastData(
          daynight: asT<int>(jsonRes['daynight']),
          maxTemp: asT<String>(jsonRes['max_temp']),
          minTemp: asT<String>(jsonRes['min_temp']),
          weatherCode: asT<String>(jsonRes['weather_code']),
          weatherName: asT<String>(jsonRes['weather_name']),
          windDirectionCode: asT<String>(jsonRes['wind_direction_code']),
          windDirectionDesc: asT<String>(jsonRes['wind_direction_desc']),
          windPowerCode: asT<String>(jsonRes['wind_power_code']),
          windPowerDesc: asT<String>(jsonRes['wind_power_desc']),
        );

  final int daynight;
  final String maxTemp;
  final String minTemp;
  final String weatherCode;
  final String weatherName;
  final String windDirectionCode;
  final String windDirectionDesc;
  final String windPowerCode;
  final String windPowerDesc;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'daynight': daynight,
        'max_temp': maxTemp,
        'min_temp': minTemp,
        'weather_code': weatherCode,
        'weather_name': weatherName,
        'wind_direction_code': windDirectionCode,
        'wind_direction_desc': windDirectionDesc,
        'wind_power_code': windPowerCode,
        'wind_power_desc': windPowerDesc,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
