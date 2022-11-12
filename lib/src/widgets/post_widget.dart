import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/get_media_url_v2_image.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';

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
          title: Text(getUserPrimaryName(post.author)),
          subtitle: getUserSecondaryName(post.author) != null
              ? Text(getUserSecondaryName(post.author)!)
              : null,
        ),
        if (post.content != null)
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(post.content!)),
      ],
    );
  }
}
