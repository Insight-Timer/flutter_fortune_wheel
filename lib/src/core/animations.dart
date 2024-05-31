part of 'core.dart';

/// A selection of commonly used curves for animating when the value of
/// [FortuneWidget.selected] changes.
class FortuneCurve {
  const FortuneCurve._();

  /// The default curve used when spinning a [FortuneWidget].
  static const Curve spin = Cubic(0, 0.5, 0, 0.5);
  //static const Curve spin = Cubic(0, 1, 0, 1);
  //updated the value to 0.5 to make the spin slower as we tap

  /// A curve used for disabling spin animations.
  static const Curve none = Threshold(0.0);
}
