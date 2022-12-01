import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:pill_city_flutter/src/state/app_global_state.dart';
import 'package:pill_city_flutter/src/state/home_state.dart';
import 'package:pill_city_flutter/src/state/me_state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 32),
              Text(AppLocalizations.of(context)!.signing_out),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return GestureDetector(
      onTap: () {
        launchUrl(
          Uri.parse("https://pill.city/profile"),
          mode: LaunchMode.externalApplication,
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.use_this_feature_on_webapp,
            textAlign: TextAlign.center,
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              showLoaderDialog(context);

              final appGlobalState =
                  Provider.of<AppGlobalState>(context, listen: false);
              await appGlobalState.resetAccessToken();
              if (!mounted) return;
              final homeState = Provider.of<HomeState>(context, listen: false);
              homeState.reset();
              final meState = Provider.of<MeState>(context, listen: false);
              meState.reset();
              GoRouter.of(context).go('/signin');
            },
            child: Text(AppLocalizations.of(context)!.signout),
          )
        ],
      ),
    );
  }
}
