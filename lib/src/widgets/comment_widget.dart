import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';

import '../utils/get_user_names.dart';

const commentMaxLines = 1;

class CommentWidget extends StatelessWidget {
  const CommentWidget(
      {Key? key, required this.author, this.content, this.media})
      : super(key: key);

  final User author;
  final String? content;
  final BuiltList<MediaUrlV2>? media;

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];
    spans.add(
      WidgetSpan(
        child: SizedBox(
          height: 16,
          width: 16,
          child: author.avatarUrlV2 != null
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
    spans.add(
      TextSpan(
        text: getInferredFirstName(author),
      ),
    );
    spans.add(
      const TextSpan(text: ": "),
    );
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

    return RichText(
      text: TextSpan(
        children: spans,
      ),
      maxLines: commentMaxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
