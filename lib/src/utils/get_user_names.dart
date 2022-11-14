import 'package:pill_city/pill_city.dart';

String getUserPrimaryName(User user) {
  if (user.displayName != null) {
    return user.displayName!.length < 20
        ? user.displayName!
        : "${user.displayName!.substring(0, 20)}...";
  }
  return user.id;
}

String? getUserSecondaryName(User user) {
  if (user.displayName != null) {
    return '@${user.id}';
  }
  return null;
}
