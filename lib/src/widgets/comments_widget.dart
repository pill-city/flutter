import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/widgets/comment_widget.dart';

class CommentsWidget extends StatelessWidget {
  const CommentsWidget({
    Key? key,
    required this.comments,
    required this.commentMaxLines,
    required this.maxComments,
    required this.maxNestedComments,
    required this.showMedia,
  }) : super(key: key);

  final BuiltList<Comment> comments;
  final int commentMaxLines;
  final int maxComments;
  final int maxNestedComments;
  final bool showMedia;

  bool _shouldShowComment(Comment comment) {
    return !(comment.deleted != null && comment.deleted!) ||
        !(comment.blocked != null && comment.blocked!) ||
        !(comment.comments != null &&
            comment.comments!.where((nestedComment) {
              return _shouldShowNestedComment(nestedComment, comment);
            }).isNotEmpty);
  }

  bool _isNestedCommentRepliedTo(NestedComment nestedComment, Comment comment) {
    for (var otherComment in comment.comments!) {
      if (otherComment.replyToCommentId == nestedComment.id) {
        return true;
      }
    }
    return false;
  }

  bool _shouldShowNestedComment(NestedComment nestedComment, Comment comment) {
    return !(nestedComment.deleted != null && nestedComment.deleted!) ||
        !(nestedComment.blocked != null && nestedComment.blocked!) ||
        _isNestedCommentRepliedTo(nestedComment, comment);
  }

  @override
  Widget build(BuildContext context) {
    List<Comment> showingComments = comments.where(_shouldShowComment).toList();

    List<Widget> commentWidgets = [];

    int totalComments = showingComments.length +
        showingComments.map((comment) {
          if (comment.comments != null) {
            return comment.comments!.where((nestedComment) {
              return _shouldShowNestedComment(nestedComment, comment);
            }).length;
          }
          return 0;
        }).reduce((a, b) => a + b);
    int displayedComments = 0;
    for (var i = 0; i < min(showingComments.length, maxComments); i++) {
      var comment = showingComments[i];
      commentWidgets.add(
        CommentWidget(
          author: comment.author,
          content: comment.content,
          media: comment.mediaUrlsV2,
          deleted: comment.deleted,
          blocked: comment.blocked,
          maxLines: commentMaxLines,
          showMedia: showMedia,
        ),
      );
      displayedComments++;
      if (comment.comments != null) {
        List<NestedComment> showingNestedComments =
            comment.comments!.where((nestedComment) {
          return _shouldShowNestedComment(nestedComment, comment);
        }).toList();
        for (var j = 0;
            j < min(showingNestedComments.length, maxNestedComments);
            j++) {
          var nestedComment = showingNestedComments[j];
          commentWidgets.add(
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: CommentWidget(
                author: nestedComment.author,
                content: nestedComment.content,
                media: nestedComment.mediaUrlsV2,
                deleted: comment.deleted,
                blocked: comment.blocked,
                maxLines: commentMaxLines,
                showMedia: showMedia,
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
