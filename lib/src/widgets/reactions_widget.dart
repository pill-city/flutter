import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:twemoji/twemoji.dart';

class RenderedReaction {
  final String emoji;
  final List<User> users;

  RenderedReaction(this.emoji, this.users);
}

class ReactionWidget extends StatelessWidget {
  const ReactionWidget({Key? key, required this.reaction}) : super(key: key);

  final RenderedReaction reaction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: reaction.users.length.toString().length == 1
          ? 48
          : reaction.users.length.toString().length == 2
              ? 64
              : 80,
      height: 32,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[200]
              : Colors.grey[800],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Twemoji(
                emoji: reaction.emoji,
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 8),
              Text(
                reaction.users.length.toString().length < 3
                    ? reaction.users.length.toString()
                    : '99+',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReactionsWidget extends StatelessWidget {
  const ReactionsWidget({Key? key, required this.reactions}) : super(key: key);

  final BuiltList<Reaction> reactions;

  @override
  Widget build(BuildContext context) {
    Map<String, List<User>> usersByEmoji = {};
    for (final reaction in reactions) {
      usersByEmoji[reaction.emoji] =
          (usersByEmoji[reaction.emoji] ?? []) + [reaction.author];
    }
    List<RenderedReaction> renderedReactions = usersByEmoji.entries
        .map((e) => RenderedReaction(e.key, e.value))
        .toList();
    renderedReactions.sort((a, b) {
      if (a.users.length != b.users.length) {
        return b.users.length - a.users.length;
      }
      return b.emoji.codeUnitAt(0) - a.emoji.codeUnitAt(0);
    });

    return Row(
      children: [
        for (final reaction in renderedReactions)
          Row(
            children: [
              ReactionWidget(reaction: reaction),
              const SizedBox(width: 8),
            ],
          )
      ],
    );
  }
}
