# fps_monitor

# 这个库能做什么？

fps_monitor 帮助你在开发阶段了解你的 Flutter 应用流畅度，由 DoKit 修改而来。
其中每条柱代表一帧的渲染耗时，参考 ICIP 论文[Modeling the impact of frame rate on perceptual quality of video]，针对**刷新率为60**的设备，将页面流畅度划分为四个等级。

* 流畅：FPS > 55  ->图中蓝色标记 
* 良好：55 > FPS >30 ->图中黄色标记
* 卡顿：30 > FPS > 15 ->图中橙色标记
* 严重卡顿：15 > FPS ->图中红色标记




A flutter package can help you get the Fps information for your app . 
According to the paper [Modeling the impact of frame rate on perceptual quality of video],I've divided FPS into four levels.

* smooth : FPS >= 60
*  


## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
