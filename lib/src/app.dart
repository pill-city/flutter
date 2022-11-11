import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:pill_city_flutter/src/api/app_global_state.dart';
import 'package:pill_city_flutter/src/pages/circles.dart';
import 'package:pill_city_flutter/src/pages/home.dart';
import 'package:pill_city_flutter/src/pages/notifications.dart';
import 'package:pill_city_flutter/src/pages/profile.dart';
import 'package:pill_city_flutter/src/pages/signin.dart';
import 'package:pill_city_flutter/src/pages/users.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Pill.City",
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('zh', ''),
      ],
      theme: ThemeData(primarySwatch: Colors.red, brightness: Brightness.light),
      darkTheme: ThemeData(
          primarySwatch: Colors.deepOrange, brightness: Brightness.dark),
      themeMode: ThemeMode.light,
      routerConfig: GoRouter(
          initialLocation: '/home',
          redirect: (context, state) async {
            final appGlobalState =
                Provider.of<AppGlobalState>(context, listen: false);
            if ((await appGlobalState.getAccessToken()) == null) {
              return '/signin';
            }
            return null;
          },
          routes: [
            GoRoute(
                path: '/signin',
                builder: (BuildContext context, GoRouterState state) {
                  return const Scaffold(body: SignInPage());
                }),
            ShellRoute(
                navigatorKey: _shellNavigatorKey,
                builder:
                    (BuildContext context, GoRouterState state, Widget child) {
                  return ScaffoldWithNavBar(child: child);
                },
                routes: [
                  GoRoute(
                    path: '/circles',
                    builder: (BuildContext context, GoRouterState state) {
                      return CirclesPage();
                    },
                  ),
                  GoRoute(
                    path: '/users',
                    builder: (BuildContext context, GoRouterState state) {
                      return UsersPage();
                    },
                  ),
                  GoRoute(
                    path: '/home',
                    builder: (BuildContext context, GoRouterState state) {
                      return HomePage();
                    },
                  ),
                  GoRoute(
                    path: '/notifications',
                    builder: (BuildContext context, GoRouterState state) {
                      return NotificationsPage();
                    },
                  ),
                  GoRoute(
                    path: '/profile',
                    builder: (BuildContext context, GoRouterState state) {
                      return ProfilePage();
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
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined),
            label: 'Circles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    if (location == '/circles') {
      return 0;
    }
    if (location == '/users') {
      return 1;
    }
    if (location == '/home') {
      return 2;
    }
    if (location == '/notifications') {
      return 3;
    }
    if (location == '/profile') {
      return 4;
    }
    return 2;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/circles');
        break;
      case 1:
        GoRouter.of(context).go('/users');
        break;
      case 2:
        GoRouter.of(context).go('/home');
        break;
      case 3:
        GoRouter.of(context).go('/notifications');
        break;
      case 4:
        GoRouter.of(context).go('/profile');
        break;
    }
  }
}
