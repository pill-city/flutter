import 'package:built_collection/built_collection.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/aggregated_reaction.dart';
import 'package:pill_city_flutter/src/utils/get_twemoji_text_spans.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/widgets/reaction_count_widget.dart';
import 'package:pill_city_flutter/src/widgets/reaction_full_widget.dart';
import 'package:twemoji/twemoji.dart';

class ReactionsWidget extends StatelessWidget {
  const ReactionsWidget({
    Key? key,
    required this.reactions,
    required this.fullReactionMaxUsers,
  }) : super(key: key);

  final BuiltList<Reaction>? reactions;
  final int fullReactionMaxUsers;

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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: getTwemojiTextSpans(
                          aggregatedReaction.users
                              .map((u) => getPrimaryName(u))
                              .join(", "),
                          context,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
          if (reactions != null && i != reactions!.length - 1) {
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

  void showAddReaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      builder: (BuildContext context) {
        return EmojiPicker(
          // onEmojiSelected: (Category category, Emoji emoji) {
          //   // Do something when emoji is tapped (optional)
          // },
          config: Config(
            columns: 7,
            emojiSizeMax: 32,
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
            initCategory: Category.RECENT,
            bgColor: (Theme.of(context).brightness == Brightness.light
                ? Colors.grey[200]
                : Colors.grey[800])!,
            indicatorColor: Colors.red,
            iconColor: (Theme.of(context).brightness == Brightness.light
                ? Colors.grey[800]
                : Colors.grey[200])!,
            iconColorSelected: Colors.redAccent,
            enableSkinTones: false,
            showRecentsTab: true,
            recentsLimit: 49,
            noRecents: Text(
              AppLocalizations.of(context)!.no_recent_reactions,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[800]
                    : Colors.grey[200],
              ),
              textAlign: TextAlign.center,
            ),
            loadingIndicator: const SizedBox.shrink(),
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.NONE,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<User>> usersByEmoji = {};
    if (reactions != null) {
      for (final reaction in reactions!) {
        usersByEmoji[reaction.emoji] =
            (usersByEmoji[reaction.emoji] ?? []) + [reaction.author];
      }
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

    int totalNamesLength = 0;
    int allReactionsCount = 0;
    if (reactions != null && reactions!.isNotEmpty) {
      totalNamesLength = aggregatedReactions
          .map((r) => r.users)
          .expand((e) => e)
          .map((u) => getInferredFirstName(u).length)
          .reduce((a, b) => a + b);
      allReactionsCount = aggregatedReactions
          .map((r) => r.users.length)
          .reduce((a, b) => a + b);
    }
    bool useFull = totalNamesLength < fullReactionMaxUsers * 10;

    return GestureDetector(
      onLongPress: () {
        showReactionsFullDetail(context, aggregatedReactions);
      },
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final reaction in useFull
              ? aggregatedReactions
              : aggregatedReactions.take(fullReactionMaxUsers))
            useFull
                ? ReactionFullWidget(reaction: reaction)
                : ReactionCountWidget(reaction: reaction),
          GestureDetector(
            onTap: () {
              showAddReaction(context);
            },
            child: SizedBox(
              width: 32,
              height: 32,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[200]
                      : Colors.grey[800],
                ),
                child: const Icon(
                  Icons.add_reaction,
                  size: 16,
                ),
              ),
            ),
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
