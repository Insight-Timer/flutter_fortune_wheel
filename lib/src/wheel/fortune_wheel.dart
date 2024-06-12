part of 'wheel.dart';

enum HapticImpact { none, light, medium, heavy }

Offset _calculateWheelOffset(
    BoxConstraints constraints, TextDirection textDirection) {
  final smallerSide = getSmallerSide(constraints);
  var offsetX = constraints.maxWidth / 2;
  if (textDirection == TextDirection.rtl) {
    offsetX = offsetX * -1 + smallerSide / 2;
  }
  return Offset(offsetX, constraints.maxHeight / 2);
}

double _calculateSliceAngle(int index, int itemCount) {
  final anglePerChild = 2 * _math.pi / itemCount;
  final childAngle = anglePerChild * index;
  // first slice starts at 90 degrees, if 0 degrees is at the top.
  // The angle offset puts the center of the first slice at the top.
  final angleOffset = -(_math.pi / 2 + anglePerChild / 2);
  return childAngle + angleOffset;
}

double _calculateAlignmentOffset(Alignment alignment) {
  if (alignment == Alignment.topRight) {
    return _math.pi * 0.25;
  }

  if (alignment == Alignment.centerRight) {
    return _math.pi * 0.5;
  }

  if (alignment == Alignment.bottomRight) {
    return _math.pi * 0.75;
  }

  if (alignment == Alignment.bottomCenter) {
    return _math.pi;
  }

  if (alignment == Alignment.bottomLeft) {
    return _math.pi * 1.25;
  }

  if (alignment == Alignment.centerLeft) {
    return _math.pi * 1.5;
  }

  if (alignment == Alignment.topLeft) {
    return _math.pi * 1.75;
  }

  return 0;
}

class _WheelData {
  final BoxConstraints constraints;
  final int itemCount;
  final TextDirection textDirection;
  final Offset? customOffset;

  late final double smallerSide = getSmallerSide(constraints);
  late final double largerSide = getLargerSide(constraints);
  late final double sideDifference = largerSide - smallerSide;
  late final calculatedOffset =
      _calculateWheelOffset(constraints, textDirection);
  late final Offset offset = customOffset ?? calculatedOffset;
  //isBig ? bigWheelOffset ?? calculatedOffset : calculatedOffset;
  late final Offset dOffset = Offset(
    (constraints.maxHeight - smallerSide) / 2,
    (constraints.maxWidth - smallerSide) / 2,
  );
  late final double diameter = smallerSide;
  late final double radius = diameter / 2;
  late final double itemAngle = 2 * _math.pi / itemCount;

  _WheelData({
    this.customOffset,
    required this.constraints,
    required this.itemCount,
    required this.textDirection,
  });
}

/// A fortune wheel visualizes a (random) selection process as a spinning wheel
/// divided into uniformly sized slices, which correspond to the number of
/// [items].
///
/// ![](https://raw.githubusercontent.com/kevlatus/flutter_fortune_wheel/main/images/img-wheel-256.png?sanitize=true)
///
/// See also:
///  * [FortuneBar], which provides an alternative visualization
///  * [FortuneWidget()], which automatically chooses a fitting widget
///  * [Fortune.randomItem], which helps selecting random items from a list
///  * [Fortune.randomDuration], which helps choosing a random duration
class FortuneWheel extends HookWidget implements FortuneWidget {
  /// The default value for [indicators] on a [FortuneWheel].
  /// Currently uses a single [TriangleIndicator] on [Alignment.topCenter].
  static const List<FortuneIndicator> kDefaultIndicators = <FortuneIndicator>[
    FortuneIndicator(
      alignment: Alignment.topCenter,
      child: TriangleIndicator(),
    ),
  ];

  static const StyleStrategy kDefaultStyleStrategy = AlternatingStyleStrategy();

  final bool isBig;

  /// {@macro flutter_fortune_wheel.FortuneWidget.items}
  final double circleSize;

  /// {@macro flutter_fortune_wheel.FortuneWidget.items}
  final List<FortuneItem> items;

  /// {@macro flutter_fortune_wheel.FortuneWidget.selected}
  final Stream<int> selected;

  /// {@macro flutter_fortune_wheel.FortuneWidget.rotationCount}
  final int rotationCount;

  /// {@macro flutter_fortune_wheel.FortuneWidget.duration}
  final Duration duration;

  /// {@macro flutter_fortune_wheel.FortuneWidget.indicators}
  final List<FortuneIndicator> indicators;

  /// {@macro flutter_fortune_wheel.FortuneWidget.animationType}
  final Curve curve;

  /// {@macro flutter_fortune_wheel.FortuneWidget.onAnimationStart}
  final VoidCallback? onAnimationStart;

