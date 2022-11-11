import 'package:flutter/material.dart';
import 'package:pill_city_flutter/src/api/home_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HomeState>(context, listen: false).fetchPosts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeState>(builder: (context, home, child) {
      return Text(home.posts.toString());
    });
  }
}
