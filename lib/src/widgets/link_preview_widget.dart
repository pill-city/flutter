import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreviewWidget extends StatelessWidget {
  const LinkPreviewWidget({super.key, required this.linkPreview});

  final LinkPreview linkPreview;

  @override
  Widget build(BuildContext context) {
    if (linkPreview.state != LinkPreviewStateEnum.fetched) {
      return const SizedBox.shrink();
    }
    return InkWell(
        onTap: () {
          try {
            launchUrl(
              Uri.parse(linkPreview.url),
              mode: LaunchMode.externalApplication,
            );
          } on FormatException {
            return;
          }
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                if (linkPreview.imageUrls != null &&
                    linkPreview.imageUrls!.isNotEmpty)
                  Row(
                    children: [
                      SizedBox(
                        width: 48,
                        child: Image.network(
                          linkPreview.imageUrls![0],
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                      const SizedBox(width: 8)
                    ],
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (linkPreview.title != null)
                        Text(
                          linkPreview.title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 0.9,
                        ),
                      if (linkPreview.subtitle != null)
                        Text(
                          linkPreview.subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 0.8,
                          style: const TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
