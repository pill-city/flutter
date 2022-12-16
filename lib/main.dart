import 'package:flutter/material.dart';
import 'package:pill_city_flutter/src/app.dart';
import 'package:pill_city_flutter/src/state/app_global_state.dart';
import 'package:pill_city_flutter/src/state/me_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppGlobalState()),
        ChangeNotifierProvider(create: (context) => MeState()),
      ],
      child: App(),
    ),
  );
}
