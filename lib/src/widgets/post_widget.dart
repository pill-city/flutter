import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/get_media_url_v2_image.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/widgets/link_preview_widget.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
              backgroundImage: getMediaUrlV2Image(post.author.avatarUrlV2)),
          title: Text(getUserPrimaryName(post.author),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: getUserSecondaryName(post.author) != null
              ? Text(getUserSecondaryName(post.author)!,
                  maxLines: 1, overflow: TextOverflow.ellipsis)
              : null,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.content != null)
                  Text(post.content!,
                      maxLines: 20, overflow: TextOverflow.fade),
                if (post.linkPreviews != null && post.linkPreviews!.isNotEmpty)
                  Column(children: [
                    const SizedBox(height: 8),
                    LinkPreviewWidget(linkPreview: post.linkPreviews!.first)
                  ])
              ],
            ))
      ],
    );
  }
}
