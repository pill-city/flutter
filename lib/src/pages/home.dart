import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city_flutter/src/api/home_state.dart';
import 'package:pill_city_flutter/src/utils/get_error_message.dart';
import 'package:pill_city_flutter/src/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HomeState>(context, listen: false).loadInitialPosts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeState>(builder: (context, home, child) {
      if (home.loadingInitialPosts) {
        return const Center(child: CircularProgressIndicator());
      } else if (home.initialPostsError != null) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(getErrorMessage(home.initialPostsError!) ??
                  AppLocalizations.of(context)!.unknown_error),
              ElevatedButton(
                  onPressed: () {
                    home.loadInitialPosts(context);
                  },
                  child: Text(AppLocalizations.of(context)!.retry))
            ]);
      } else {
        return ListView.builder(
            itemCount: home.posts.length + 1,
            itemBuilder: (context, index) {
              if (index < home.posts.length) {
                return Column(children: [
                  PostWidget(post: home.posts[index]),
                  const SizedBox(height: 16),
                  const Divider()
                ]);
              } else {
                if (home.morePostsError == null) {
                  if (!home.loadingMorePosts) {
                    home.loadMorePosts(context);
                  }
                  return const LinearProgressIndicator();
                } else {
                  return InkWell(
                    onTap: () {
                      home.loadMorePosts(context);
                    },
                    child: Column(
                      children: [
                        Text(getErrorMessage(home.morePostsError!) ??
                            AppLocalizations.of(context)!.unknown_error),
                        Text(AppLocalizations.of(context)!.retry)
                      ],
                    ),
                  );
                }
              }
            });
      }
    });
  }
}
