import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/state/app_global_state.dart';
import 'package:pill_city_flutter/src/utils/get_error_message.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';
import 'package:pill_city_flutter/src/widgets/post_widget.dart';
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
  bool _isPublic = true;
  List<String> _circlesIds = ["fa", "fa2"];

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
                _loadMe();
              },
              child: Text(AppLocalizations.of(context)!.retry))
        ],
      );
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _me!.avatarUrlV2 != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            _me!.avatarUrlV2!.processed
                                ? _me!.avatarUrlV2!.processedUrl!
                                : _me!.avatarUrlV2!.originalUrl,
                          ),
                          backgroundColor: _me!.avatarUrlV2!.processed
                              ? HexColor.fromHex(
                                  _me!.avatarUrlV2!.dominantColorHex!,
                                )
                              : Colors.grey,
                        )
                      : const CircleAvatar(
                          backgroundColor: Colors.grey,
                        ),
                  const SizedBox(width: 16),
                  Text.rich(
                    TextSpan(
                      text: getPrimaryName(_me!),
                      children: [
                        if (getSecondaryName(_me!) != null)
                          TextSpan(
                            text: ' @${_me!.id}',
                            style: subTextStyle,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.say_something,
                ),
                maxLines: 10,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.public_post),
                  const SizedBox(width: 4),
                  Switch(
                    value: _isPublic,
                    onChanged: (bool value) {
                      setState(() {
                        _isPublic = value;
                      });
                    },
                  ),
                ],
              )
            ],
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
          title: Text(AppLocalizations.of(context)!.new_post),
        ),
        body: _buildBody(context),
      ),
    );
  }
}
