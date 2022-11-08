import 'package:flutter/material.dart';

class FormPage extends StatelessWidget {
  FormPage({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "What you wanted to say",
            labelText: "Say something"
          ),
        ),
        ElevatedButton(onPressed: () {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: const Text('Fake news alert'),
              content: Text('You typed ${_controller.text}'),
            );
          });
        }, child: const Text("Submit"))
      ],
    );
  }
}