import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../common/common.dart';
import '../widgets/widgets.dart';

class FortuneWheelPage extends HookWidget {
  static const kRouteName = 'FortuneWheelPage';

  static void go(BuildContext context) {
    context.goNamed(kRouteName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fortune Wheel Demo'),
      ),
      body: Container(
        transform: Matrix4.translationValues(
          0, //-(circleSize(context) / 2),
          200,
          0,
        ),
        child: _wheel(context),
      ),
    );
  }

  Widget _wheel(BuildContext context) {
    final selected = useStreamController<int>();
    //final selectedIndex = useStream(selected.stream, initialData: 0).data ?? 0;
    //final isAnimating = useState(false);

    void handleRoll() {
      selected.add(roll(Constants.emotions.length));
    }

    return FortuneWheel(
      onSelectedValueChanged: (selectionUpdatedIndex) {
        print(
            "===== new Selected Index -> " + selectionUpdatedIndex.toString());
      },
      circleSize: circleSize(context),
      rotationCount: 1,
      curve: FortuneCurve.spin,
      duration: Duration(seconds: 2),
      alignment: Alignment.centerRight,
      selected: selected.stream,
      // onAnimationStart: () => isAnimating.value = true,
      // onAnimationEnd: () => isAnimating.value = false,
      onFling: handleRoll,
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
        for (var eachEmotion in Constants.emotions)
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
              final indexSelected = Constants.emotions
                  .indexWhere((element) => element.name == eachEmotion.name);
              print(
                  "==== on option tap -> ${eachEmotion.name} ${indexSelected}");
              selected.add(indexSelected);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(eachEmotion.name),
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

class PeacefulSlicePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(215, 0)
      ..arcTo(
          Rect.fromCircle(
            center: Offset(0, 0),
            radius: 215,
          ),
          0,
          0.4487989505128276,
          false)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..strokeWidth = 2
        ..color = Colors.white
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
