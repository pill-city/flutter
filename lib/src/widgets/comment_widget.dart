import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';

import '../utils/get_user_names.dart';

const commentMaxLines = 1;

class CommentWidget extends StatelessWidget {
  CommentWidget({Key? key, required this.author, this.content, this.media})
      : super(key: key);

  final User author;
  String? content;
  BuiltList<MediaUrlV2>? media;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(
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
            : const CircleAvatar(
                backgroundColor: Colors.grey,
              ),
      ),
    );
    widgets.add(
      Text(
        getInferredFirstName(author),
      ),
    );
    if (content != null && content!.isNotEmpty) {
      widgets.add(
        Expanded(
          child: Text(
            content!,
            overflow: TextOverflow.ellipsis,
            maxLines: commentMaxLines,
          ),
        ),
      );
    }
    if (media != null && media!.isNotEmpty) {
      widgets.add(
        const SizedBox(
          child: Icon(
            Icons.image,
          ),
        ),
      );
    }

    List<Widget> children = [];
    for (var i = 0; i < widgets.length; i++) {
      children.add(widgets[i]);
      if (i < widgets.length - 1) {
        children.add(
          const SizedBox(width: 4),
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
