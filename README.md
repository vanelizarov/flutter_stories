# flutter_stories

Widget that brings stories mechanism to your apps

TODO: gif

## Advantages:
  - Simple to use and intuitive API
  - Lightweight (~200 lines of code)
  - Feels familiar if you've used Instagram or Snapchat stories before

## Usage

```dart
Story(
  onFlashForward: Navigator.of(context).pop,
  onFlashBack: Navigator.of(context).pop,
  momentCount: 4,
  momentDurationGetter: (idx) => Duration(seconds: 4),
  momentBuilder: (context, idx) {
    return Container(
      color: CupertinoColors.destructiveRed,
      child: Center(
        child: Text(
          'Moment ${idx + 1}',
          style: TextStyle(color: CupertinoColors.white),
        ),
      ),
    );
  },
)
```

Gives you this result:

TODO: gif

## Supported gestures

- Tap the right portion of the screen to switch to the next moment. You can specify `onFlashForward` callback to control app behavior in this case or when story finishes
  TODO: gif
- Tap the left portion of the screen to switch to the previous moment. Similar to right tap, but uses `onFlashBack`
  TODO: gif
- Long press (hold) the screen to hide the progress segments and pause story, release to show controls and unpause
  TODO: gif

## API

| property                  | type                                                          | required | default value                         | description                                                                                                             |
| ------------------------- | ------------------------------------------------------------- | -------- | ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `momentCount`             | int                                                           | true     |                                       | sets the number of moments in story                                                                                     |
| `momentDurationGetter`    | (int index) => Duration                                       | true     |                                       | function that must return Duration for each moment                                                                      |
| `momentBuilder`           | (BuildContext context, int index) => Widget                   | true     |                                       | builder that gets executed executed for each moment                                                                     |
| `onFlashForward`          | () => void                                                    | true     |                                       | gets executed when user taps the right portion of the screen on the last moment in story or when story finishes playing |
| `onFlashBack`             | () => void                                                    | true     |                                       | gets executed when user taps the left portion of the screen on the first moment in story                                |
| `startAt`                 | int                                                           | false    | 0                                     | sets the index of the first moment that will be displayed                                                               |
| `momentSwitcherFraction`  | double                                                        | false    | 0.33                                  | sets the ratio of left and right tappable portions of the screen: left for switching back, right for switching forward  |
| `progressSegmentBuilder`  | (BuildContext context, double progress, double gap) => Widget | false    | Story.instagramProgressSegmentBuilder | builder for each progress segment. defaults to Instagram-like minimalistic segment builder                              |
| `progressSegmentGap`      | double                                                        | false    | 2.0                                   | sets the gap between each progress segment                                                                              |
| `progressOpacityDuration` | Duration                                                      | false    | Duration(milliseconds: 300)           | sets the duration for the progress bar show/hide animation                                                              |