  /// {@macro flutter_fortune_wheel.FortuneWidget.onAnimationEnd}
  final VoidCallback? onAnimationEnd;

  /// {@macro flutter_fortune_wheel.FortuneWidget.styleStrategy}
  final StyleStrategy styleStrategy;

  /// {@macro flutter_fortune_wheel.FortuneWidget.animateFirst}
  final bool animateFirst;

  /// {@macro flutter_fortune_wheel.FortuneWidget.physics}
  final PanPhysics physics;

  /// {@macro flutter_fortune_wheel.FortuneWidget.onFling}
  final VoidCallback? onFling;

  /// The position to which the wheel aligns the selected value.
  ///
  /// Defaults to [Alignment.topCenter]
  final Alignment alignment;

  /// HapticFeedback strength on each section border crossing.
  ///
  /// Defaults to [HapticImpact.none]
  final HapticImpact hapticImpact;

  /// Called with the index of the item at the focused [alignment] whenever
  /// a section border is crossed.
  final ValueChanged<int>? onFocusItemChanged;

  final ValueChanged<int>? onSelectedValueChanged;

  double _getAngle(double progress) {
    return 2 * _math.pi * rotationCount * progress;
  }

  /// {@template flutter_fortune_wheel.FortuneWheel}
  /// Creates a new [FortuneWheel] with the given [items], which is centered
  /// on the [selected] value.
  ///
  /// {@macro flutter_fortune_wheel.FortuneWidget.ctorArgs}.
  ///
  /// See also:
  ///  * [FortuneBar], which provides an alternative visualization.
  /// {@endtemplate}
  FortuneWheel({
    Key? key,
    required this.items,
    this.isBig = false,
    this.circleSize = 300.0,
    this.rotationCount = FortuneWidget.kDefaultRotationCount,
    this.selected = const Stream<int>.empty(),
    this.duration = FortuneWidget.kDefaultDuration,
    this.curve = FortuneCurve.spin,
    this.indicators = kDefaultIndicators,
    this.styleStrategy = kDefaultStyleStrategy,
    this.animateFirst = true,
    this.onAnimationStart,
    this.onAnimationEnd,
    this.alignment = Alignment.topCenter,
    this.hapticImpact = HapticImpact.none,
    PanPhysics? physics,
    this.onFling,
    this.onFocusItemChanged,
    this.onSelectedValueChanged,
  })  : physics = physics ?? CircularPanPhysics(),
        assert(items.length > 1),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState<int>(0);
    var rotateAnimCtrl = useAnimationController(duration: duration);

    final rotateAnim = CurvedAnimation(parent: rotateAnimCtrl, curve: curve);
    Future<void> animate() async {
      if (rotateAnimCtrl.isAnimating) {
        return;
      }

      await Future.microtask(() => onAnimationStart?.call());
      await rotateAnimCtrl.forward(from: 0);
      await Future.microtask(() => onAnimationEnd?.call());
      //print("==== selectedIndex.value -> ${selectedIndex.value}");
      onSelectedValueChanged?.call(selectedIndex.value);
    }

    useEffect(() {
      if (animateFirst) animate();
      return null;
    }, []);

    useEffect(() {
      final subscription = selected.listen((event) {
        selectedIndex.value = event;
        animate();
      });
      return subscription.cancel;
    }, []);

    final lastVibratedAngle = useRef<double>(0);

    var lastFocusedIndex = selectedIndex.value;

