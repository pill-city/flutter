import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twemoji/twemoji.dart';

List<InlineSpan> getTwemojiTextSpans(
  String text,
  BuildContext context, {
  GestureTapCallback? onTap,
  TextStyle? additionalStyle,
}) {
  final spans = <InlineSpan>[];
  final textStyle = additionalStyle != null
      ? additionalStyle.copyWith(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        )
      : TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        );

  final emojiStyle = textStyle;
  text.splitMapJoin(
    regex,
    onMatch: (m) {
      final emojiStr = m.input.substring(m.start, m.end);

      Widget child = Padding(
        padding: EdgeInsets.symmetric(
            horizontal: emojiStyle.letterSpacing ?? 1,
            vertical: emojiStyle.height ?? 2),
        child: Twemoji(
          emoji: emojiStr,
          height: emojiStyle.fontSize,
          width: emojiStyle.fontSize,
        ),
      );

      if (onTap != null) {
        child = GestureDetector(
          onTap: onTap,
          child: child,
        );
      }

      spans.add(
        WidgetSpan(
          child: child,
        ),
      );
      return '';
    },
    onNonMatch: (s) {
      TapGestureRecognizer? recognizer;

      if (onTap != null) {
        recognizer = TapGestureRecognizer()..onTap = onTap;
      }
      spans.add(
        TextSpan(
          text: s,
          style: textStyle,
          recognizer: recognizer,
        ),
      );
      return '';
    },
  );

  return spans;
}
