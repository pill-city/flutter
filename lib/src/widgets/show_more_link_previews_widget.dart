import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';

import 'link_preview_widget.dart';

class ShowMoreLinkPreviewsWidget extends StatelessWidget {
  const ShowMoreLinkPreviewsWidget({super.key, required this.linkPreviews});

  final BuiltList<LinkPreview> linkPreviews;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
          builder: (BuildContext context) {
            final List<Widget> children = [];
            for (var i = 0; i < linkPreviews.length; i++) {
              final linkPreview = linkPreviews[i];
              children.add(
                LinkPreviewWidget(linkPreview: linkPreview),
              );
              if (i != linkPreviews.length - 1) {
                children.add(const SizedBox(height: 16));
              }
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.more_link_previews),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: children),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Text(
        AppLocalizations.of(context)!
            .and_more_link_previews(linkPreviews.length),
        style: const TextStyle(
          color: Colors.grey,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
