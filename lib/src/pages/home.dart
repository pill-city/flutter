import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city_flutter/src/state/home_state.dart';
import 'package:pill_city_flutter/src/utils/get_error_message.dart';
import 'package:pill_city_flutter/src/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeState>(
      builder: (context, home, child) {
        if (_loadingInitialPosts) {
          return const Center(child: CircularProgressIndicator());
        } else if (_loadingInitialPostsError != null) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(getErrorMessage(_loadingInitialPostsError!)),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loadingInitialPosts = true;
                        _loadingInitialPostsError = null;
                      });
                      _loadInitialPosts();
                    },
                    child: Text(AppLocalizations.of(context)!.retry))
              ]);
        } else {
          return ListView.builder(
            itemCount: home.posts.length + 1,
            itemBuilder: (context, index) {
              if (index < home.posts.length) {
                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: PostWidget(post: home.posts[index]),
                  ),
                  const Divider(
                    thickness: 1,
                  )
                ]);
              } else {
                if (_loadingMorePosts) {
                  return const Center(child: CircularProgressIndicator());
                } else if (_loadingMorePostsError != null) {
                  return Column(
                    children: [
                      Text(getErrorMessage(_loadingMorePostsError!)),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _loadingMorePosts = true;
                              _loadingMorePostsError = null;
                            });
                            _loadMorePosts();
                          },
                          child: Text(AppLocalizations.of(context)!.retry))
                    ],
                  );
                } else {
                  _loadMorePosts();
                  return const Center(child: CircularProgressIndicator());
                }
              }
            },
          );
        }
      },
    );
  }
}
