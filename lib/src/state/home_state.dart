import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/state/app_global_state.dart';
import 'package:provider/provider.dart';

class HomeState extends ChangeNotifier {
  final List<Post> _posts = [];

  UnmodifiableListView<Post> get posts => UnmodifiableListView(_posts);

  Future<void> loadInitialPosts(BuildContext context) async {
    if (_posts.isNotEmpty) {
      return;
    }
    final appGlobalState = Provider.of<AppGlobalState>(context, listen: false);
    final api = await appGlobalState.getAuthenticatedApi();
    final response = await api.getCoreApi().getHome();
    if (response.data == null) {
      return Future.error("Failed to load initial posts");
    }
    _posts.clear();
    _posts.addAll(response.data!);
  }

  Future<void> loadMorePosts(BuildContext context) async {
    if (_posts.isEmpty) {
      return;
    }
    final appGlobalState = Provider.of<AppGlobalState>(context, listen: false);
    final api = await appGlobalState.getAuthenticatedApi();
    final response = await api.getCoreApi().getHome(fromId: _posts.last.id);
    if (response.data == null) {
      return Future.error("Failed to load more posts");
    }
    _posts.addAll(response.data!);
  }
}
