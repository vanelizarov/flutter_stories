import 'package:flutter/cupertino.dart';
import 'package:flutter_stories/flutter_stories.dart';
import 'package:flutter_stories/story_controller.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            onTap: () async {
              final _controller = StoryController(
                onFlashForward: Navigator.of(context).pop,
                onFlashBack: Navigator.of(context).pop,
                momentCount: 3,
                momentDurationGetter: (idx) => _momentDuration,
                isPlayingAtStart: false,
              );
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoPageScaffold(
                    child: Story(
                      controller: _controller,
                      momentBuilder: (context, idx) => images[idx],
                    ),
                  );
                },
              );
              await Future.delayed(Duration(seconds: 1));
              print('After a second');
              _controller.play();
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
