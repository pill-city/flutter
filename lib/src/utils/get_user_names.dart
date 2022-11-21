import 'dart:math';

import 'package:pill_city/pill_city.dart';

const defaultDisplayNameMaxLength = 15;
const ellipse = '…';

String getUserPrimaryName(User user,
    {int displayNameMaxLength = defaultDisplayNameMaxLength}) {
  if (user.displayName != null) {
    return user.displayName!.length <= displayNameMaxLength
        ? user.displayName!
        : "${user.displayName!.substring(0, max(ellipse.length, displayNameMaxLength))}…";
  }
  return user.id;
}

String? getUserSecondaryName(User user) {
  if (user.displayName != null) {
    return '@${user.id}';
  }
  return null;
}
