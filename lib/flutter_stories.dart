library flutter_stories;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

///
/// Callback function that accepts the index of moment and
/// returns its' Duration
///
typedef Duration MomentDurationGetter(int index);

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
    Key key,
    this.momentBuilder,
    this.momentDurationGetter,
    this.momentCount,
    this.onFlashForward,
    this.onFlashBack,
    this.progressSegmentBuilder = Story.instagramProgressSegmentBuilder,
    this.progressSegmentGap = 2.0,
    this.progressOpacityDuration = const Duration(milliseconds: 300),
    this.momentSwitcherFraction = 0.33,
    this.startAt = 0,
  })  : assert(momentCount != null),
        assert(momentCount > 0),
        assert(momentDurationGetter != null),
        assert(momentBuilder != null),
        assert(momentSwitcherFraction != null),
        assert(momentSwitcherFraction >= 0),
        assert(momentSwitcherFraction < double.infinity),
        assert(progressSegmentGap != null),
        assert(progressSegmentGap >= 0),
        assert(progressOpacityDuration != null),
        assert(momentSwitcherFraction < double.infinity),
        assert(startAt != null),
        assert(startAt >= 0),
        assert(startAt < momentCount),
        assert(onFlashForward != null),
        assert(onFlashBack != null),
        super(key: key);

  ///
  /// Builder that gets executed executed for each moment
  ///
  final IndexedWidgetBuilder momentBuilder;

  ///
  /// Function that must return Duration for each moment
  ///
  final MomentDurationGetter momentDurationGetter;

  ///
  /// Sets the number of moments in story
  ///
  final int momentCount;

  ///
  /// Gets executed when user taps the right portion of the screen
  /// on the last moment in story or when story finishes playing
  ///
  final VoidCallback onFlashForward;

  ///
  /// Gets executed when user taps the left portion
  /// of the screen on the first moment in story
  ///
  final VoidCallback onFlashBack;

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
  /// Sets the index of the first moment that will be displayed
  ///
  final int startAt;

  static Widget instagramProgressSegmentBuilder(
      BuildContext context, int index, double progress, double gap) {
    return Container(
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
  }

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> with SingleTickerProviderStateMixin {
  AnimationController controller;
  int currentIdx;
  bool isInFullscreenMode = false;

  switchToNextOrFinish() {
    controller.stop();
    if (currentIdx + 1 >= widget.momentCount) {
      widget.onFlashForward();
    } else {
      controller.reset();
      setState(() => currentIdx += 1);
      controller.duration = widget.momentDurationGetter(currentIdx);
      controller.forward();
    }
  }

  switchToPrevOrFinish() {
    controller.stop();
    if (currentIdx - 1 < 0) {
      widget.onFlashBack();
    } else {
      controller.reset();
      setState(() => currentIdx -= 1);
      controller.duration = widget.momentDurationGetter(currentIdx);
      controller.forward();
    }
  }

  onTapDown(TapDownDetails details) {
    controller.stop();
  }

  onTapUp(TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    if (details.localPosition.dx < width * widget.momentSwitcherFraction) {
      switchToPrevOrFinish();
    } else {
      switchToNextOrFinish();
    }
  }

  onLongPress() {
    controller.stop();
    setState(() => isInFullscreenMode = true);
  }

  onLongPressEnd() {
    setState(() => isInFullscreenMode = false);
    controller.forward();
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);

    currentIdx = widget.startAt;

    controller = AnimationController(
      vsync: this,
      duration: widget.momentDurationGetter(currentIdx),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          switchToNextOrFinish();
        }
      });

    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topOffset = MediaQuery.of(context).padding.top;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        widget.momentBuilder(context, currentIdx),
        Positioned(
          top: topOffset,
          left: 8.0 - widget.progressSegmentGap / 2,
          right: 8.0 - widget.progressSegmentGap / 2,
          child: AnimatedOpacity(
            opacity: isInFullscreenMode ? 0.0 : 1.0,
            duration: widget.progressOpacityDuration,
            child: Row(
              children: <Widget>[
                ...List.generate(
                  widget.momentCount,
                  (idx) {
                    return Expanded(
                      child: idx == currentIdx
                          ? AnimatedBuilder(
                              animation: controller,
                              builder: (context, _) {
                                return widget.progressSegmentBuilder(
                                  context,
                                  idx,
                                  controller.value,
                                  widget.progressSegmentGap,
                                );
                              },
                            )
                          : widget.progressSegmentBuilder(
                              context,
                              idx,
                              idx < currentIdx ? 1.0 : 0.0,
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
            onTapDown: onTapDown,
            onTapUp: onTapUp,
            onLongPress: onLongPress,
            onLongPressUp: onLongPressEnd,
          ),
        ),
      ],
    );
  }
}
