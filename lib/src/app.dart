import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:pill_city_flutter/src/pages/home.dart';
import 'package:pill_city_flutter/src/pages/notifications.dart';
import 'package:pill_city_flutter/src/pages/post.dart';
import 'package:pill_city_flutter/src/pages/profile.dart';
import 'package:pill_city_flutter/src/pages/scopes.dart';
import 'package:pill_city_flutter/src/pages/signin.dart';
import 'package:pill_city_flutter/src/pages/users.dart';
import 'package:pill_city_flutter/src/state/app_global_state.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class App extends StatelessWidget {
  App({super.key});

  final ScrollController _homeScrollController = ScrollController();

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
      theme: ThemeData.light().copyWith(
        colorScheme: ThemeData.light().colorScheme.copyWith(
              primary: Colors.red,
              secondary: Colors.redAccent,
            ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ThemeData.dark().colorScheme.copyWith(
              primary: Colors.deepOrange,
              secondary: Colors.deepOrangeAccent,
            ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      themeMode: ThemeMode.system,
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
          GoRoute(
              path: '/post/:postId',
              builder: (BuildContext context, GoRouterState state) {
                return Scaffold(
                  body: PostPage(
                    postId: state.params["postId"]!,
                  ),
                );
              }),
          ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (BuildContext context, GoRouterState state, Widget child) {
              return MyScaffold(
                homeScrollController: _homeScrollController,
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: '/scopes',
                builder: (BuildContext context, GoRouterState state) {
                  return const ScopesPage();
                },
              ),
              GoRoute(
                path: '/users',
                builder: (BuildContext context, GoRouterState state) {
                  return const UsersPage();
                },
              ),
              GoRoute(
                path: '/home',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePage(
                    scrollController: _homeScrollController,
                  );
                },
              ),
              GoRoute(
                path: '/notifications',
                builder: (BuildContext context, GoRouterState state) {
                  return const NotificationsPage();
                },
              ),
              GoRoute(
                path: '/profile',
                builder: (BuildContext context, GoRouterState state) {
                  return const ProfilePage();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    Key? key,
    required this.child,
    required this.homeScrollController,
    this.fab,
  }) : super(key: key);

  final Widget child;
  final ScrollController homeScrollController;
  final FloatingActionButton? fab;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.visibility),
              label: AppLocalizations.of(context)!.scopes,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people),
              label: AppLocalizations.of(context)!.users,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications),
              label: AppLocalizations.of(context)!.notifications,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle),
              label: AppLocalizations.of(context)!.profile,
            ),
          ],
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int idx) => _onItemTapped(idx, context),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    if (location == '/scopes') {
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
        GoRouter.of(context).go('/scopes');
        break;
      case 1:
        GoRouter.of(context).go('/users');
        break;
      case 2:
        GoRouter.of(context).go('/home');
        homeScrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
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
