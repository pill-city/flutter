import 'package:pill_city/pill_city.dart';

String getUserPrimaryName(User user) {
  if (user.displayName != null) {
    return user.displayName!;
  }
  return '@${user.id}';
}

String? getUserSecondaryName(User user) {
  if (user.displayName != null) {
    return '@${user.id}';
  }
  return null;
}