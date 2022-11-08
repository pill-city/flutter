import 'package:flutter/material.dart';
import 'package:pill_city_flutter/src/widgets/signin_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.all(24), child: SignInForm());
  }
}
