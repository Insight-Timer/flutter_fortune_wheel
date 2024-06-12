import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../common/common.dart';
import '../widgets/widgets.dart';

class FortuneWheelBigPage extends HookWidget {
  static const kRouteName = 'FortuneWheelBigPage';

  var onFocusIndex = 0;

  static void go(BuildContext context) {
    context.goNamed(kRouteName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Fortune Wheel Demo'),
      // ),
      body: Stack(
        children: [
          _wheel(context)
          // Container(
          //   transform: Matrix4.translationValues(
          //     -(circleSize(context) / 2),
          //     250,
          //     0,
          //   ),
          //   child: _wheel(context),
          // ),
        ],
      ),
    );
  }

  List<Emotions> get emotions {
    var newEmotions = <Emotions>[];
    for (var element in Constants.feelings) {
      newEmotions.add(
        Emotions(
          name: element.name,
          color: Color(0xFF709A4F),
        ),
      );
    }
    return newEmotions;
  }

  Widget _wheel(BuildContext context) {
    final selected = useStreamController<int>();
    //final selectedIndex = useStream(selected.stream, initialData: 0).data ?? 0;
    //final isAnimating = useState(false);

    void handleRoll() {
      selected.add(roll(emotions.length));
    }

    return FortuneWheel(
      isBig: true,
      circleSize: circleSize(context),
      rotationCount: 1,
      curve: FortuneCurve.spin,
      duration: Duration(seconds: 2),
      alignment: Alignment.centerRight,
      selected: selected.stream,
      // onAnimationStart: () => isAnimating.value = true,
      // onAnimationEnd: () => isAnimating.value = false,
      onFling: handleRoll,
      onFocusItemChanged: (index) {
        //print("===== $index");
        onFocusIndex = index;
      },
      hapticImpact: HapticImpact.heavy,
      indicators: [
        // FortuneIndicator(
        //   alignment: Alignment.centerRight,
        //   child: TriangleIndicator(
        //     width: 16,
        //     height: 16,
        //     elevation: 5,
        //     color: Colors.amber,
        //   ),
        // )
      ],
      items: [
        for (var eachEmotion in emotions)
          FortuneItem(
            style: FortuneItemStyle(
              color: eachEmotion.color,
              borderWidth: 1,
              borderColor: Colors.white,
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            onTap: () {
              final indexSelected = emotions
                  .indexWhere((element) => element.name == eachEmotion.name);
              print(
                  "==== on option tap -> ${eachEmotion.name} ${indexSelected}");
              selected.add(indexSelected);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  width: 100,
                  child: Text(
                    eachEmotion.name,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  double circleSize(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
