# flutter_stories

![example](https://raw.githubusercontent.com/vanelizarov/flutter_stories/master/logo.png)

Widget that brings stories mechanism to your apps

## Advantages:
  - Simple to use and intuitive API
  - Lightweight (~200 lines of code)
  - Feels familiar if you've used Instagram or Snapchat stories before

## Usage

Add `flutter_stories: ^0.1.0` to your `pubspec.yaml`

## Example

Full version can be found in [example](https://github.com/vanelizarov/flutter_stories/tree/master/example) dir

![showcase](https://raw.githubusercontent.com/vanelizarov/flutter_stories/master/showcase.gif)


## Supported gestures

- Tap the right portion of the screen to switch to the next moment. You can specify `onFlashForward` callback to control app behavior in this case or when story finishes
- Tap the left portion of the screen to switch to the previous moment. Similar to right tap, but uses `onFlashBack`
- Long press (hold) the screen to hide the progress segments and pause story, release to show controls and unpause

## API

| property                  | type                                                            | required | description                                                                                                                                     |
| ------------------------- | --------------------------------------------------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `momentCount`             | `int`                                                           | true     | sets the number of moments in story                                                                                                             |
| `momentDurationGetter`    | `(int index) => Duration`                                       | true     | function that must return Duration for each moment                                                                                              |
| `momentBuilder`           | `(BuildContext context, int index) => Widget`                   | true     | builder that gets executed executed for each moment                                                                                             |
| `onFlashForward`          | `() => void`                                                    | true     | gets executed when user taps the right portion of the screen on the last moment in story or when story finishes playing                         |
| `onFlashBack`             | `() => void`                                                    | true     | gets executed when user taps the left portion of the screen on the first moment in story                                                        |
| `startAt`                 | `int`                                                           | false    | sets the index of the first moment that will be displayed. defaults to `0`                                                                      |
| `momentSwitcherFraction`  | `double`                                                        | false    | defaults to `0.33`. sets the ratio of left and right tappable portions of the screen: left for switching back, right for switching forward      |
| `progressSegmentBuilder`  | `(BuildContext context, double progress, double gap) => Widget` | false    | defaults to `Story.instagramProgressSegmentBuilder`. builder for each progress segment. defaults to Instagram-like minimalistic segment builder |
| `progressSegmentGap`      | `double`                                                        | false    | defaults to `2.0`. sets the gap between each progress segment                                                                                   |
| `progressOpacityDuration` | `Duration`                                                      | false    | defaults to `Duration(milliseconds: 300)`. sets the duration for the progress bar show/hide animation                                           |
