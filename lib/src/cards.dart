import 'package:flutter/material.dart';

const TextStyle textStyle = TextStyle(
  fontSize: 32.0,
  fontWeight: FontWeight.w600,
);

const data = [
  "ktt",
  "ikaka"
];

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: const Alignment(0.6, 0.1),
        children: [
          Center(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return CustomCard(
                    title: data[index],
                    onPress: () {
                      print(data[index]);
                    },
                  );
                },
              )
          ),
          Container(
            color: Colors.black45,
            child: const Text('Flutter'),
          ),
        ]
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.title,
    required this.onPress
  });

  final String title;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
          children: <Widget>[
            Text(title, style: textStyle,),
            Theme(data: ThemeData(
              primaryColor: Colors.cyan,
              brightness: Brightness.light,
            ), child: TextButton(
              onPressed: onPress,
              child: const Text('Message'),
            )),
            const CircleAvatar(
              backgroundImage: AssetImage("assets/image.webp"),
            ),
            const Icon(Icons.lightbulb_outline)
          ],
        ));
  }
}