import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'package:pill_city_flutter/src/widgets/signin_form.dart';

final api = CoreApi();

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
                onPressed: () {},
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
            final signInRequest = SignInRequest(id: id, password: password);
            api
                .signIn(signInRequest: signInRequest)
                .then((value) =>
                    {showOkDialog(context, "then", value.toString())})
                .catchError((error) {
              showOkDialog(context, "error", error.toString());
            });
          },
        ));
  }
}
