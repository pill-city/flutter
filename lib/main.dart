import 'package:flutter/material.dart';
import 'package:pill_city_flutter/src/api/app_global_state.dart';
import 'package:pill_city_flutter/src/api/home_state.dart';
import 'package:pill_city_flutter/src/app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppGlobalState()),
        ChangeNotifierProvider(create: (context) => HomeState()),
      ],
      child: const App(),
    ),
  );
}
