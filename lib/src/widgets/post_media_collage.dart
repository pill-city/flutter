import 'package:built_collection/built_collection.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/widgets/post_media_collage_widgets.dart';

class PostMediaCollage extends StatelessWidget {
  const PostMediaCollage({super.key, required this.postMedia});

  final BuiltList<MediaUrlV2> postMedia;

  Widget build1(BuildContext context) {
    return PostMediaCollageContainer(
      item: Left(
        PostMediaCollageCell(postMedia: postMedia, index: 0),
      ),
    );
  }

  Widget build2(BuildContext context) {
    return PostMediaCollageContainer(
      item: Right(
        PostMediaCollageRow(
          items: [
            Left(PostMediaCollageCell(postMedia: postMedia, index: 0)),
            Left(PostMediaCollageCell(postMedia: postMedia, index: 1)),
          ],
        ),
      ),
    );
  }

  Widget build3(BuildContext context) {
    return PostMediaCollageContainer(
      item: Right(
        PostMediaCollageRow(
          items: [
            Left(PostMediaCollageCell(postMedia: postMedia, index: 0)),
            Right(
              PostMediaCollageColumn(
                cells: [
                  PostMediaCollageCell(postMedia: postMedia, index: 1),
                  PostMediaCollageCell(postMedia: postMedia, index: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget build4(BuildContext context) {
    return PostMediaCollageContainer(
      item: Right(
        PostMediaCollageRow(
          items: [
            Right(
              PostMediaCollageColumn(
                cells: [
                  PostMediaCollageCell(postMedia: postMedia, index: 0),
                  PostMediaCollageCell(postMedia: postMedia, index: 2),
                ],
              ),
            ),
            Right(
              PostMediaCollageColumn(
                cells: [
                  PostMediaCollageCell(postMedia: postMedia, index: 1),
                  PostMediaCollageCell(postMedia: postMedia, index: 3),
                ],
              ),
            )
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
      return build3(context);
    } else {
      return build4(context);
    }
  }
}
