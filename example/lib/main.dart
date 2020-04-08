import 'package:flutter/cupertino.dart';
import 'package:flutter_stories/flutter_stories.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  final _momentCount = 5;
  final _momentDuration = const Duration(seconds: 5);

  @override
  Widget build(BuildContext context) {
    final images = List.generate(
      _momentCount,
      (idx) => Image.asset('assets/${idx + 1}.jpg'),
    );

    return CupertinoPageScaffold(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.0),
            border: Border.all(
              color: CupertinoColors.activeOrange,
              width: 2.0,
              style: BorderStyle.solid,
            ),
          ),
          width: 64.0,
          height: 64.0,
          padding: const EdgeInsets.all(2.0),
          child: GestureDetector(
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoPageScaffold(
                    child: Story(
                      onFlashForward: Navigator.of(context).pop,
                      onFlashBack: Navigator.of(context).pop,
                      momentCount: 5,
                      momentDurationGetter: (idx) => _momentDuration,
                      momentBuilder: (context, idx) => images[idx],
                    ),
                  );
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28.0),
                color: CupertinoColors.activeBlue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
