import 'package:flutter/material.dart';

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
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'ID'),
            validator: (value) {
              if (value == null || !idRegex.hasMatch(value)) {
                return 'Please enter a valid ID';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid password';
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
              child: const Text('Sign In'))
        ],
      ),
    );
  }
}
