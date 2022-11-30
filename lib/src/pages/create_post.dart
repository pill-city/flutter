import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/state/app_global_state.dart';
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
  User? _me;
  DioError? _error;

  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMe();
    });
  }

  Future<void> _loadMe() async {
    PillCity api = await Provider.of<AppGlobalState>(context, listen: false)
        .getAuthenticatedApi();
    try {
      final response = await api.getCoreApi().getMe();
      if (response.data == null) {
        throw Future.error("Failed to load post");
      }
      _me = response.data!;
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
    return LoadingAndRetryWidget(
      loading: _loading,
      error: _error,
      onRetry: () {
        setState(() {
          _loading = true;
          _error = null;
        });
        _loadMe();
      },
      builder: (BuildContext context) {
        return CreatePostForm(me: _me!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.new_post),
        ),
        body: _buildBody(context),
      ),
    );
  }
}
