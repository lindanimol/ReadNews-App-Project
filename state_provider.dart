import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'count_app.dart';
import 'counter_logic.dart';
import 'theme_logic.dart';
import 'gridstyle_logic.dart';
import 'category_logic.dart';

Widget stateProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CounterLogic()),
      ChangeNotifierProvider(create: (_) => ThemeLogic()),
      ChangeNotifierProvider(create: (_) => GridstyleLogic()),
      ChangeNotifierProvider(create: (_) => CategoryLogic()),
    ],
    child: const CountApp(),
  );
}
