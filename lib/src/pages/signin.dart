import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/widgets/signin_form.dart';

final api = PillCity().getCoreApi();

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  void showOkDialog(BuildContext context, String title, String message) {
    showDialog<void>(
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

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24),
        child: SignInForm(
          onSignIn: (id, password) {
            var builder = SignInRequestBuilder();
            builder.id = id;
            builder.password = password;
            api
                .signIn(signInRequest: builder.build())
                .then((value) =>
                    {showOkDialog(context, "then", value.toString())})
                .catchError((error) {
              showOkDialog(context, "error", error.toString());
            });
          },
        ));
  }
}
