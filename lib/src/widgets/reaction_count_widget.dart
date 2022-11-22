import 'package:flutter/material.dart';
import 'package:pill_city_flutter/src/utils/aggregated_reaction.dart';
import 'package:twemoji/twemoji.dart';

class ReactionCountWidget extends StatelessWidget {
  const ReactionCountWidget({Key? key, required this.reaction})
      : super(key: key);

  final AggregatedReaction reaction;

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
