## 导语：

对于任何一款应用而言，页面的流畅度一定是影响用户体验最重要的几个指标之一。作为开发者，优化页面流畅度也是自己技术实力的体现。但在决定进行优化之前，还有两个更重要的问题摆在我们面前：**1、如何发现卡顿的页面？**、**2、如何衡量我的优化效果？**

为了解决这两个问题，本期给大家带来一个很有意思的小工具：**fps_monitor**

***
## 1、What's this 这是个什么工具？

首先一句话告诉你：**这是一个能在 profile/debug 模式下，直观帮助我们评估页面流畅度的工具！！**
直白来说就是：这是一个可以在(刷新率60)设备上直接查看最近（默认 100）帧的表现情况的小工具，直接上图：




当我们点击右下角的 ⏯ 后，按钮变为⏸ 状态，工具开始为我们收集每一帧的总耗时(包含 CPU 和 GPU 耗时)。此时点击 ⏸  按钮会为我们展示收集到的耗时信息

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a36915b137e14d1e9d4e9bbbe7f5bd6c~tplv-k3u1fbpfcp-watermark.image)

柱状图顶部为我们展示收集到的数据里：**最大耗时**、**平均耗时**、以及**总耗时**（单位：毫秒）

在下方，我将页面流畅度划为了四个级别：**流畅（蓝色）**、**良好(黄色)**、**轻微卡顿(粉色)**、**卡顿(红色)**，将 FPS 折算成一帧所消耗的时间，不同级别采用不一样的颜色，统计不同级别出现的次数。

上面的例子中，我们可以看到，工具一共收集了 99 帧，最大耗时的一帧花了119ms，平均耗时：32.9 ms，总耗时：3259.5 ms。其中认为有 40 帧流畅，25 帧良好，38 帧轻微卡顿，6 帧卡顿。



***

## 2、Why you need this 为什么需要这个工具？

### 一、为什么我没选择 PerformanceOverLay 和 DoKit？
看到上面的功能可能有人有疑惑，你这功能咋和 PerformanceOverLay 这么类似？

首先，我在使用 PerformanceOverLay 的时候遇到了一点问题：


![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/151f8e7f24ae4f09a3583c7e173bbf6c~tplv-k3u1fbpfcp-watermark.image)

如图，PerformanceOverLay 上分别为我们展示了构建（UI）耗时和渲染（GPU）耗时。

我遇到的第一个问题是，因为我们在分析流畅度的时候，往往是看一帧的总耗时。这样拆分了之后，一帧的耗时变成了上下的和，对我而言很不直观。

其次，这里面提供`最大耗时`或者`平均耗时`并不能很好的帮助我们量化页面的流畅程度。因为这个统计过程，会直接将一帧的耗时进行平均，这就带来一个问题。我们知道对于60刷新率的设备，两帧的间隔时间最小应该是 16.7ms，而 PerformanceOverLay 的收集过程没有对数据过滤，会出现一帧耗时小于 16.7ms，这就导致平均数据可能偏低。（下图平均一帧耗时为：10.6ms）
![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3289936d52424f7797f43634837148ce~tplv-k3u1fbpfcp-watermark.image)

其实这样来看，DoKit是一个不错的选择

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/57838121f69d4694b7ee074bbb7d1e19~tplv-k3u1fbpfcp-watermark.image)

但DoKit同样没有对最小帧耗时做过滤，也会出现平均耗时偏低的情况。同时，没有更多的数据辅助评估页面的流畅程度。

上面我遇到的情况，不一定是问题，只是我在使用过程中觉得不太直观，不太方便。

因此开发了这个工具，该工具具有以下特点


![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fde2765e3e944dbf98e90a2ffea75fad~tplv-k3u1fbpfcp-watermark.image)

同时支持设置最大采集帧数

### 二、我是如何理解页面流畅度

我在上一期[ListView流畅度翻倍！！Flutter卡顿分析和通用优化方案](https://juejin.cn/post/6940134891606507534)有解释过

对于大部分人而言，当每秒的画面达到60，也就是俗称**60FPS**的时候，整个过程就是流畅的。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b309e9f3ffe8425abb5ba11f5ef1f669~tplv-k3u1fbpfcp-zoom-1.image)

