import 'dart:async';

import 'package:example/performance/bean/fps_info.dart';
import 'package:example/performance/bean/performance_bean.dart';

const Map<String, String> defaultPerformanceDataMapping = const {
  "name": "页面名称",
  "package_name": "包名",
  "init_to_first_appear": "首次渲染",
  "init_to_re_render": "二次渲染",
  "fps": "平均fps",
  "catons": "卡顿次数"
};

class PerformanceCollectionUtil {
  static PerformanceCollectionUtil _instance;

  static PerformanceCollectionUtil get instance {
    if (_instance != null) {
      return _instance;
    }
    _instance = PerformanceCollectionUtil();
    return _instance;
  }

  CommonStorage storage = CommonStorage(maxCount: 240);

  //接受来自性能监控库的数据
  StreamController<Map<String, dynamic>> controller;

  //提供给业务方预处理数据的接口
  Map<String, dynamic> Function(Map<String, dynamic> source) customHandleData;

  //性能数据存储Model
  PerformanceBean performanceBean = PerformanceBean();

  //需要观察的性能数据
  Map<String, String> performanceDataMapping = defaultPerformanceDataMapping;

  PerformanceCollectionUtil() {
    controller = StreamController();
    controller.stream.listen((data) {
      if (customHandleData != null) data = customHandleData(data);
      performanceBean.addToFirst(data);
    });
  }

  Map<String, String> toNativeJson() {
    Map<String, String> result = {};
    result['performanceDataMapping'] = performanceDataMapping.toString();
    result['performanceData'] = performanceBean.performanceData.toString();
    return result;
  }

  void clean() {
    performanceBean.clean();
  }

  void onDispose() {
    performanceBean = null;
    controller.close();
    performanceDataMapping?.clear();
  }
}
