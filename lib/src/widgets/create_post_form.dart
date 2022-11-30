import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';
import 'package:pill_city_flutter/src/widgets/post_widget.dart';

class CreatePostForm extends StatefulWidget {
  const CreatePostForm({super.key, required this.me});

  final User me;

  @override
  State<CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  final TextEditingController contentController = TextEditingController();
  bool _isPublic = true;

  @override
  Widget build(BuildContext context) {
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
                  value: _isPublic,
                  onChanged: (bool value) {
                    setState(() {
                      _isPublic = value;
                    });
                  },
                ),
                const SizedBox(width: 4),
                Text(AppLocalizations.of(context)!.public_post),
              ],
            )
          ],
        ),
      ),
    );
  }
}