一秒 60 帧，也就意味着平均两帧之间的间隔为 16.7ms。那么耗时大于 16.7ms 就会觉得卡顿么？

答案当然是 NO。腾讯在 [Martrix](https://github.com/Tencent/matrix/wiki/Matrix-Android-TraceCanary) 中也提到

>我们平时看到的大部分电影或视频 FPS 其实不高，一般只有 25FPS ~ 30FPS，而实际上我们也没有觉得卡顿。 在人眼结构上看，当一组动作在 1 秒内有 12 次变化（即 12FPS），我们会认为这组动作是连贯的

其实流畅度本身就是一个很主观的东西，就好比有人觉得打王者荣耀不开高帧率好像也还算流畅，有人觉得不开高帧率那不就是个GIF图么。

有没有客观一点的指标，我在网上查询了很久之后找到了一篇08年发表在ICIP上的论文[Modeling the impact of frame rate on perceptual quality of video
](https://www.researchgate.net/profile/Zhan-Ma-6/publication/224359119_Modeling_the_impact_of_frame_rate_on_perceptual_quality_of_video/links/00b7d514f3b347250e000000/Modeling-the-impact-of-frame-rate-on-perceptual-quality-of-video.pdf) 他们使用了6种内容进行测试，实验结果如下图所示

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3dbfc676b92e48ecbcddfb08d9da8a6e~tplv-k3u1fbpfcp-watermark.image)

通过该图我们可以看出，当帧率大于15帧的时候，人眼的主观感受差别不大，基本上都处于较高的水平。而帧率小于15帧以后，人眼的主观感受会急剧下降。换句话说，人眼会立刻感受到画面的不连贯性。


因此，在工具中我将低于16.7ms的数据统一成16.7ms,所以这个检测工具只在刷新率为60的设备有意义。并且将流畅度划分为了以下等级：

* 流畅：FPS大于55，即一帧耗时低于 18ms
* 良好：FPS在30-55之间，即一帧耗时在 18ms-33ms 之间
* 轻微卡顿：FPS在15-30之间，即一帧耗时在 33ms-67ms 之间
* 卡顿：FPS低于15，即一帧耗时大于 66.7ms

并统计出现的次数，你可以根据这几项数据，去制定一个理想的流畅度。例如：流畅的帧数占统计帧数的90%，或者卡顿的帧数不超过5次。

***

##  3、How to Use it 如何使用？
### 一、项目依赖
dependencies:
  fps_monitor: 1.12.13-1
### 二、接入工程
有两处接入点

* 1、指定overLayState ，因为需要弹出一个Fps的统计页面，所以当前指定overLayState。
**（PS：大家一般使用Navigator.of(context)去跳转一个页面，通过GlobalKey可以实现无context的跳转）**

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/800dd3bb2e4c402db6d66758ad6154e2~tplv-k3u1fbpfcp-watermark.image)
```dart
///声明NavigatorState的GlobalKey
GlobalKey<NavigatorState> globalKey = GlobalKey();
///获取overLayState
  SchedulerBinding.instance.addPostFrameCallback((t) =>
    overlayState =globalKey.currentState.overlay
    );
///指定MaterialApp的navigatorKey  
navigatorKey: globalKey,

```

* 2、在build属性中包裹组件

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5770b6ef7ede429c95176e1eceb858b6~tplv-k3u1fbpfcp-watermark.image)

### 三、如何使用
在完成了上述步骤之后，你只需要启动app，**该工具只会在profile/debug模式下集成**，在你的右下角会出现一个 ⏯ 按钮，点击开始记录，再次点击显示数据。

![Screenrecording_20210405_171133.gif](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4b13856e7c274513ac488f2959877786~tplv-k3u1fbpfcp-watermark.image)

如果想要结束采集，点击面板中的停止监听即可。

如果你想采集更多的帧，可以通过`kFpsInfoMaxSize`设置

![Screenrecording_20210405_171154.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/373a7a22b17d4b308eacaaaa933a3358~tplv-k3u1fbpfcp-watermark.image)

### 四、Warning：

目前这个项目是基于 Flutter 1.12.13 分支进行开发，如果你在接入项目中遇到了了兼容性问题，欢迎评论区留言或者公众号私信我。当然更加欢迎各位直接PR~


