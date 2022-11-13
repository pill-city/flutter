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
      if (home.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (home.error != null) {
        return Center(
            child: Text(getErrorMessage(home.error!) ??
                AppLocalizations.of(context)!.unknown_error));
      } else {
        return ListView.builder(
            itemCount: home.posts.length,
            itemBuilder: (context, index) {
              return Column(children: [
                PostWidget(post: home.posts[index]),
                const SizedBox(height: 16),
                const Divider()
              ]);
            });
      }
    });
  }
}
