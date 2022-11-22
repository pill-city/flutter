import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';

const commentMaxLines = 1;

class CommentWidget extends StatelessWidget {
  CommentWidget({Key? key, required this.author, this.content})
      : super(key: key);

  final User author;
  String? content;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
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
              : CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text(author.id[0]),
                ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "${getInferredFirstName(author)}${content != null ? ': ${content!}' : ''}",
            overflow: TextOverflow.ellipsis,
            maxLines: commentMaxLines,
          ),
        ),
      ],
    );
  }
}
