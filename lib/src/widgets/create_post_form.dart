import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';
import 'package:pill_city_flutter/src/widgets/post_widget.dart';

typedef CreatePostCallback = void Function(CreatePostRequest);

class CreatePostForm extends StatefulWidget {
  const CreatePostForm({
    super.key,
    required this.me,
    required this.myCircles,
    required this.onCreatePost,
  });

  final User me;
  final BuiltList<Circle> myCircles;
  final CreatePostCallback onCreatePost;

  @override
  State<CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  final TextEditingController contentController = TextEditingController();
  bool _isPublic = true;
  bool _isReshareable = true;
  List<String> _circlesSelected = [];

  bool _isValidated() {
    if (contentController.text.isEmpty) {
      return false;
    }
    if (_isPublic) {
      return true;
    }
    return _circlesSelected.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    int circlesTotalUsers = 0;
    for (var circleId in _circlesSelected) {
      circlesTotalUsers += widget.myCircles
          .where((c) => c.id == circleId)
          .toList()
          .first
          .members
          .length;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                widget.me.avatarUrlV2 != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                          widget.me.avatarUrlV2!.processed
                              ? widget.me.avatarUrlV2!.processedUrl!
                              : widget.me.avatarUrlV2!.originalUrl,
                        ),
                        backgroundColor: widget.me.avatarUrlV2!.processed
                            ? HexColor.fromHex(
                                widget.me.avatarUrlV2!.dominantColorHex!,
                              )
                            : Colors.grey,
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.grey,
                      ),
                const SizedBox(width: 16),
                Text.rich(
                  TextSpan(
                    text: getPrimaryName(widget.me),
                    children: [
                      if (getSecondaryName(widget.me) != null)
                        TextSpan(
                          text: ' @${widget.me.id}',
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
                Switch(
                  activeColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.redAccent
                      : Colors.deepOrangeAccent,
                  value: _isPublic,
                  onChanged: (bool checked) {
                    setState(
                      () {
                        _isPublic = checked;
                        if (checked) {
                          _circlesSelected = [];
                        }
                      },
                    );
                  },
                ),
                const SizedBox(width: 4),
                Text(AppLocalizations.of(context)!.public_post),
                Switch(
                  activeColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.redAccent
                      : Colors.deepOrangeAccent,
                  value: _isReshareable,
                  onChanged: (bool checked) {
                    setState(
                      () {
                        _isReshareable = checked;
                      },
                    );
                  },
                ),
                const SizedBox(width: 4),
                Text(AppLocalizations.of(context)!.reshareable_post),
              ],
            ),
            if (!_isPublic)
              Column(
                children: [
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (final Circle circle in widget.myCircles)
                        FilterChip(
                          label: Text.rich(
                            TextSpan(
                              children: [
                                const WidgetSpan(
                                  child: Icon(
                                    size: 16,
                                    Icons.people,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(width: 4),
                                ),
                                TextSpan(
                                  text:
                                      "${getCircleName(circle.name)} (${circle.members.length})",
                                ),
                              ],
                            ),
                          ),
                          selected: _circlesSelected.contains(circle.id),
                          onSelected: (bool checked) {
                            setState(
                              () {
                                if (checked &&
                                    !_circlesSelected.contains(circle.id)) {
                                  _circlesSelected.add(circle.id);
                                } else if (!checked &&
                                    _circlesSelected.contains(circle.id)) {
                                  _circlesSelected.remove(circle.id);
                                }
                              },
                            );
                          },
                        ),
                    ],
                  )
                ],
              ),
            const SizedBox(height: 8),
            FractionallySizedBox(
              widthFactor: 0.6,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  if (_isValidated()) {
                    var builder = CreatePostRequestBuilder();
                    builder.content = contentController.text;
                    builder.isPublic = _isPublic;
                    builder.reshareable = _isReshareable;
                    if (_circlesSelected.isNotEmpty) {
                      ListBuilder<String> lb = ListBuilder<String>();
                      for (var circleId in _circlesSelected) {
                        lb.add(circleId);
                      }
                      builder.circleIds = lb;
                    }

                    widget.onCreatePost(builder.build());
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.error),
                          content: Text(AppLocalizations.of(context)!
                              .invalid_create_post_input),
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
                },
                child: Text(
                  _isPublic
                      ? AppLocalizations.of(context)!.post_to_public
                      : "${AppLocalizations.of(context)!.post_to_circles(_circlesSelected.length)} ($circlesTotalUsers)",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
