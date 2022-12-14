import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/format_duration.dart';
import 'package:pill_city_flutter/src/utils/get_formatted_content_text_spans.dart';
import 'package:pill_city_flutter/src/utils/get_twemoji_text_spans.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/utils/hex_color.dart';
import 'package:pill_city_flutter/src/widgets/comments_widget.dart';
import 'package:pill_city_flutter/src/widgets/reactions_widget.dart';
import 'package:pill_city_flutter/src/widgets/show_more_link_previews_widget.dart';

import 'link_previews_widget.dart';
import 'media_collage.dart';

const mainTextStyle = TextStyle(fontSize: 16);
const subTextStyle = TextStyle(fontSize: 12, color: Colors.grey);

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.post,
    required this.contentMaxLines,
    required this.maxLinkPreviews,
    required this.fullReactionMaxUsers,
    required this.commentMaxLines,
    required this.maxComments,
    required this.maxNestedComments,
    required this.showCommentMedia,
    required this.enableCommentActions,
  });

  final Post post;
  final int contentMaxLines;
  final int maxLinkPreviews;
  final int fullReactionMaxUsers;
  final int commentMaxLines;
  final int maxComments;
  final int maxNestedComments;
  final bool showCommentMedia;
  final bool enableCommentActions;

  @override
  Widget build(BuildContext context) {
    bool blocked = post.state == PostStateEnum.authorBlocked;
    bool deleted = post.state == PostStateEnum.deleted;
    bool hasMedia = post.mediaUrlsV2 != null && post.mediaUrlsV2!.isNotEmpty;
    bool hasLinkPreview =
        post.linkPreviews != null && post.linkPreviews!.isNotEmpty;

    List<Widget> widgets = [];

    widgets.add(
      Row(
        children: [
          post.author.avatarUrlV2 != null && !blocked
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
                  children: getTwemojiTextSpans(
                          !blocked
                              ? getPrimaryName(post.author)
                              : AppLocalizations.of(context)!.blocked_user,
                          context,
                          additionalStyle: mainTextStyle) +
                      [
                        if (getSecondaryName(post.author) != null)
                          TextSpan(
                            text: ' @${post.author.id}',
                            style: subTextStyle,
                          ),
                      ],
                ),
              ),
              Text(
                "??? ${post.isPublic ? AppLocalizations.of(context)!.public : post.circles != null && post.circles!.isNotEmpty ? AppLocalizations.of(context)!.circles(post.circles!.length) : AppLocalizations.of(context)!.only_you} ?? ${formatDuration(post.createdAtSeconds)}",
                style: subTextStyle,
              ),
            ],
          ),
        ],
      ),
    );

    if (blocked) {
      widgets.add(
        Text(
          AppLocalizations.of(context)!.post_author_blocked,
          maxLines: contentMaxLines,
          overflow: TextOverflow.fade,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    } else if (deleted) {
      widgets.add(
        Text(
          AppLocalizations.of(context)!.post_deleted,
          maxLines: contentMaxLines,
          overflow: TextOverflow.fade,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    } else if (post.isUpdateAvatar != null && post.isUpdateAvatar!) {
      widgets.add(
        RichText(
          text: TextSpan(
            children: getTwemojiTextSpans(
              "${getPrimaryName(post.author)} ${AppLocalizations.of(context)!.has_a_new_avatar}",
              context,
              additionalStyle: const TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          maxLines: contentMaxLines,
          overflow: TextOverflow.fade,
        ),
      );
    } else if (post.formattedContent != null) {
      widgets.add(
        RichText(
          text: TextSpan(
            children: getFormattedContentTextSpans(
              post.formattedContent!,
              context,
            ),
          ),
          maxLines: contentMaxLines,
          overflow: TextOverflow.fade,
        ),
      );
    }

    if (!blocked && !deleted) {
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
              maxLinkPreviews: maxLinkPreviews,
            ),
          );
        }
      }
    }

    widgets.add(
      ReactionsWidget(
        reactions: post.reactions,
        fullReactionMaxUsers: fullReactionMaxUsers,
        postId: post.id,
      ),
    );

    if (post.comments != null && post.comments!.isNotEmpty) {
      widgets.add(
        CommentsWidget(
          enabledActions: enableCommentActions,
          comments: post.comments!,
          commentMaxLines: commentMaxLines,
          maxComments: maxComments,
          maxNestedComments: maxNestedComments,
          showMedia: showCommentMedia,
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
