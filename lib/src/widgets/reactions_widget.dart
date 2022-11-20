import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:twemoji/twemoji.dart';

class RenderedReaction {
  final String emoji;
  final int count;

  RenderedReaction(this.emoji, this.count);
}

class ReactionWidget extends StatelessWidget {
  const ReactionWidget({Key? key, required this.reaction}) : super(key: key);

  final RenderedReaction reaction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: reaction.count.toString().length == 1
          ? 48
          : reaction.count.toString().length == 2
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
                reaction.count.toString().length < 3
                    ? reaction.count.toString()
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
    Map<String, int> countByEmoji = {};
    for (final reaction in reactions) {
      countByEmoji[reaction.emoji] = (countByEmoji[reaction.emoji] ?? 0) + 1;
    }
    List<RenderedReaction> renderedReactions = countByEmoji.entries
        .map((e) => RenderedReaction(e.key, e.value))
        .toList();
    renderedReactions.sort((a, b) {
      if (a.count != b.count) {
        return b.count - a.count;
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
