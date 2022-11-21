import 'package:flutter/material.dart';
import 'package:pill_city_flutter/src/utils/get_user_names.dart';
import 'package:pill_city_flutter/src/utils/rendered_reaction.dart';
import 'package:twemoji/twemoji.dart';

const reactionFullDisplayNameMaxLength = 9;
const reactionFullDisplayNameTotalLengthThreshold = 20;

class ReactionFullWidget extends StatelessWidget {
  const ReactionFullWidget({Key? key, required this.reaction})
      : super(key: key);

  final RenderedReaction reaction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[200]
              : Colors.grey[800],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
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
                Text(reaction.users
                    .map((u) => getUserPrimaryName(u,
                        displayNameMaxLength: reactionFullDisplayNameMaxLength))
                    .join(", ")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
