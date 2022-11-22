import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';

const commentMaxLines = 1;

class CommentsWidget extends StatelessWidget {
  const CommentsWidget({Key? key, required this.comments}) : super(key: key);

  final BuiltList<Comment> comments;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: comments.map(
        (c) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: c.author.avatarUrlV2 != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                              c.author.avatarUrlV2!.processed
                                  ? c.author.avatarUrlV2!.processedUrl!
                                  : c.author.avatarUrlV2!.originalUrl,
                            ),
                            backgroundColor: c.author.avatarUrlV2!.processed
                                ? HexColor.fromHex(
                                    c.author.avatarUrlV2!.dominantColorHex!)
                                : Colors.grey,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Text(c.author.id[0]),
                          ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${getInferredFirstName(c.author)}${c.content != null ? ': ${c.content!}' : ''}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: commentMaxLines,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (c.comments != null && c.comments!.isNotEmpty)
                for (var nc in c.comments!)
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: nc.author.avatarUrlV2 != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        nc.author.avatarUrlV2!.processed
                                            ? nc.author.avatarUrlV2!
                                                .processedUrl!
                                            : nc.author.avatarUrlV2!
                                                .originalUrl,
                                      ),
                                      backgroundColor:
                                          nc.author.avatarUrlV2!.processed
                                              ? HexColor.fromHex(nc
                                                  .author
                                                  .avatarUrlV2!
                                                  .dominantColorHex!)
                                              : Colors.grey,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: Text(nc.author.id[0]),
                                    ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "${getInferredFirstName(nc.author)}${nc.content != null ? ': ${nc.content!}' : ''}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: commentMaxLines,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
            ],
          );
        },
      ).toList(),
    );
  }
}
