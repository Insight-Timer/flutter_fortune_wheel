import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../common/common.dart';
import '../widgets/widgets.dart';

class FortuneWheelBigPage extends StatefulWidget {
  static const kRouteName = 'FortuneWheelBigPage';

  static void go(BuildContext context) {
    context.goNamed(kRouteName);
  }

  const FortuneWheelBigPage({Key? key}) : super(key: key);

  @override
  State<FortuneWheelBigPage> createState() => _FortuneWheelBigPageState();
}

class _FortuneWheelBigPageState extends State<FortuneWheelBigPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late ColorTween _colorTween;
  late Animation<Color?> colorTweenAnimation;
  List<Emotions> emotionsNew = [];

  Color beginColor = Colors.green;
  Color endColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _colorTween = ColorTween(begin: beginColor, end: endColor);
    colorTweenAnimation = _colorTween.animate(_animationController);
    //changeColors();
    emotionsNew = emotions;

    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     animation.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     animation.forward();
    //   }
    // });
    //animation.forward();
  }

  void redraw(Color beginColor, Color endColor) {
    setState(() {
      _colorTween = ColorTween(begin: beginColor, end: endColor);
      colorTweenAnimation = _colorTween.animate(_animationController);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    disposed = true;
    super.dispose();
  }

  bool disposed = false;

  List<Emotions> get emotions {
    var newEmotions = <Emotions>[];
    for (var element in Constants.feelings) {
      newEmotions.add(
        Emotions(
          name: element.name,
          color: endColor,
        ),
      );
    }
    return newEmotions;
  }

  Future<void> changeColors() async {
    while (!disposed) {
      if (disposed) return;
      await Future<void>.delayed(const Duration(milliseconds: 1300), () {
        _animationController.forward(from: 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Fortune Wheel Demo'),
      // ),
      body: Stack(
        children: [
          FortuneWheelBigPage1(
            _animationController,
            colorTweenAnimation,
            emotionsNew,
          ),
          Positioned(
            top: 450,
            left: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // print("=== on Close -> ");
                setState(() {
                  var generatedColor =
                      Random().nextInt(Colors.primaries.length);

                  final newGeneratedColor = Colors.primaries[generatedColor];
                  beginColor = endColor;
                  endColor = newGeneratedColor;
                  print(
                      "===== BEGIN COLOR -> $beginColor --- END COLOR -> $endColor");
                  emotionsNew = emotions;
                  emotionsNew.shuffle();
                });
                redraw(beginColor, endColor);
                _animationController.forward(from: 0);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Center(
                  child: Text(
                    "X",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FortuneWheelBigPage1 extends HookWidget {
  AnimationController animation;
  Animation<Color?> colorTweenAnimation;
  List<Emotions> emotions;

  FortuneWheelBigPage1(this.animation, this.colorTweenAnimation, this.emotions);

  //var onFocusIndex = 0;

  @override
  Widget build(BuildContext context) {
    return _wheel(context);
  }

  Widget _wheel(BuildContext context) {
    final selected = useStreamController<int>();
    //final selectedIndex = useStream(selected.stream, initialData: 0).data ?? 0;
    //final isAnimating = useState(false);

    void handleRoll() {
      selected.add(roll(emotions.length));
    }

    return AnimatedBuilder(
        animation: colorTweenAnimation,
        builder: (context, child) {
          return FortuneWheel(
            animatedBgColorBigWheel: colorTweenAnimation.value,
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
              //onFocusIndex = index;
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
                    final indexSelected = emotions.indexWhere(
                        (element) => element.name == eachEmotion.name);
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
        });
  }

  double circleSize(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