    return PanAwareBuilder(
      behavior: HitTestBehavior.opaque,
      physics: physics,
      onFling: onFling,
      onPanChanged: (panState) {
        if (lastFocusedIndex != null) {
          //print("==== UPDATE NEW SELECTED POSITION  -> ${lastFocusedIndex} ");
          selectedIndex.value = lastFocusedIndex;
        }
      },
      builder: (context, panState) {
        return Stack(
          children: [
            AnimatedBuilder(
                animation: rotateAnim,
                builder: (context, _) {
                  final size = MediaQuery.of(context).size;
                  final meanSize = (size.width + size.height) / 2;
                  final panFactor = 6 / meanSize;

                  return LayoutBuilder(builder: (context, constraints) {
                    final panDistance = panState.distance;
                    final wheelData = _WheelData(
                      customOffset: isBig ? Offset(0, size.height / 2) : null,
                      constraints: BoxConstraints(
                        maxWidth: isBig ? circleSize * 3 : circleSize,
                        maxHeight: isBig ? circleSize * 3 : circleSize,
                      ),
                      itemCount: items.length,
                      textDirection: Directionality.of(context),
                    );

                    // print("====== wheel Offset -> ${wheelData.offset}");
                    // print("====== wheel Radius -> ${wheelData.radius}");

                    final selectedIndexValue = selectedIndex.value;

                    final isAnimatingPanFactor =
                        rotateAnimCtrl.isAnimating ? 0 : 1;
                    final selectedAngle =
                        -2 * _math.pi * (selectedIndexValue / items.length);
                    final panAngle =
                        panDistance * panFactor * isAnimatingPanFactor;
                    //Made the angle value /2 - to make rotation round smaller and should rotate to next coming value.
                    final rotationAngle = _getAngle(rotateAnim.value / 2);
                    final totalAngle = selectedAngle + panAngle + rotationAngle;

                    final focusedIndex = _vibrateIfBorderCrossed(
                      totalAngle,
                      lastVibratedAngle,
                      items.length,
                      hapticImpact,
                    );

                    if (focusedIndex != null) {
                      final index = focusedIndex % items.length;
                      lastFocusedIndex = index;
                      onFocusItemChanged?.call(index);
                    }

                    final alignmentOffset =
                        _calculateAlignmentOffset(alignment);
                    var index = -1;
                    final transformedItems = items.map((
                      e,
                    ) {
                      index += 1;
                      final angle = totalAngle +
                          alignmentOffset +
                          _calculateSliceAngle(index, items.length);
                      // print(
                      //     "===== index ${index} ${(items[index].child as Text).data} - Angle -> $angle    ");

                      // return TransformedFortuneItem(
                      //   item: FortuneItem(
                      //       child: Text(
                      //         angle.toString(),
                      //       ),
                      //       style: FortuneItemStyle(
                      //         color: e.style!.color,
                      //         textStyle: TextStyle(fontSize: 12),
                      //       ),
                      //       onTap: e.onTap),
                      //   angle: angle,
                      //   offset: wheelData.offset,
                      // );

                      return TransformedFortuneItem(
                        item: lastFocusedIndex /*selectedIndex.value*/ == index
                            ? FortuneItem(
                                child: e.child,
                                style: isBig
                                    ? FortuneItemStyle(
                                        color: Colors.white,
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : e.style,
                                isSelected: true)
                            : e,
                        angle: angle,
                        offset: wheelData.offset,
                      );
                    }).toList();

                    final circleSlicesChild = _CircleSlices(
                      isBigCircle: isBig,
                      items: transformedItems,
                      wheelData: wheelData,
                      styleStrategy: styleStrategy,
                    );

                    if (isBig) {
                      return Container(
                        //color: Colors.orange,
                        child: SizedBox.expand(
                          //size: Size(circleSize * 2, circleSize * 2),
                          child: Container(
                            //color: Colors.yellow,
                            child: circleSlicesChild,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        //color: Colors.lightBlue,
                        child: SizedBox.fromSize(
                          size: Size(circleSize, circleSize),
                          child: circleSlicesChild,
                        ),
                      );
                    }
                  });
                }),
            if (indicators.isNotEmpty)
              Positioned(
                right: 0,
                top: (circleSize / 2) - 8,
                child: IgnorePointer(
                  child: _WheelIndicator(
                    indicator: indicators.first,
                    size: circleSize,
                  ),
                ),
              ),
            // for (var it in indicators)
            //   IgnorePointer(
            //     child: _WheelIndicator(
            //       indicator: it,
            //       size: circleSize,
            //     ),
            //   ),
          ],
        );
      },
    );
  }

  int? _vibrateIfBorderCrossed(
    double angle,
    ObjectRef<double> lastVibratedAngle,
    int itemsNumber,
    HapticImpact hapticImpact,
  ) {
    final step = 360 / itemsNumber;
    final angleDegrees = (angle * 180 / _math.pi).abs() + step / 2;
    if (step.isNaN ||
        angleDegrees.isNaN ||
        lastVibratedAngle.value.isNaN ||
        lastVibratedAngle.value.isInfinite ||
        angleDegrees.isInfinite ||
        step == 0) {
      return null;
    }
    if (lastVibratedAngle.value ~/ step == angleDegrees ~/ step) {
      return null;
    }
    final index = angleDegrees ~/ step * angle.sign.toInt() * -1;
    final hapticFeedbackFunction;
    switch (hapticImpact) {
      case HapticImpact.none:
        return index;
      case HapticImpact.heavy:
        hapticFeedbackFunction = HapticFeedback.heavyImpact;
        break;
      case HapticImpact.medium:
        hapticFeedbackFunction = HapticFeedback.mediumImpact;
        break;
      case HapticImpact.light:
        hapticFeedbackFunction = HapticFeedback.lightImpact;
        break;
    }
    hapticFeedbackFunction();
    lastVibratedAngle.value = angleDegrees ~/ step * step;
    return index;
  }
}
