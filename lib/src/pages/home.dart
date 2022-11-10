import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pill_city/pill_city.dart';

const secureStorage = FlutterSecureStorage();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<BuiltList<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = loadPosts();
  }

  Future<BuiltList<Post>> loadPosts() async {
    final accessToken = await secureStorage.read(key: "access_token");
    if (accessToken == null) {
      return Future.error("fa");
    }
    PillCity api = PillCity();
    api.setBearerAuth("bearer", accessToken);
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
        future: futurePosts,
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
