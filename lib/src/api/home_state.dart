import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/api/app_global_state.dart';
import 'package:provider/provider.dart';

class HomeState extends ChangeNotifier {
  final List<Post> _posts = [];

  UnmodifiableListView<Post> get posts => UnmodifiableListView(_posts);

  bool loadingInitialPosts = true;
  DioError? initialPostsError;

  bool loadingMorePosts = false;
  DioError? morePostsError;

  Future<void> loadInitialPosts(BuildContext context) async {
    if (_posts.isNotEmpty) {
      return;
    }
    loadingInitialPosts = true;
    initialPostsError = null;
    notifyListeners();
    final appGlobalState = Provider.of<AppGlobalState>(context, listen: false);
    final api = await appGlobalState.getAuthenticatedApi();
    try {
      final response = await api.getCoreApi().getHome();
      if (response.data == null) {
        return Future.error("Failed to load initial posts");
      }
      _posts.clear();
      _posts.addAll(response.data!);
    } on DioError catch (errorCaught) {
      initialPostsError = errorCaught;
    } finally {
      loadingInitialPosts = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePosts(BuildContext context) async {
    if (_posts.isEmpty) {
      return;
    }
    loadingMorePosts = true;
    morePostsError = null;
    notifyListeners();
    final appGlobalState = Provider.of<AppGlobalState>(context, listen: false);
    final api = await appGlobalState.getAuthenticatedApi();
    try {
      final response = await api.getCoreApi().getHome(fromId: _posts.last.id);
      if (response.data == null) {
        return Future.error("Failed to load more posts");
      }
      _posts.addAll(response.data!);
    } on DioError catch (errorCaught) {
      morePostsError = errorCaught;
    } finally {
      loadingMorePosts = false;
      notifyListeners();
    }
  }
}
