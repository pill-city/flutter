import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city_flutter/src/state/me_state.dart';
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
      _loadMe();
    });
  }

  Future<void> _loadMe() async {
    try {
      await Provider.of<MeState>(context, listen: false).loadMe(context);
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
        return Consumer<MeState>(builder: (context, me, child) {
          return CreatePostForm(me: me.me!);
        });
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
