# flutter_stories

![example](https://raw.githubusercontent.com/vanelizarov/flutter_stories/master/logo.png)

Widget that brings stories mechanism to your apps

## Advantages:
  - Simple to use and intuitive API
  - Lightweight (~200 lines of code)
  - Feels familiar if you've used Instagram or Snapchat stories before
  - Can be used with Cupertino and Material packages independently

## Usage

Add `flutter_stories` to your `pubspec.yaml`

## Example

Full version can be found in [example](https://github.com/vanelizarov/flutter_stories/tree/master/example) dir

![showcase](https://raw.githubusercontent.com/vanelizarov/flutter_stories/master/showcase.gif)


## Supported gestures

- Tap the right portion of the screen to switch to the next moment. You can specify `onFlashForward` callback to control app behavior in this case or when story finishes
- Tap the left portion of the screen to switch to the previous moment. Similar to right tap, but uses `onFlashBack`
- Long press (hold) the screen to hide the progress segments and pause story, release to show controls and unpause

## API

| property                  | type                                                            | required | description                                                                                                                                 |
| ------------------------- | --------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `momentCount`             | `int`                                                           | true     | Sets the number of moments in story                                                                                                         |
| `momentDurationGetter`    | `(int index) => Duration`                                       | true     | Function that must return Duration for each moment                                                                                          |
| `momentBuilder`           | `(BuildContext context, int index) => Widget`                   | true     | Builder that gets executed for each moment                                                                                                  |
| `onFlashForward`          | `() => void`                                                    | false    | Gets executed when user taps the right portion of the screen on the last moment in story or when story finishes playing                     |
| `onFlashBack`             | `() => void`                                                    | false    | Gets executed when user taps the left portion of the screen on the first moment in story                                                    |
| `startAt`                 | `int`                                                           | false    | Defaults to `0`. Sets the index of the first moment that will be displayed                                                                  |
| `momentSwitcherFraction`  | `double`                                                        | false    | Defaults to `0.33`. `sets the ratio of left and right tappable portions of the screen: left for switching back, right for switching forward |
| `progressSegmentBuilder`  | `(BuildContext context, double progress, double gap) => Widget` | false    | Defaults to `Story.instagramProgressSegmentBuilder` - Instagram-like minimalistic segment builder. Builder for each progress segment        |
| `progressSegmentGap`      | `double`                                                        | false    | Defaults to `2.0`. Sets the gap between each progress segment                                                                               |
| `progressOpacityDuration` | `Duration`                                                      | false    | Defaults to `Duration(milliseconds: 300)`. Sets the duration for the progress bar show/hide animation                                       |
| `topOffset`               | `double`                                                        | false    | Defaults to `MediaQuery.of(context).padding.top`. Sets the top offset of progress container                                                 |
| `fullscreen`              | `bool`                                                          | false    | Defaults to `true`. If true hides the status bar via SystemChrome service                                                                   |
