import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/state/app_global_state.dart';
import 'package:provider/provider.dart';

class HomeState extends ChangeNotifier {
  List<Post> _posts = [];

  UnmodifiableListView<Post> get posts => UnmodifiableListView(_posts);

  bool _shouldShowPost(Post post) {
    return !(post.deleted != null && post.deleted!) ||
        !(post.blocked != null && post.blocked!) ||
        !(post.reactions != null && post.reactions!.isNotEmpty) ||
        !(post.comments != null && post.comments!.isNotEmpty);
  }

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
    _posts = response.data!.where(_shouldShowPost).toList();
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
    _posts.addAll(response.data!.where(_shouldShowPost));
  }

  Future<int> loadLatestPosts(BuildContext context) async {
    if (_posts.isEmpty) {
      return 0;
    }
    final appGlobalState = Provider.of<AppGlobalState>(context, listen: false);
    final api = await appGlobalState.getAuthenticatedApi();
    final response = await api.getCoreApi().getHome(toId: _posts.first.id);
    if (response.data == null) {
      return Future.error("Failed to load more posts");
    }
    var data = response.data!.where(_shouldShowPost);
    _posts = [...data, ..._posts];
    return data.length;
  }
}
