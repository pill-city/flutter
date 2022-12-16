import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/pages/create_post.dart';
import 'package:pill_city_flutter/src/state/app_global_state.dart';
import 'package:pill_city_flutter/src/utils/get_error_message.dart';
import 'package:pill_city_flutter/src/widgets/loading_and_retry_widget.dart';
import 'package:pill_city_flutter/src/widgets/post_widget.dart';
import 'package:provider/provider.dart';

const homeContentMaxLines = 20;
const homeMaxLinkPreviews = 1;
const homeFullReactionMaxUsers = 2;
const homeCommentMaxLines = 1;
const homeMaxComments = 3;
const homeMaxNestedComments = 6;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Post> _posts = [];
  bool _loadingInitialPosts = true;
  DioError? _loadingInitialPostsError;
  bool _loadingMorePosts = false;
  DioError? _loadingMorePostsError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialPosts();
    });
  }

  bool _shouldShowPost(Post post) {
    return !(post.deleted != null && post.deleted!) ||
        !(post.blocked != null && post.blocked!) ||
        !(post.reactions != null && post.reactions!.isNotEmpty) ||
        !(post.comments != null && post.comments!.isNotEmpty);
  }

  _loadInitialPosts() async {
    if (_posts.isNotEmpty) {
      return;
    }

    try {
      final appGlobalState =
          Provider.of<AppGlobalState>(context, listen: false);
      final api = await appGlobalState.getAuthenticatedApi();
      final response = await api.getCoreApi().getHome();
      if (response.data == null) {
        return Future.error("Failed to load initial posts");
      }
      setState(() {
        _posts = response.data!.where(_shouldShowPost).toList();
      });
    } on DioError catch (errorCaught) {
      setState(() {
        _loadingInitialPostsError = errorCaught;
      });
    } finally {
      setState(() {
        _loadingInitialPosts = false;
      });
    }
  }

  _loadMorePosts() async {
    if (_posts.isEmpty) {
      return;
    }

    try {
      final appGlobalState =
          Provider.of<AppGlobalState>(context, listen: false);
      final api = await appGlobalState.getAuthenticatedApi();
      final response = await api.getCoreApi().getHome(fromId: _posts.last.id);
      if (response.data == null) {
        return Future.error("Failed to load more posts");
      }
      setState(() {
        _posts.addAll(response.data!.where(_shouldShowPost));
      });
    } on DioError catch (errorCaught) {
      setState(() {
        _loadingMorePostsError = errorCaught;
      });
    } finally {
      setState(() {
        _loadingMorePosts = false;
      });
    }
  }

  Future<void> _loadLatestPosts() async {
    if (_posts.isEmpty) {
      return;
    }

    try {
      final appGlobalState =
          Provider.of<AppGlobalState>(context, listen: false);
      final api = await appGlobalState.getAuthenticatedApi();
      final response = await api.getCoreApi().getHome(toId: _posts.first.id);
      if (response.data == null) {
        return Future.error("Failed to load more posts");
      }
      var data = response.data!.where(_shouldShowPost);
      setState(() {
        _posts = [...data, ..._posts];
      });
      int newPosts = data.length;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.new_posts(newPosts),
          ),
          width: 288,
          padding: const EdgeInsets.all(16),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 3000),
        ),
      );
    } on DioError catch (errorCaught) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            getErrorMessage(errorCaught),
          ),
          width: 288,
          padding: const EdgeInsets.all(16),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 3000),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingAndRetryWidget(
      loading: _loadingInitialPosts,
      error: _loadingInitialPostsError,
      builder: (BuildContext buildContext) {
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadLatestPosts,
              child: ListView.builder(
                controller: widget.scrollController,
                itemCount: _posts.length + 1,
                itemBuilder: (context, index) {
                  if (index < _posts.length) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: PostWidget(
                            post: _posts[index],
                            contentMaxLines: homeContentMaxLines,
                            maxLinkPreviews: homeMaxLinkPreviews,
                            fullReactionMaxUsers: homeFullReactionMaxUsers,
                            commentMaxLines: homeCommentMaxLines,
                            maxComments: homeMaxComments,
                            maxNestedComments: homeMaxNestedComments,
                            showMedia: false,
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                        )
                      ],
                    );
                  } else {
                    if (_loadingMorePosts) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (_loadingMorePostsError != null) {
                      return Column(
                        children: [
                          Text(
                            getErrorMessage(_loadingMorePostsError!),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _loadingMorePosts = true;
                                _loadingMorePostsError = null;
                              });
                              _loadMorePosts();
                            },
                            child: Text(AppLocalizations.of(context)!.retry),
                          ),
                        ],
                      );
                    } else {
                      _loadMorePosts();
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => const CreatePost(),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ],
        );
      },
      onRetry: () {
        setState(() {
          _loadingInitialPosts = true;
          _loadingInitialPostsError = null;
        });
        _loadInitialPosts();
      },
    );
  }
}
