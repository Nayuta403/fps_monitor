import 'dart:collection';

import 'package:fps_monitor/bean/fps_info.dart';

int kFpsInfoMaxSize = 100;

/// Fps 信息存储
class CommonStorage {
  static CommonStorage _instance;

  static CommonStorage get instance {
    if (_instance == null) {
      _instance = CommonStorage._();
    }
    return _instance;
  }

  CommonStorage._() {
    maxCount = kFpsInfoMaxSize;
  }

  int maxCount;
  Queue<FpsInfo> items = new Queue();
  double max = 0;
  double totalNum = 0;

  List<FpsInfo> getAll() {
    return items.toList();
  }

  void clear() {
    items.clear();
    max = 0;
    totalNum = 0;
  }

  bool save(FpsInfo info) {
    if (items.length >= maxCount) {
      totalNum -= items.removeFirst().totalSpan;
    }
    items.add(info);
    totalNum += info.totalSpan;
    max = info.totalSpan > max ? info.totalSpan : max;
    return true;
  }

  num getAvg() {
    return totalNum / items.length;
  }

  bool contains(FpsInfo info) {
    return items.contains(info);
  }
}
