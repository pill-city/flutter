import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/format_duration.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';
import 'package:pill_city_flutter/src/widgets/comments_widget.dart';
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

    List<Widget> widgets = [];

    widgets.add(
      Row(
        children: [
          post.author.avatarUrlV2 != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(
                    post.author.avatarUrlV2!.processed
                        ? post.author.avatarUrlV2!.processedUrl!
                        : post.author.avatarUrlV2!.originalUrl,
                  ),
                  backgroundColor: post.author.avatarUrlV2!.processed
                      ? HexColor.fromHex(
                          post.author.avatarUrlV2!.dominantColorHex!,
                        )
                      : Colors.grey,
                )
              : const CircleAvatar(
                  backgroundColor: Colors.grey,
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
    );

    if (post.deleted != null && post.deleted!) {
      widgets.add(
        GestureDetector(
          onTap: () {
            GoRouter.of(context).push("/post/${post.id}");
          },
          child: Text(
            AppLocalizations.of(context)!.post_deleted,
            maxLines: contentMaxLines,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    } else if (post.blocked != null && post.blocked!) {
      widgets.add(
        GestureDetector(
          onTap: () {
            GoRouter.of(context).push("/post/${post.id}");
          },
          child: Text(
            AppLocalizations.of(context)!.author_blocked,
            maxLines: contentMaxLines,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    } else if (post.isUpdateAvatar != null && post.isUpdateAvatar!) {
      widgets.add(
        GestureDetector(
          onTap: () {
            GoRouter.of(context).push("/post/${post.id}");
          },
          child: Text(
            "${getInferredFirstName(post.author)} ${AppLocalizations.of(context)!.has_a_new_avatar}",
            maxLines: contentMaxLines,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    } else if (post.content != null && post.content!.isNotEmpty) {
      widgets.add(
        GestureDetector(
          onTap: () {
            GoRouter.of(context).push("/post/${post.id}");
          },
          child: Text(
            post.content!,
            maxLines: contentMaxLines,
            overflow: TextOverflow.fade,
          ),
        ),
      );
    }

    if (hasMedia) {
      widgets.add(
        MediaCollage(mediaList: post.mediaUrlsV2!),
      );
    }

    if (hasLinkPreview) {
      if (hasMedia) {
        widgets.add(ShowMoreLinkPreviewsWidget(
          linkPreviews: post.linkPreviews!,
        ));
      } else {
        widgets.add(
          LinkPreviewsWidget(
            linkPreviews: post.linkPreviews!,
          ),
        );
      }
    }

    if (post.reactions != null && post.reactions!.isNotEmpty) {
      widgets.add(
        ReactionsWidget(
          reactions: post.reactions!,
        ),
      );
    }

    if (post.comments != null && post.comments!.isNotEmpty) {
      widgets.add(
        GestureDetector(
          onTap: () {
            GoRouter.of(context).push("/post/${post.id}");
          },
          child: CommentsWidget(
            comments: post.comments!,
          ),
        ),
      );
    }

    List<Widget> children = [];
    for (var i = 0; i < widgets.length; i++) {
      children.add(widgets[i]);
      if (i < widgets.length - 1) {
        children.add(const SizedBox(height: 16));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}
