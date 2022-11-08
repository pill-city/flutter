import 'dart:async';

import 'package:flutter/material.dart';

class BlinkerPage extends StatelessWidget {
  const BlinkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: MyStatefulWidget(title: "fuck me senpai"),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool showText = true;
  bool toggleState = true;
  Timer? t2;

  void toggleBlinkState() {
    setState(() {
      toggleState = !toggleState;
    });
    if (!toggleState) {
      t2 = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        toggleShowText();
      });
    } else {
      t2?.cancel();
    }
  }

  void toggleShowText() {
    setState(() {
      showText = !showText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          if (showText)
            const Text(
              'This execution will be done before you can blink.',
            ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: ElevatedButton(
              onPressed: toggleBlinkState,
              child: toggleState
                  ? const Text('Blink')
                  : const Text('Stop Blinking'),
            ),
          ),
        ],
      ),
    );
  }
}