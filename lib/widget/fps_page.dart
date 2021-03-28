import 'package:flutter/material.dart';

import 'fps_chart.dart';

class FpsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FpsPageState();
  }
}

class FpsPageState extends State<FpsPage> {
  @override
  Widget build(BuildContext context) {
    List<FpsInfo> list = PerformanceCollectionUtil.instance.storage.getAll();

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              height: 44,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('近240帧',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'PingFang SC',
                          fontSize: 9)),
                  Text(
                      '最大耗时:${PerformanceCollectionUtil.instance.storage.max.toStringAsFixed(1)}',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'PingFang SC',
                          fontSize: 9)),
                  Text(
                      '平均耗时:${PerformanceCollectionUtil.instance.storage.getAvg().toStringAsFixed(1)}',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'PingFang SC',
                          fontSize: 9)),
                  Text(
                      '总耗时:${PerformanceCollectionUtil.instance.storage.totalNum.toStringAsFixed(1)}',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'PingFang SC',
                          fontSize: 14))

                ],
              )),
          Divider(
            height: 0.5,
            color: Color(0xffdddddd),
            indent: 16,
            endIndent: 16,
          ),
          FpsBarChart(data: list)
        ],
      ),
    );
  }
}
