import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twemoji/twemoji.dart';

class MyTwemojiTextSpan extends TextSpan {
  MyTwemojiTextSpan({
    TextStyle? style,
    GestureTapCallback? onTap,
    required String text,
    List<TextSpan>? children,
    double emojiFontMultiplier = 1,
    this.twemojiFormat = TwemojiFormat.svg,
  }) : super(
          style: style,
          children:
              _parse(style, onTap, text, twemojiFormat, emojiFontMultiplier)
                ..addAll(children ?? []),
        );

  final TwemojiFormat twemojiFormat;

  static List<InlineSpan> _parse(
    TextStyle? _style,
    GestureTapCallback? _onTap,
    String text,
    TwemojiFormat twemojiFormat,
    double emojiFontMultiplier,
  ) {
    final spans = <InlineSpan>[];
    final textStyle = _style ?? const TextStyle();

    final emojiStyle = textStyle.copyWith(
      fontSize: (textStyle.fontSize ?? 14) * emojiFontMultiplier,
    );
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
            twemojiFormat: twemojiFormat,
            height: emojiStyle.fontSize,
            width: emojiStyle.fontSize,
          ),
        );

        if (_onTap != null) {
          child = GestureDetector(
            onTap: _onTap,
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

        if (_onTap != null) {
          recognizer = TapGestureRecognizer()..onTap = _onTap;
        }
        spans.add(
          TextSpan(
            text: s,
            style: _style,
            recognizer: recognizer,
          ),
        );
        return '';
      },
    );

    return spans;
  }
}
