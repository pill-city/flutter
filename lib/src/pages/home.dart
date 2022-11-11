import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/api/app_global_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<BuiltList<Post>> loadPosts(BuildContext context) async {
    final appGlobalState = Provider.of<AppGlobalState>(context, listen: false);
    final api = await appGlobalState.getAuthenticatedApi();
    try {
      final response = await api.getCoreApi().getHome();
      if (response.data == null) {
        return Future.error("fa");
      }
      return response.data!;
    } on DioError catch (error) {
      return Future.error(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<BuiltList<Post>>(
        future: loadPosts(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.toString());
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
