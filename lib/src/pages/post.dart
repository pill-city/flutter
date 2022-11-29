import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/state/app_global_state.dart';
import 'package:pill_city_flutter/src/utils/get_error_message.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.postId});

  final String postId;

  @override
  State<PostPage> createState() => PostPageState();
}

class PostPageState extends State<PostPage> {
  bool _loading = true;
  Post? _post;
  DioError? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPost();
    });
    _loadPost();
  }

  Future<void> _loadPost() async {
    PillCity api = await Provider.of<AppGlobalState>(context, listen: false)
        .getAuthenticatedApi();
    try {
      final response = await api.getCoreApi().getPost(postId: widget.postId);
      if (response.data == null) {
        throw Future.error("Failed to load post");
      }
      _post = response.data!;
    } on DioError catch (errorCaught) {
      setState(() {
        _error = errorCaught;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(getErrorMessage(_error!)),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _loading = true;
                    _error = null;
                  });
                  _loadPost();
                },
                child: Text(AppLocalizations.of(context)!.retry))
          ]);
    } else {
      return RefreshIndicator(
        onRefresh: _loadPost,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.only(top: 16),
            height: MediaQuery.of(context).size.height,
            child: PostWidget(post: _post!),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_loading
              ? AppLocalizations.of(context)!.loading_post
              : getInferredFirstName(_post!.author) +
                  AppLocalizations.of(context)!.someone_s_post),
        ),
        body: _buildBody(context),
      ),
    );
  }
}
