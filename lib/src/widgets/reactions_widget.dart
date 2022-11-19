import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';

class RenderedReaction {
  final String emoji;
  final int count;

  RenderedReaction(this.emoji, this.count);
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

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          for (final reaction in renderedReactions)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[800],
              ),
              child: Text("${reaction.emoji} ${reaction.count}"),
            ),
        ],
      ),
    );
  }
}