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
      body: Center(
        child: _panGestureWidget(context),
      ),
    );

    /*return AppLayout(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //alignmentSelector,
            SizedBox(height: 8),
            RollButtonWithPreview(
              selected: selectedIndex,
              items: Constants.emotions.map((e) => e.name).toList(),
              onPressed: isAnimating.value ? null : handleRoll,
            ),
            SizedBox(height: 8),
            // Expanded(
            //   child: ,
            // ),
          ],
        ),
      ),
    );*/
  }

  Widget _wheel(BuildContext context) {
    final selected = useStreamController<int>();
    //final selectedIndex = useStream(selected.stream, initialData: 0).data ?? 0;
    //final isAnimating = useState(false);

    void handleRoll() {
      selected.add(
        roll(Constants.emotions.length),
      );
    }

    return FortuneWheel(
      circleSize: circleSize(context),
      rotationCount: 1,
      curve: FortuneCurve.spin,
      duration: const Duration(seconds: 1),
      alignment: Alignment.centerRight,
      selected: selected.stream,
      // onAnimationStart: () => isAnimating.value = true,
      // onAnimationEnd: () => isAnimating.value = false,
      onFling: handleRoll,
      hapticImpact: HapticImpact.heavy,
      indicators: [
        FortuneIndicator(
          alignment: Alignment.centerRight,
          child: TriangleIndicator(
            color: Colors.amber,
          ),
        )
      ],
      items: [
        for (var eachEmotion in Constants.emotions)
          FortuneItem(
            style: FortuneItemStyle(
              color: eachEmotion.color,
              borderWidth: 0,
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            onTap: () {
              final indexSelected = Constants.emotions.indexOf(eachEmotion);
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

  Widget _panGestureWidget(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (d) {
        _panHandler(d, context);
      },
      child: _wheel(context),
    );
  }

  void _panHandler(DragUpdateDetails d, BuildContext context) {
    final radius = circleSize(context) / 2;

    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Pan movements
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Absoulte change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    /// Directional change on wheel
    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    // Total computed change
    double rotationalChange = verticalRotation + horizontalRotation;

    bool movingClockwise = rotationalChange > 0;
    bool movingCounterClockwise = rotationalChange < 0;

    // Now do something interesting with these computations!
  }
}
