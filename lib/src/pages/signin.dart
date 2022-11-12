import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/api/app_global_state.dart';
import 'package:pill_city_flutter/src/widgets/signin_form.dart';
import 'package:provider/provider.dart';

final api = PillCity().getCoreApi();

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  showOkDialog(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

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
              Text(AppLocalizations.of(context)!.signing_in),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Padding(
        padding: const EdgeInsets.all(32),
        child: SignInForm(
          onSignIn: (id, password) async {
            var builder = SignInRequestBuilder();
            builder.id = id;
            builder.password = password;

            showLoaderDialog(context);

            try {
              var response = await api.signIn(signInRequest: builder.build());
              if (!mounted) return;
              Navigator.of(context).pop();
              if (response.data == null) {
                showOkDialog(context, AppLocalizations.of(context)!.error,
                    AppLocalizations.of(context)!.unknown_error);
              } else {
                String accessToken = response.data!.accessToken;
                num expires = response.data!.expires;
                final appGlobalState =
                    Provider.of<AppGlobalState>(context, listen: false);
                await appGlobalState.setAccessToken(
                    accessToken, expires.toString());
                if (!mounted) return;
                GoRouter.of(context).go('/home');
              }
            } on DioError catch (error) {
              if (!mounted) return;
              Navigator.of(context).pop();
              Map<String, dynamic>? decodedResponse;
              try {
                decodedResponse = json.decode(error.response.toString())
                    as Map<String, dynamic>;
              } on FormatException catch (_) {
                showOkDialog(context, AppLocalizations.of(context)!.error,
                    AppLocalizations.of(context)!.unknown_error);
              }
              if (decodedResponse == null) {
                showOkDialog(context, AppLocalizations.of(context)!.error,
                    error.response.toString());
                return;
              }
              if (!decodedResponse.containsKey('msg')) {
                showOkDialog(context, AppLocalizations.of(context)!.error,
                    error.response.toString());
                return;
              }
              showOkDialog(context, AppLocalizations.of(context)!.error,
                  decodedResponse['msg']);
            }
          },
        ));
  }
}
