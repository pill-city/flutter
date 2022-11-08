import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final idRegex = RegExp(r'^[a-zA-Z0-9_-]{1,15}$');

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
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
          const SizedBox(height: 12),
          TextFormField(
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
          const SizedBox(height: 12),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  minimumSize: const Size(144, 48)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
              },
              child: Text(AppLocalizations.of(context)!.signin))
        ],
      ),
    );
  }
}
