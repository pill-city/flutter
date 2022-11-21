import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/utils/rendered_reaction.dart';
import 'package:pill_city_flutter/src/widgets/reaction_count_widget.dart';
import 'package:pill_city_flutter/src/widgets/reaction_full_widget.dart';

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

    bool useFull = renderedReactions
            .map((r) => r.users)
            .expand((e) => e)
            .map((u) => getUserPrimaryName(u,
                    displayNameMaxLength: reactionFullDisplayNameMaxLength)
                .length)
            .reduce((a, b) => a + b) <
        reactionFullDisplayNameTotalLengthThreshold;

    return Row(
      children: [
        for (final reaction in renderedReactions)
          Row(
            children: [
              useFull
                  ? ReactionFullWidget(reaction: reaction)
                  : ReactionCountWidget(reaction: reaction),
              const SizedBox(width: 8),
            ],
          )
      ],
    );
  }
}
