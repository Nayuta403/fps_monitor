import 'package:flutter/material.dart';
import 'package:fps_monitor/bean/fps_info.dart';
import 'package:fps_monitor/util/collection_util.dart';

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
    List<FpsInfo> list = CommonStorage.instance!.getAll();
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
                  info('近${CommonStorage.instance!.items.length}帧'),
                  info('最大耗时:${CommonStorage.instance!.max!.toStringAsFixed(1)}'),
                  info(
                      '平均耗时:${CommonStorage.instance!.getAvg().toStringAsFixed(1)}'),
                  info(
                      '总耗时:${CommonStorage.instance!.totalNum.toStringAsFixed(1)}')
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

  Widget info(String text) {
    return Text("$text",
        style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.normal,
            fontFamily: 'PingFang SC',
            fontSize: 9));
  }
}
