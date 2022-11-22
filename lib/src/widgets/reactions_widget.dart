import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/aggregated_reaction.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/widgets/reaction_count_widget.dart';
import 'package:pill_city_flutter/src/widgets/reaction_full_widget.dart';
import 'package:twemoji/twemoji.dart';

const nonFullReactionCount = 2;

class ReactionsWidget extends StatelessWidget {
  const ReactionsWidget({Key? key, required this.reactions}) : super(key: key);

  final BuiltList<Reaction> reactions;

  void showReactionsFullDetail(
    BuildContext context,
    List<AggregatedReaction> aggregatedReactions,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      builder: (BuildContext context) {
        final List<Widget> children = [];
        for (var i = 0; i < aggregatedReactions.length; i++) {
          final aggregatedReaction = aggregatedReactions[i];
          children.add(
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Twemoji(
                      emoji: aggregatedReaction.emoji,
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(aggregatedReaction.users.length.toString()),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      aggregatedReaction.users
                          .map((u) => getPrimaryName(u))
                          .join(", "),
                    ),
                  ],
                ),
              ],
            ),
          );
          if (i != reactions.length - 1) {
            children.add(const SizedBox(height: 16));
          }
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.all_reactions),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: children,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<User>> usersByEmoji = {};
    for (final reaction in reactions) {
      usersByEmoji[reaction.emoji] =
          (usersByEmoji[reaction.emoji] ?? []) + [reaction.author];
    }
    List<AggregatedReaction> aggregatedReactions = usersByEmoji.entries
        .map((e) => AggregatedReaction(e.key, e.value))
        .toList();
    aggregatedReactions.sort((a, b) {
      if (a.users.length != b.users.length) {
        return b.users.length - a.users.length;
      }
      return b.emoji.codeUnitAt(0) - a.emoji.codeUnitAt(0);
    });

    bool useFull = aggregatedReactions
            .map((r) => r.users)
            .expand((e) => e)
            .map((u) => getInferredFirstName(u).length)
            .reduce((a, b) => a + b) <
        reactionFullDisplayNameTotalLengthThreshold;

    int allReactionsCount =
        aggregatedReactions.map((r) => r.users.length).reduce((a, b) => a + b);

    return GestureDetector(
      onLongPress: () {
        showReactionsFullDetail(context, aggregatedReactions);
      },
      child: Row(
        children: [
          for (final reaction in useFull
              ? aggregatedReactions
              : aggregatedReactions.take(nonFullReactionCount))
            Row(
              children: [
                useFull
                    ? ReactionFullWidget(reaction: reaction)
                    : ReactionCountWidget(reaction: reaction),
                const SizedBox(width: 8),
              ],
            ),
          if (!useFull)
            GestureDetector(
              onTap: () {
                showReactionsFullDetail(context, aggregatedReactions);
              },
              child: Text(
                AppLocalizations.of(context)!
                    .all_reactions_counted(allReactionsCount),
                style: const TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
