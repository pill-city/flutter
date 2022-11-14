import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/format_duration.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';
import 'package:pill_city_flutter/src/widgets/link_preview_widget.dart';
import 'package:pill_city_flutter/src/widgets/post_media_collage.dart';

const subTextStyle = TextStyle(fontSize: 12, color: Colors.grey);

class PostWidget extends StatelessWidget {
  const PostWidget({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: post.author.avatarUrlV2 != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(
                      post.author.avatarUrlV2!.processed
                          ? post.author.avatarUrlV2!.processedUrl!
                          : post.author.avatarUrlV2!.originalUrl),
                  backgroundColor: post.author.avatarUrlV2!.processed
                      ? HexColor.fromHex(
                          post.author.avatarUrlV2!.dominantColorHex!)
                      : Colors.grey,
                )
              : CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text(post.author.id[0]),
                ),
          title: RichText(
            text: TextSpan(
              text: getUserPrimaryName(post.author),
              style: DefaultTextStyle.of(context).style,
              children: [
                if (getUserSecondaryName(post.author) != null)
                  TextSpan(
                    text: ' @${post.author.id}',
                    style: subTextStyle,
                  ),
              ],
            ),
          ),
          subtitle: Text(
            "▸ ${post.isPublic ? AppLocalizations.of(context)!.public : post.circles != null && post.circles!.isNotEmpty ? AppLocalizations.of(context)!.circles(post.circles!.length) : AppLocalizations.of(context)!.only_you} · ${formatDuration(post.createdAtSeconds)}",
            style: subTextStyle,
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.content != null)
                  Text(post.content!,
                      maxLines: 20, overflow: TextOverflow.fade),
                if (post.mediaUrlsV2 != null && post.mediaUrlsV2!.isNotEmpty)
                  Column(children: [
                    const SizedBox(height: 8),
                    PostMediaCollage(postMedia: post.mediaUrlsV2!)
                  ]),
                if (post.linkPreviews != null && post.linkPreviews!.isNotEmpty)
                  Column(children: [
                    const SizedBox(height: 8),
                    LinkPreviewWidget(linkPreview: post.linkPreviews!.first)
                  ]),
              ],
            ))
      ],
    );
  }
}
