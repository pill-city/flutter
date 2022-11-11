import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/api/app_global_state.dart';
import 'package:provider/provider.dart';

class HomeState extends ChangeNotifier {
  final List<Post> _posts = [];

  UnmodifiableListView<Post> get posts => UnmodifiableListView(_posts);

  Future<void> fetchPosts(BuildContext context) async {
    final appGlobalState = Provider.of<AppGlobalState>(context, listen: false);
    final api = await appGlobalState.getAuthenticatedApi();
    try {
      final response = await api.getCoreApi().getHome();
      if (response.data == null) {
        return Future.error("Failed to poll posts");
      }
      _posts.addAll(response.data!);
    } on DioError catch (error) {
      return Future.error(error);
    } finally {
      notifyListeners();
    }
  }
}
