import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pill_city_flutter/src/blinker.dart';
import 'package:pill_city_flutter/src/cards.dart';
import 'package:pill_city_flutter/src/form.dart';
import 'package:pill_city_flutter/src/ip_address.dart';
import 'package:pill_city_flutter/src/pages/signin.dart';

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Welcome to Flutter!",
      theme: ThemeData(primarySwatch: Colors.red, brightness: Brightness.light),
      darkTheme: ThemeData(
          primarySwatch: Colors.deepOrange, brightness: Brightness.dark),
      themeMode: ThemeMode.light,
      routerConfig: GoRouter(initialLocation: '/signin', routes: [
        GoRoute(
            path: '/signin',
            builder: (BuildContext context, GoRouterState state) {
              return const Scaffold(body: SignInPage());
            }),
        ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (BuildContext context, GoRouterState state, Widget child) {
              return ScaffoldWithNavBar(child: child);
            },
            routes: [
              GoRoute(
                path: '/cards',
                builder: (BuildContext context, GoRouterState state) {
                  return const CardsPage();
                },
              ),
              GoRoute(
                path: '/blinker',
                builder: (BuildContext context, GoRouterState state) {
                  return const BlinkerPage();
                },
              ),
              GoRoute(
                path: '/ip',
                builder: (BuildContext context, GoRouterState state) {
                  return const IpAddressPage();
                },
              ),
              GoRoute(
                path: '/form',
                builder: (BuildContext context, GoRouterState state) {
                  return FormPage();
                },
              ),
            ])
      ]),
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_calculateSelectedLabel(context)),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.light),
            label: 'Blinker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor),
            label: 'IP Address',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.input),
            label: 'Form',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    if (location == '/cards') {
      return 0;
    }
    if (location == '/blinker') {
      return 1;
    }
    if (location == '/ip') {
      return 2;
    }
    if (location == '/form') {
      return 3;
    }
    return 0;
  }

  static String _calculateSelectedLabel(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    if (location == '/cards') {
      return "Cards";
    }
    if (location == '/blinker') {
      return "Blinker";
    }
    if (location == '/ip') {
      return "IP Address";
    }
    if (location == '/form') {
      return "Form";
    }
    return "App";
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/cards');
        break;
      case 1:
        GoRouter.of(context).go('/blinker');
        break;
      case 2:
        GoRouter.of(context).go('/ip');
        break;
      case 3:
        GoRouter.of(context).go('/form');
        break;
    }
  }
}
