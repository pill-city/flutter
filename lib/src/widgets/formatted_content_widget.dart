import 'package:built_collection/built_collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:url_launcher/url_launcher.dart';

class FormattedContentWidget extends StatelessWidget {
  const FormattedContentWidget(
      {super.key, required this.content, required this.maxLines});

  final FormattedContent content;
  final int maxLines;

  TextSpan segmentToTextSpan(
      FormattedContentSegment segment, BuiltList<String> references) {
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

    if (useUrl != null) {
      return TextSpan(
        text: segment.content,
        style: style,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
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
          },
      );
    } else if (useMention != null) {
      return TextSpan(
        text: segment.content,
        style: style,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launchUrl(
              Uri.parse("https://pill.city/profile/${useMention!}"),
              mode: LaunchMode.externalApplication,
            );
          },
      );
    } else {
      return TextSpan(
        text: segment.content,
        style: style,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: content.segments.map((FormattedContentSegment segment) {
          return segmentToTextSpan(segment, content.references);
        }).toList(),
      ),
      maxLines: maxLines,
      overflow: TextOverflow.fade,
    );
  }
}
