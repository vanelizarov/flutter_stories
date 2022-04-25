library flutter_stories;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stories/story_controller.dart';

///
/// Callback function that accepts the index of moment and
/// returns its' Duration
///
typedef Duration MomentDurationGetter(int? index);

///
/// Builder function that accepts current build context, moment index,
/// moment progress and gap between each segment and returns widget for segment
///
typedef Widget ProgressSegmentBuilder(
    BuildContext context, int index, double progress, double gap);

///
/// Widget that allows you to use stories mechanism in your apps
///
/// **Usage:**
///
/// ```dart
/// Story(
///   onFlashForward: Navigator.of(context).pop,
///   onFlashBack: Navigator.of(context).pop,
///   momentCount: 4,
///   momentDurationGetter: (idx) => Duration(seconds: 4),
///   momentBuilder: (context, idx) {
///     return Container(
///       color: CupertinoColors.destructiveRed,
///       child: Center(
///         child: Text(
///           'Moment ${idx + 1}',
///           style: TextStyle(color: CupertinoColors.white),
///         ),
///       ),
///     );
///   },
/// )
/// ```
///
class Story extends StatefulWidget {
  const Story({
    Key? key,
    required this.momentBuilder,
    required this.controller,
    this.progressSegmentBuilder = Story.instagramProgressSegmentBuilder,
    this.progressSegmentGap = 2.0,
    this.progressOpacityDuration = const Duration(milliseconds: 300),
    this.momentSwitcherFraction = 0.33,
    this.topOffset,
    this.fullscreen = true,
  })  : assert(momentSwitcherFraction >= 0),
        assert(momentSwitcherFraction < double.infinity),
        assert(progressSegmentGap >= 0),
        assert(momentSwitcherFraction < double.infinity),
        super(key: key);

  final StoryController controller;

  ///
  /// Builder that gets executed executed for each moment
  ///
  final IndexedWidgetBuilder momentBuilder;

  ///
  /// Sets the ratio of left and right tappable portions
  /// of the screen: left for switching back, right for switching forward
  ///
  final double momentSwitcherFraction;

  ///
  /// Builder for each progress segment
  /// Defaults to Instagram-like minimalistic segment builder
  ///
  final ProgressSegmentBuilder progressSegmentBuilder;

  ///
  /// Sets the gap between each progress segment
  ///
  final double progressSegmentGap;

  ///
  /// Sets the duration for the progress bar show/hide animation
  ///
  final Duration progressOpacityDuration;

  ///
  /// Controls progress segments's container oofset from top of the screen
  ///
  final double? topOffset;

  ///
  /// Controls fullscreen behavior
  ///
  final bool fullscreen;

  static Widget instagramProgressSegmentBuilder(
          BuildContext context, int index, double progress, double gap) =>
      Container(
        height: 2.0,
        margin: EdgeInsets.symmetric(horizontal: gap / 2),
        decoration: BoxDecoration(
          color: Color(0x80ffffff),
          borderRadius: BorderRadius.circular(1.0),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            color: Color(0xffffffff),
          ),
        ),
      );

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> with SingleTickerProviderStateMixin {
  bool _isInFullscreenMode = false;

  void _onTapDown(TapDownDetails details) {
    print('Tap down');
    widget.controller.pause();
  }

  void _onTapUp(TapUpDetails details) {
    print('Tap up');
    widget.controller.pause();
    final width = MediaQuery.of(context).size.width;
    if (details.localPosition.dx < width * widget.momentSwitcherFraction) {
      widget.controller.previous();
    } else {
      widget.controller.next();
    }
  }

  void _onLongPress() {
    print('Long press');
    widget.controller.pause();
    setState(() => _isInFullscreenMode = true);
  }

  void _onLongPressEnd() {
    print('Long press end');
    setState(() => _isInFullscreenMode = false);
    widget.controller.play();
  }

  Future<void> _hideStatusBar() =>
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  Future<void> _showStatusBar() =>
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);

  @override
  void initState() {
    if (widget.fullscreen) {
      _hideStatusBar();
    }

    widget.controller.initAnimationController(this);
    widget.controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void didUpdateWidget(Story oldWidget) {
    if (widget.fullscreen != oldWidget.fullscreen) {
      if (widget.fullscreen) {
        _hideStatusBar();
      } else {
        _showStatusBar();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.fullscreen) {
      _showStatusBar();
    }
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        widget.momentBuilder(
          context,
          widget.controller.currentIdx < widget.controller.momentCount
              ? widget.controller.currentIdx
              : widget.controller.momentCount - 1,
        ),
        Positioned(
          top: widget.topOffset ?? MediaQuery.of(context).padding.top,
          left: 8.0 - widget.progressSegmentGap / 2,
          right: 8.0 - widget.progressSegmentGap / 2,
          child: AnimatedOpacity(
            opacity: _isInFullscreenMode ? 0.0 : 1.0,
            duration: widget.progressOpacityDuration,
            child: Row(
              children: <Widget>[
                ...List.generate(
                  widget.controller.momentCount,
                  (idx) {
                    return Expanded(
                      child: idx == widget.controller.currentIdx
                          ? AnimatedBuilder(
                              animation: widget.controller.animationController!,
                              builder: (context, _) {
                                return widget.progressSegmentBuilder(
                                  context,
                                  idx,
                                  widget.controller.animationController!.value,
                                  widget.progressSegmentGap,
                                );
                              },
                            )
                          : widget.progressSegmentBuilder(
                              context,
                              idx,
                              idx < widget.controller.currentIdx ? 1.0 : 0.0,
                              widget.progressSegmentGap,
                            ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onLongPress: _onLongPress,
            onLongPressUp: _onLongPressEnd,
          ),
        ),
      ],
    );
  }
}
