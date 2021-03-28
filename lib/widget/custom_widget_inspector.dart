import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

const double _kInspectButtonMargin = 10.0;
const double _kErrorReminderButtonMargin = 80.0;

class CustomWidgetInspector extends StatefulWidget {
  /// 展示性能监控数据
  static bool debugShowPerformanceMonitor = true;

  /// Creates a widget that enables inspection for the child.
  ///
  /// The [child] argument must not be null.
  const CustomWidgetInspector({Key key, @required this.child, this.nav})
      : assert(child != null),
        super(key: key);

  /// The widget that is being inspected.
  final Widget child;
  final Widget nav;

  @override
  _CustomWidgetInspectorState createState() => _CustomWidgetInspectorState();
}

class _CustomWidgetInspectorState extends State<CustomWidgetInspector> {
  /// Distance from the edge of the bounding box for an element to consider
  /// as selecting the edge of the bounding box.
  static const double _edgeHitMargin = 2.0;

  final GlobalKey rootGlobalKey = GlobalKey();
  final InspectorSelection selection =
      WidgetInspectorService.instance.selection;

  @override
  Widget build(BuildContext context) {
    Widget result = widget.child;

    Widget performanceObserver = Container();

    if (CustomWidgetInspector.debugShowPerformanceMonitor) {
      performanceObserver = PerformanceObserverWidget();
    }

    if (CustomWidgetInspector.debugShowPerformanceMonitor) {
      result = Stack(
        alignment: AlignmentDirectional.topStart,
        children: <Widget>[
          IgnorePointer(
            ignoring: false,
            key: rootGlobalKey,
            child: result,
          ),
          Positioned(
            right: _kInspectButtonMargin,
            top: _kErrorReminderButtonMargin,
            child: performanceObserver,
          )
        ],
      );
    }
    return result;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
