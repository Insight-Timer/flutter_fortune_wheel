import 'package:flutter_fortune_wheel_example/pages/wheel_big.dart';
import 'package:go_router/go_router.dart';

import 'pages/pages.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => FortuneWheelPage(),
      name: FortuneWheelPage.kRouteName,
    ),
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => FortuneWheelBigPage(),
    //   name: FortuneWheelBigPage.kRouteName,
    // ),
  ],
);
