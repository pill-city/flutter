import 'package:built_collection/built_collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:url_launcher/url_launcher.dart';

import 'get_twemoji_text_spans.dart';

List<TextSpan> getFormattedContentTextSpans(
    FormattedContent content, BuildContext context) {
  BuiltList<String> references = content.references;

  return content.segments.map(
    (FormattedContentSegment segment) {
      String? useUrl;
      String? useMention;

      TextStyle style = const TextStyle();
      if (segment.types.contains(
        FormattedContentSegmentTypesEnum.strikethrough,
      )) {
        style = style.copyWith(decoration: TextDecoration.lineThrough);
      }
      if (segment.types.contains(FormattedContentSegmentTypesEnum.bold)) {
        style = style.copyWith(fontWeight: FontWeight.bold);
      }
      if (segment.types.contains(FormattedContentSegmentTypesEnum.italic)) {
        style = style.copyWith(fontStyle: FontStyle.italic);
      }
      if (segment.reference != null && segment.reference! < references.length) {
        if (segment.types.contains(FormattedContentSegmentTypesEnum.url)) {
          style = style.copyWith(decoration: TextDecoration.underline);
          useUrl = references[segment.reference!];
        }
        if (segment.types.contains(FormattedContentSegmentTypesEnum.mention)) {
          style = style.copyWith(decoration: TextDecoration.underline);
          useMention = references[segment.reference!];
        }
      }

      GestureTapCallback? onTap;

      if (useUrl != null) {
        onTap = () {
          Uri? parsedUrl;
          try {
            parsedUrl = Uri.parse(useUrl!);
          } on FormatException {
            return;
          }
          launchUrl(
            parsedUrl,
            mode: LaunchMode.externalApplication,
          );
        };
      } else if (useMention != null) {
        onTap = () {
          launchUrl(
            Uri.parse("https://pill.city/profile/${useMention!}"),
            mode: LaunchMode.externalApplication,
          );
        };
      }

      return TextSpan(
        children: getTwemojiTextSpans(
          segment.content,
          context,
          onTap: onTap,
          additionalStyle: style,
        ),
      );
    },
  ).toList();
}
