import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city_flutter/src/utils/aggregated_reaction.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:twemoji/twemoji.dart';

class ReactionsFullDetailWidget extends StatelessWidget {
  const ReactionsFullDetailWidget({Key? key, required this.reactions})
      : super(key: key);

  final List<AggregatedReaction> reactions;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    for (var i = 0; i < reactions.length; i++) {
      final aggregatedReaction = reactions[i];
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
  }
}
