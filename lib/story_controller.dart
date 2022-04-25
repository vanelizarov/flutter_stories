import 'package:flutter/widgets.dart';

import 'flutter_stories.dart';

class StoryController extends ChangeNotifier {
  StoryController({
    required this.momentDurationGetter,
    required this.momentCount,
    this.onFlashForward,
    this.onFlashBack,
    this.isPlayingAtStart = true,
    this.startAt = 0,
  })  : assert(momentCount > 0),
        assert(startAt >= 0),
        assert(startAt < momentCount),
        currentIdx = startAt;

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
  final VoidCallback? onFlashForward;

  ///
  /// Gets executed when user taps the left portion
  /// of the screen on the first moment in story
  ///
  final VoidCallback? onFlashBack;

  ///
  /// Sets the index of the first moment that will be displayed
  ///
  final int startAt;

  ///
  /// Current index of the moment
  ///
  int currentIdx;

  ///
  /// Sets initial playing state of the story
  ///
  final bool isPlayingAtStart;

  AnimationController? animationController;

  void initAnimationController(TickerProvider vsync) {
    animationController = AnimationController(
      vsync: vsync,
      duration: momentDurationGetter(currentIdx),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          next();
        }
      });
    if (isPlayingAtStart) play();
  }

  void play() => animationController?.forward();

  void pause() => animationController?.stop();

  void next() {
    animationController?.stop();
    if (currentIdx + 1 >= momentCount && onFlashForward != null) {
      onFlashForward!();
    } else if (currentIdx + 1 < momentCount) {
      animationController?.reset();
      currentIdx += 1;
      notifyListeners();
      animationController?.duration = momentDurationGetter(currentIdx);
      animationController?.forward();
    } else if (currentIdx == momentCount - 1) {
      currentIdx = momentCount;
      notifyListeners();
    }
  }

  void previous() {
    animationController?.stop();
    if (currentIdx - 1 < 0 && onFlashBack != null) {
      onFlashBack!();
    } else {
      animationController?.reset();
      if (currentIdx - 1 >= 0) {
        currentIdx -= 1;
        notifyListeners();
      }
      animationController?.duration = momentDurationGetter(currentIdx);
      animationController?.forward();
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
}
