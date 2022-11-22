import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/format_duration.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';
import 'package:pill_city_flutter/src/widgets/media_collage.dart';
import 'package:pill_city_flutter/src/widgets/reactions_widget.dart';
import 'package:pill_city_flutter/src/widgets/show_more_link_previews_widget.dart';

import 'link_previews_widget.dart';

const contentMaxLines = 20;

const subTextStyle = TextStyle(fontSize: 12, color: Colors.grey);

class PostWidget extends StatelessWidget {
  const PostWidget({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    bool hasMedia = post.mediaUrlsV2 != null && post.mediaUrlsV2!.isNotEmpty;
    bool hasLinkPreview =
        post.linkPreviews != null && post.linkPreviews!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    post.author.avatarUrlV2 != null
                        ? CircleAvatar(
                            backgroundImage: Image.network(
                              post.author.avatarUrlV2!.processed
                                  ? post.author.avatarUrlV2!.processedUrl!
                                  : post.author.avatarUrlV2!.originalUrl,
                            ).image,
                            backgroundColor: post.author.avatarUrlV2!.processed
                                ? HexColor.fromHex(
                                    post.author.avatarUrlV2!.dominantColorHex!)
                                : Colors.grey,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Text(post.author.id[0]),
                          ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: getPrimaryName(post.author),
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              if (getSecondaryName(post.author) != null)
                                TextSpan(
                                  text: ' @${post.author.id}',
                                  style: subTextStyle,
                                ),
                            ],
                          ),
                        ),
                        Text(
                          "▸ ${post.isPublic ? AppLocalizations.of(context)!.public : post.circles != null && post.circles!.isNotEmpty ? AppLocalizations.of(context)!.circles(post.circles!.length) : AppLocalizations.of(context)!.only_you} · ${formatDuration(post.createdAtSeconds)}",
                          style: subTextStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (post.content != null)
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      Text(post.content!,
                          maxLines: contentMaxLines,
                          overflow: TextOverflow.fade),
                    ],
                  ),
                const SizedBox(height: 8),
                if (hasMedia)
                  Column(children: [
                    const SizedBox(height: 8),
                    MediaCollage(mediaList: post.mediaUrlsV2!)
                  ]),
                if (hasLinkPreview)
                  hasMedia
                      ? Column(children: [
                          const SizedBox(height: 8),
                          ShowMoreLinkPreviewsWidget(
                            linkPreviews: post.linkPreviews!,
                          )
                        ])
                      : Column(children: [
                          const SizedBox(height: 8),
                          LinkPreviewsWidget(linkPreviews: post.linkPreviews!)
                        ]),
                const SizedBox(height: 8),
                if (post.reactions != null && post.reactions!.isNotEmpty)
                  Column(children: [
                    const SizedBox(height: 8),
                    ReactionsWidget(reactions: post.reactions!)
                  ]),
              ],
            ))
      ],
    );
  }
}
