import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/state/app_global_state.dart';
import 'package:pill_city_flutter/src/state/me_state.dart';
import 'package:pill_city_flutter/src/utils/get_error_message.dart';
import 'package:pill_city_flutter/src/widgets/create_post_form.dart';
import 'package:pill_city_flutter/src/widgets/loading_and_retry_widget.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  bool _loading = true;
  DioError? _error;

  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMeAndMyCircles();
    });
  }

  Future<void> _loadMeAndMyCircles() async {
    try {
      await Provider.of<MeState>(context, listen: false).loadMe(context);
      if (!mounted) return;
      await Provider.of<MeState>(context, listen: false).loadMyCircles(context);
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

  showOkDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  showLoaderDialog(BuildContext context, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 32),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return LoadingAndRetryWidget(
      loading: _loading,
      error: _error,
      onRetry: () {
        setState(() {
          _loading = true;
          _error = null;
        });
        _loadMeAndMyCircles();
      },
      builder: (BuildContext context) {
        return Consumer<MeState>(
          builder: (context, me, child) {
            return CreatePostForm(
              me: me.me!,
              myCircles: me.circles!,
              onCreatePost: (CreatePostRequest request) async {
                showLoaderDialog(
                    context, AppLocalizations.of(context)!.posting);
                final appGlobalState =
                    Provider.of<AppGlobalState>(context, listen: false);
                final api = await appGlobalState.getAuthenticatedApi();
                try {
                  await api.getCoreApi().createPost(createPostRequest: request);
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } on DioError catch (error) {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  showOkDialog(
                    context,
                    AppLocalizations.of(context)!.error,
                    getErrorMessage(error),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppLocalizations.of(context)!.new_post),
      ),
      body: SafeArea(child: _buildBody(context)),
    );
  }
}
