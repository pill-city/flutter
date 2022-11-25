import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';

import '../utils/get_user_names.dart';

const commentMaxLines = 1;

class CommentWidget extends StatelessWidget {
  const CommentWidget(
      {Key? key,
      required this.author,
      this.content,
      this.media,
      this.deleted,
      this.blocked})
      : super(key: key);

  final User author;
  final String? content;
  final BuiltList<MediaUrlV2>? media;
  final bool? deleted;
  final bool? blocked;

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];
    spans.add(
      WidgetSpan(
        child: SizedBox(
          height: 16,
          width: 16,
          child: author.avatarUrlV2 != null && !(blocked ?? false)
              ? CircleAvatar(
                  backgroundImage: NetworkImage(
                    author.avatarUrlV2!.processed
                        ? author.avatarUrlV2!.processedUrl!
                        : author.avatarUrlV2!.originalUrl,
                  ),
                  backgroundColor: author.avatarUrlV2!.processed
                      ? HexColor.fromHex(author.avatarUrlV2!.dominantColorHex!)
                      : Colors.grey,
                )
              : const CircleAvatar(
                  backgroundColor: Colors.grey,
                ),
        ),
      ),
    );
    spans.add(
      const WidgetSpan(
        child: SizedBox(
          width: 4,
        ),
      ),
    );
    if (!(blocked ?? false) && !(deleted ?? false)) {
      spans.add(
        TextSpan(text: getInferredFirstName(author)),
      );
      spans.add(
        const TextSpan(text: ": "),
      );
    }
    if (blocked ?? false) {
      spans.add(
        TextSpan(
          text: AppLocalizations.of(context)!.comment_author_blocked,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    } else if (deleted ?? false) {
      spans.add(
        TextSpan(
          text: AppLocalizations.of(context)!.comment_deleted,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    } else {
      if (media != null && media!.isNotEmpty) {
        spans.add(
          const WidgetSpan(
            child: Icon(
              size: 16,
              Icons.image,
            ),
          ),
        );
      }
      if (content != null && content!.isNotEmpty) {
        spans.add(
          TextSpan(text: content!),
        );
      }
    }

    return Text.rich(
      TextSpan(
        children: spans,
      ),
      maxLines: commentMaxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
