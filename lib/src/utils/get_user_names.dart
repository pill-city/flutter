import 'dart:math';

import 'package:pill_city/pill_city.dart';

const ellipse = '…';
const primaryNameMaxLength = 15;
const inferredFirstNameMaxLength = 6;
const circleNameMaxLength = 10;

// TODO: if names contain emoji getPrimaryName and getInferredFirstName might return wrong results

String getPrimaryName(User user) {
  if (user.displayName != null) {
    return user.displayName!.length <= primaryNameMaxLength
        ? user.displayName!
        : "${user.displayName!.substring(0, max(ellipse.length, primaryNameMaxLength))}…";
  }
  return user.id;
}

String getInferredFirstName(User user) {
  if (user.displayName != null) {
    String inferredFirstName = user.displayName!;
    if (user.displayName!.split(" ").isNotEmpty) {
      inferredFirstName = user.displayName!.split(" ").first;
    }
    return inferredFirstName.length <= inferredFirstNameMaxLength
        ? inferredFirstName
        : "${inferredFirstName.substring(0, max(ellipse.length, inferredFirstNameMaxLength))}…";
  }
  return user.id;
}

String? getSecondaryName(User user) {
  if (user.displayName != null) {
    return '@${user.id}';
  }
  return null;
}

String getCircleName(String circleName) {
  if (circleName.length <= circleNameMaxLength) {
    return circleName;
  }
  return "${circleName.substring(0, max(ellipse.length, circleNameMaxLength))}…";
}
