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
    super.initState();
    // https://stackoverflow.com/questions/60734770/flutter-setstate-or-markneedsbuild-called-during-build-with-provider
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<HomeState>(context, listen: false)
            .loadInitialPosts(context);
      },
    );
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
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: PostWidget(post: home.posts[index]),
                  ),
                  const Divider(
                    thickness: 1,
                  )
                ]);
              } else {
                if (home.morePostsError == null) {
                  if (!home.loadingMorePosts) {
                    home.loadMorePosts(context);
                  }
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    children: [
                      Text(getErrorMessage(home.morePostsError!) ??
                          AppLocalizations.of(context)!.unknown_error),
                      ElevatedButton(
                          onPressed: () {
                            home.loadMorePosts(context);
                          },
                          child: Text(AppLocalizations.of(context)!.retry))
                    ],
                  );
                }
              }
            });
      }
    });
  }
}
