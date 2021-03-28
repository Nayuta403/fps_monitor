import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fps_monitor/bean/fps_info.dart';
import 'package:fps_monitor/util/collection_util.dart';
import 'package:fps_monitor/widget/custom_widget_inspector.dart';

import 'fps_page.dart';

class PerformanceObserverWidget extends StatefulWidget {
  const PerformanceObserverWidget({Key key}) : super(key: key);

  @override
  _PerformanceObserverWidgetState createState() =>
      _PerformanceObserverWidgetState();
}

class _PerformanceObserverWidgetState extends State<PerformanceObserverWidget> {
  bool startRecording = false;
  bool fpsPageShowing = false;

  ValueNotifier controller;
  Function(List<FrameTiming>) monitor;
  OverlayEntry fpsInfoPage;
  OverlayEntry performancePage;

  @override
  void initState() {
    super.initState();
    controller = ValueNotifier("");
    monitor = (timings) {
      double duration = 0;
      timings.forEach((element) {
        FrameTiming frameTiming = element;
        duration = frameTiming.totalSpan.inMilliseconds.toDouble();
        FpsInfo fpsInfo = new FpsInfo();
        fpsInfo.totalSpan = max(16.7, duration);
        CommonStorage.instance.save(fpsInfo);
      });
    };
  }

  @override
  void dispose() {
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
            child: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, snapshot, _) {
                  return Container(
                    color: Colors.white,
                    child: !startRecording
                        ? Icon(Icons.play_arrow)
                        : fpsPageShowing ? Row() : Icon(Icons.pause),
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
        startRecording = true;
        controller.value = startRecording;
      });
    } else {
      if (!fpsPageShowing) {
        stop();
        if (fpsInfoPage == null) {
          fpsInfoPage = OverlayEntry(builder: (c) {
            return Scaffold(
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
                                CommonStorage.instance.clear();
                                controller.value = startRecording;
                                // setState(() {});
                              },
                            ),
                            alignment: Alignment.bottomLeft,
                          ),
                        ],
                      )),
                ],
              ),
              backgroundColor: Color(0x33999999),
            );
          });
        }
        fpsPageShowing = true;
        navGlobalKey.currentState.overlay.insert(fpsInfoPage);
      }
    }
  }
}
