import 'dart:collection';

class FpsInfo {
  int fps;
  String pageName;

  int getValue() {
    return fps;
  }
}

class CommonStorage {
  final int maxCount;
  Queue<FpsInfo> items = new Queue();
  int max = 0;
  int totalNum = 0;

  CommonStorage({this.maxCount = 100});

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
      totalNum -= items.removeFirst().fps;
    }
    items.add(info);
    totalNum += info.fps;
    max = info.fps > max ? info.fps : max;
    return true;
  }

  num getAvg() {
    return totalNum / items.length;
  }

  bool contains(FpsInfo info) {
    return items.contains(info);
  }
}
