import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/widgets/comment_widget.dart';

const commentMaxLines = 1;

class CommentsWidget extends StatelessWidget {
  const CommentsWidget({Key? key, required this.comments}) : super(key: key);

  final BuiltList<Comment> comments;

  @override
  Widget build(BuildContext context) {
    List<Widget> commentWidgets = [];

    for (var i = 0; i < comments.length; i++) {
      var comment = comments[i];
      commentWidgets.add(
        CommentWidget(
          author: comment.author,
          content: comment.content,
        ),
      );
      if (comment.comments != null && comment.comments!.isNotEmpty) {
        for (var j = 0; j < comment.comments!.length; j++) {
          var nestedComment = comment.comments![j];
          commentWidgets.add(
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: CommentWidget(
                author: nestedComment.author,
                content: nestedComment.content,
              ),
            ),
          );
        }
      }
    }

    List<Widget> children = [];
    for (var i = 0; i < commentWidgets.length; i++) {
      children.add(commentWidgets[i]);
      if (i < commentWidgets.length - 1) {
        children.add(const SizedBox(height: 4));
      }
    }

    return Column(children: children);
  }
}
