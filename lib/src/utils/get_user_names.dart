import 'package:pill_city/pill_city.dart';

const displayNameMaxLength = 20;

String getUserPrimaryName(User user) {
  if (user.displayName != null) {
    return user.displayName!.length < displayNameMaxLength
        ? user.displayName!
        : "${user.displayName!.substring(0, displayNameMaxLength)}...";
  }
  return user.id;
}

String? getUserSecondaryName(User user) {
  if (user.displayName != null) {
    return '@${user.id}';
  }
  return null;
}
