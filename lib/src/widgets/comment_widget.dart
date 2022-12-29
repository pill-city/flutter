import 'package:built_collection/built_collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/get_formatted_content_text_spans.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';
import 'package:pill_city_flutter/src/widgets/media_collage.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    Key? key,
    required this.author,
    this.formattedContent,
    this.media,
    this.deleted,
    this.blocked,
    required this.maxLines,
    required this.showMedia,
    this.replyToCommentId,
    required this.enableActions,
    required this.isHighlighted,
    required this.onHighlightComment,
  }) : super(key: key);

  final User author;
  final FormattedContent? formattedContent;
  final BuiltList<MediaUrlV2>? media;
  final bool? deleted;
  final bool? blocked;
  final int maxLines;
  final bool showMedia;
  final String? replyToCommentId;
  final bool enableActions;
  final bool isHighlighted;
  final void Function(String commentId) onHighlightComment;

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];
    spans.add(
      WidgetSpan(
        child: SizedBox(
          height: 18,
          width: 18,
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
        TextSpan(
          text: getInferredFirstName(author),
        ),
      );
      spans.add(
        const TextSpan(text: ": "),
      );
    }
    if (!enableActions &&
        replyToCommentId != null &&
        replyToCommentId!.isNotEmpty) {
      spans.add(
        const WidgetSpan(
          child: Icon(
            size: 18,
            Icons.forum,
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
        if (showMedia) {
          spans.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: MediaCollage(
                  mediaList: media!,
                ),
              ),
            ),
          );
        } else {
          spans.add(
            const WidgetSpan(
              child: Icon(
                size: 18,
                Icons.image,
              ),
            ),
          );
        }
      }
      if (formattedContent != null) {
        spans.addAll(
          getFormattedContentTextSpans(
            formattedContent!,
            context,
          ),
        );
      }
    }
    if (enableActions) {
      spans.add(
        const WidgetSpan(
          child: SizedBox(
            width: 4,
          ),
        ),
      );
      spans.add(
        TextSpan(
          text: AppLocalizations.of(context)!.reply,
          style: const TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
      );
      if (replyToCommentId != null && replyToCommentId!.isNotEmpty) {
        spans.add(
          const WidgetSpan(
            child: SizedBox(
              width: 4,
            ),
          ),
        );
        spans.add(
          TextSpan(
            text: AppLocalizations.of(context)!.highlight_replying,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                onHighlightComment(replyToCommentId!);
              },
          ),
        );
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(color: isHighlighted ? Colors.grey : null),
        child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 2),
          child: Text.rich(
            TextSpan(
              children: spans,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
