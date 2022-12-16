import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city_flutter/src/pages/create_post.dart';
import 'package:pill_city_flutter/src/state/home_state.dart';
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

  _loadInitialPosts() async {
    try {
      await Provider.of<HomeState>(context, listen: false)
          .loadInitialPosts(context);
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
    try {
      await Provider.of<HomeState>(context, listen: false)
          .loadMorePosts(context);
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
    try {
      int newPosts = await Provider.of<HomeState>(context, listen: false)
          .loadLatestPosts(context);
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
              child: Consumer<HomeState>(
                builder: (context, home, child) {
                  return ListView.builder(
                    controller: widget.scrollController,
                    itemCount: home.posts.length + 1,
                    itemBuilder: (context, index) {
                      if (index < home.posts.length) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: PostWidget(
                                post: home.posts[index],
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
                                child:
                                    Text(AppLocalizations.of(context)!.retry),
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
                  );
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
