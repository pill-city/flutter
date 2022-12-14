import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchUrl(
          Uri.parse("https://pill.city/users"),
          mode: LaunchMode.externalApplication,
        );
      },
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.use_this_feature_on_webapp,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
