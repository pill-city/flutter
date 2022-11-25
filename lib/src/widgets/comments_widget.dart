import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/widgets/comment_widget.dart';

const commentMaxLines = 1;
const maxComments = 3;
const maxNestedComments = 6;

class CommentsWidget extends StatelessWidget {
  const CommentsWidget({Key? key, required this.comments}) : super(key: key);

  final BuiltList<Comment> comments;

  @override
  Widget build(BuildContext context) {
    List<Widget> commentWidgets = [];

    int totalComments = comments.length +
        comments.map((comment) {
          if (comment.comments != null) {
            return comment.comments!.length;
          }
          return 0;
        }).reduce((a, b) => a + b);
    int displayedComments = 0;
    for (var i = 0; i < min(comments.length, maxComments); i++) {
      var comment = comments[i];
      commentWidgets.add(
        CommentWidget(
          author: comment.author,
          content: comment.content,
          media: comment.mediaUrlsV2,
        ),
      );
      displayedComments++;
      if (comment.comments != null && comment.comments!.isNotEmpty) {
        for (var j = 0;
            j < min(comment.comments!.length, maxNestedComments);
            j++) {
          var nestedComment = comment.comments![j];
          commentWidgets.add(
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: CommentWidget(
                author: nestedComment.author,
                content: nestedComment.content,
                media: nestedComment.mediaUrlsV2,
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
