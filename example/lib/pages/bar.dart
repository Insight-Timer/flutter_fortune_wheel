import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../common/common.dart';
import '../widgets/widgets.dart';

class FortuneBarPage extends HookWidget {
  static const kRouteName = 'FortuneBarPage';

  static void go(BuildContext context) {
    context.goNamed(kRouteName);
  }

  @override
  Widget build(BuildContext context) {
    final selected = useStreamController<int>();
    final selectedIndex = useStream(selected.stream, initialData: 0).data ?? 0;
    final isAnimating = useState(false);

    void handleRoll() {
      selected.add(
        roll(Constants.emotions.length),
      );
    }

    return AppLayout(
      child: Column(
        children: [
          SizedBox(height: 8),
          RollButtonWithPreview(
            selected: selectedIndex,
            items: Constants.emotions.map((e) => e.name).toList(),
            onPressed: isAnimating.value ? null : handleRoll,
          ),
          SizedBox(height: 8),
          Expanded(
            child: Center(
              child: FortuneBar(
                selected: selected.stream,
                items: [
                  for (var it in Constants.emotions)
                    FortuneItem(child: Text(it.name), onTap: () => print(it))
                ],
                onFling: handleRoll,
                onAnimationStart: () {
                  isAnimating.value = true;
                },
                onAnimationEnd: () {
                  isAnimating.value = false;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
