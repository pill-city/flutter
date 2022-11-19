import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final idRegex = RegExp(r'^[a-zA-Z0-9_-]{1,15}$');

typedef SignInCallback = void Function(String, String);

class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
    required this.onSignIn,
  });

  final SignInCallback onSignIn;

  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: idController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.id,
            ),
            validator: (value) {
              if (value == null || !idRegex.hasMatch(value)) {
                return AppLocalizations.of(context)!.valid_id_please;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.password,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.valid_password_please;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  minimumSize: const Size(double.infinity, 48)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSignIn(idController.text, passwordController.text);
                }
              },
              child: Text(AppLocalizations.of(context)!.signin),
            ),
          ),
        ],
      ),
    );
  }
}
