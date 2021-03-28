import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'fps_page.dart';
import 'performance_page.dart';

class PerformanceObserverWidget extends StatefulWidget {
  final Widget nav;

  const PerformanceObserverWidget({Key key, this.nav}) : super(key: key);

  @override
  _PerformanceObserverWidgetState createState() =>
      _PerformanceObserverWidgetState();
}

class _PerformanceObserverWidgetState extends State<PerformanceObserverWidget> {
  bool startRecording = false;
  StreamController controller;
  Function(List<FrameTiming>) monitor;
  int catton = 40;
  OverlayEntry fpsInfoPage;
  OverlayEntry performancePage;
  bool fpsPageShowing = false;

  bool checkValid(int fps) {
    return fps >= 0 && fps < 500;
  }

  @override
  void initState() {
    super.initState();
    controller = StreamController();
    monitor = (timings) {
      int fps = 0;
      timings.forEach((element) {
        FrameTiming frameTiming = element;
        fps = frameTiming.totalSpan.inMilliseconds;
        if (checkValid(fps)) {
          FpsInfo fpsInfo = new FpsInfo();
          fpsInfo.fps = max(16, fps);
          // controller.add((1000 / max(16.7, fps)).round());
          PerformanceCollectionUtil.instance.storage.save(fpsInfo);
        }
      });
    };
  }

  @override
  void dispose() {
    controller.close();
    stop();
    super.dispose();
  }

  void start() {
    WidgetsBinding.instance.addTimingsCallback(monitor);
  }

  void stop() {
    WidgetsBinding.instance.removeTimingsCallback(monitor);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: RepaintBoundary(
            child: StreamBuilder(
                stream: controller.stream,
                builder: (context, snapshot) {
                  return startRecording
                      ? Text(
                          "查看数据",
                          style: TextStyle(fontSize: 9),
                        )
                      : Text(
                          '开始统计',
                          style:
                              const TextStyle(fontSize: 9, color: Colors.black),
                        );
                }),
          ),
          onTap: () {
            fpsMonitor();
          },
        )
      ],
    );
  }

  void fpsMonitor() {
    if (!startRecording) {
      setState(() {
        start();
        controller.add("");
        startRecording = true;
      });
    } else {
      if (!fpsPageShowing) {
        stop();
        if (fpsInfoPage == null) {
          fpsInfoPage = OverlayEntry(builder: (c) {
            return GestureDetector(
              onTap: () {
                fpsInfoPage.remove();
                start();
              },
              child: Scaffold(
                body: Column(
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        fpsInfoPage.remove();
                        fpsPageShowing = false;
                        start();
                      },
                      child: Container(
                        color: Color(0x33999999),
                      ),
                    )),
                    Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            FpsPage(),
                            Divider(),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 20, bottom: 20),
                              child: GestureDetector(
                                child: Text(
                                  '停止监听',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onTap: () {
                                  startRecording = false;
                                  fpsInfoPage.remove();
                                  fpsPageShowing = false;
                                  PerformanceCollectionUtil.instance.storage
                                      .clear();
                                  setState(() {});
                                },
                              ),
                              alignment: Alignment.bottomLeft,
                            ),
                          ],
                        )),
                  ],
                ),
                backgroundColor: Color(0x33999999),
              ),
            );
          });
        }

        fpsPageShowing = true;
        globalKey.currentState.overlay.insert(fpsInfoPage);
      } else {
        // start();
        // if () fpsInfoPage.remove();
        // fpsPageShowing = false;
      }
    }
  }
}
