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
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const homeContentMaxLines = 20;
const homeMaxLinkPreviews = 1;
const homeFullReactionMaxUsers = 2;
const homeCommentMaxLines = 1;
const homeMaxComments = 3;
const homeMaxNestedComments = 6;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.itemScrollController});

  final ItemScrollController itemScrollController;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Post> _posts = [];
  String? _headPostId;
  String? _tailPostId;
  bool _loadingInitialPosts = true;
  DioError? _loadingInitialPostsError;
  bool _loadingMorePosts = false;
  DioError? _loadingMorePostsError;

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialPosts();
    });
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
      List<Post> posts = response.data!.toList();
      if (posts.isEmpty) return;
      _headPostId = posts.first.id;
      _tailPostId = posts.last.id;
      setState(() {
        _posts =
            posts.where((p) => p.state != PostStateEnum.invisible).toList();
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
    if (_tailPostId == null) {
      return;
    }

    try {
      final appGlobalState =
          Provider.of<AppGlobalState>(context, listen: false);
      final api = await appGlobalState.getAuthenticatedApi();
      final response = await api.getCoreApi().getHome(fromId: _tailPostId);
      if (response.data == null) {
        return Future.error("Failed to load more posts");
      }
      List<Post> posts = response.data!.toList();
      if (posts.isEmpty) return;
      _tailPostId = posts.last.id;
      setState(() {
        _posts.addAll(
          posts.where((p) => p.state != PostStateEnum.invisible).toList(),
        );
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
    if (_headPostId == null) {
      return;
    }

    try {
      final appGlobalState =
          Provider.of<AppGlobalState>(context, listen: false);
      final api = await appGlobalState.getAuthenticatedApi();
      final response = await api.getCoreApi().getHome(toId: _headPostId);
      if (response.data == null) {
        return Future.error("Failed to load more posts");
      }
      List<Post> posts = response.data!.toList();
      if (posts.isNotEmpty) {
        _headPostId = posts.first.id;
      }
      posts = posts.where((p) => p.state != PostStateEnum.invisible).toList();
      setState(() {
        _posts = [...posts, ..._posts];
      });
      widget.itemScrollController.jumpTo(index: posts.length);
      int newPosts = posts.length;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.new_posts(newPosts),
          ),
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
              child: ScrollablePositionedList.builder(
                itemScrollController: widget.itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemCount: _posts
                        .where((p) => p.state != PostStateEnum.invisible)
                        .length +
                    1,
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
