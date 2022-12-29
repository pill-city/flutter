import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/widgets/comment_widget.dart';

class CommentsWidget extends StatefulWidget {
  const CommentsWidget({
    super.key,
    required this.enabledActions,
    required this.comments,
    required this.commentMaxLines,
    required this.maxComments,
    required this.maxNestedComments,
    required this.showMedia,
  });

  final bool enabledActions;
  final BuiltList<Comment> comments;
  final int commentMaxLines;
  final int maxComments;
  final int maxNestedComments;
  final bool showMedia;

  @override
  CommentsWidgetState createState() {
    return CommentsWidgetState();
  }
}

class CommentsWidgetState extends State<CommentsWidget> {
  String? highlightedCommentId;

  @override
  Widget build(BuildContext context) {
    List<Comment> visibleComments = widget.comments
        .where(
          (c) => c.state != CommentStateEnum.invisible,
        )
        .toList();

    List<Widget> commentWidgets = [];

    int totalComments = visibleComments.length +
        visibleComments.map(
          (comment) {
            if (comment.comments != null) {
              return comment.comments!
                  .where((c) => c.state != NestedCommentStateEnum.invisible)
                  .length;
            }
            return 0;
          },
        ).reduce((a, b) => a + b);
    int displayedComments = 0;
    for (var i = 0; i < min(visibleComments.length, widget.maxComments); i++) {
      var comment = visibleComments[i];
      commentWidgets.add(
        CommentWidget(
          enableActions: widget.enabledActions,
          author: comment.author,
          formattedContent: comment.formattedContent,
          media: comment.mediaUrlsV2,
          deleted: comment.state == CommentStateEnum.deleted,
          blocked: comment.state == CommentStateEnum.authorBlocked,
          maxLines: widget.commentMaxLines,
          showMedia: widget.showMedia,
          isHighlighted: highlightedCommentId == comment.id,
          onHighlightComment: (commentId) {
            setState(() {
              highlightedCommentId = commentId;
            });
          },
        ),
      );
      displayedComments++;
      if (comment.comments != null) {
        List<NestedComment> visibleNestedComments = comment.comments!
            .where((c) => c.state != NestedCommentStateEnum.invisible)
            .toList();
        for (var j = 0;
            j < min(visibleNestedComments.length, widget.maxNestedComments);
            j++) {
          var nestedComment = visibleNestedComments[j];
          commentWidgets.add(
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: CommentWidget(
                enableActions: widget.enabledActions,
                author: nestedComment.author,
                formattedContent: nestedComment.formattedContent,
                media: nestedComment.mediaUrlsV2,
                deleted: nestedComment.state == NestedCommentStateEnum.deleted,
                blocked:
                    nestedComment.state == NestedCommentStateEnum.authorBlocked,
                maxLines: widget.commentMaxLines,
                showMedia: widget.showMedia,
                replyToCommentId: nestedComment.replyToCommentId,
                isHighlighted: highlightedCommentId == nestedComment.id,
                onHighlightComment: (commentId) {
                  setState(() {
                    highlightedCommentId = commentId;
                  });
                },
              ),
            ),
          );
          displayedComments++;
        }
      }
    }
    int hiddenComments = totalComments - displayedComments;

    if (hiddenComments != 0) {
      commentWidgets.add(
        Text(
          AppLocalizations.of(context)!.and_more_comments(hiddenComments),
          style: const TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.underline,
          ),
        ),
      );
    }

    List<Widget> children = [];
    for (var i = 0; i < commentWidgets.length; i++) {
      children.add(commentWidgets[i]);
      if (i < commentWidgets.length - 1) {
        children.add(const SizedBox(height: 8));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
