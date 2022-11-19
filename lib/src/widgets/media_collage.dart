import 'package:built_collection/built_collection.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/widgets/media_collage_widgets.dart';

class MediaCollage extends StatelessWidget {
  const MediaCollage({super.key, required this.mediaList});

  final BuiltList<MediaUrlV2> mediaList;

  Widget build1(BuildContext context) {
    return MediaCollageContainer(
      item: Left(
        MediaCollageCell(mediaList: mediaList, index: 0),
      ),
    );
  }

  Widget build2(BuildContext context) {
    return MediaCollageContainer(
      item: Right(
        MediaCollageRow(
          items: [
            Left(MediaCollageCell(mediaList: mediaList, index: 0)),
            Left(MediaCollageCell(mediaList: mediaList, index: 1)),
          ],
        ),
      ),
    );
  }

  Widget build3(BuildContext context) {
    return MediaCollageContainer(
      item: Right(
        MediaCollageRow(
          items: [
            Left(MediaCollageCell(mediaList: mediaList, index: 0)),
            Right(
              MediaCollageColumn(
                cells: [
                  MediaCollageCell(mediaList: mediaList, index: 1),
                  MediaCollageCell(mediaList: mediaList, index: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget build4(BuildContext context) {
    return MediaCollageContainer(
      item: Right(
        MediaCollageRow(
          items: [
            Right(
              MediaCollageColumn(
                cells: [
                  MediaCollageCell(mediaList: mediaList, index: 0),
                  MediaCollageCell(mediaList: mediaList, index: 2),
                ],
              ),
            ),
            Right(
              MediaCollageColumn(
                cells: [
                  MediaCollageCell(mediaList: mediaList, index: 1),
                  MediaCollageCell(mediaList: mediaList, index: 3),
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
    if (mediaList.length == 1) {
      return build1(context);
    } else if (mediaList.length == 2) {
      return build2(context);
    } else if (mediaList.length == 3) {
      return build3(context);
    } else {
      return build4(context);
    }
  }
}
