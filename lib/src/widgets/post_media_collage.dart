import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/widgets/post_media_image.dart';

class PostMediaCollage extends StatelessWidget {
  const PostMediaCollage({super.key, required this.postMedia});

  final BuiltList<MediaUrlV2> postMedia;

  Widget build1(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: PostMediaImage(postMedia: postMedia.first),
        ),
      ),
    );
  }

  Widget build2(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              flex: 20,
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: PostMediaImage(postMedia: postMedia.first),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 20,
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: PostMediaImage(postMedia: postMedia[1]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (postMedia.length == 1) {
      return build1(context);
    } else if (postMedia.length == 2) {
      return build2(context);
    } else if (postMedia.length == 3) {
      return build2(context);
    } else {
      return build2(context);
    }
  }
}
