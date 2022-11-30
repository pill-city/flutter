import 'package:flutter/cupertino.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/state/app_global_state.dart';
import 'package:provider/provider.dart';

class MeState extends ChangeNotifier {
  User? me;

  Future<void> loadMe(BuildContext context) async {
    if (me != null) {
      return;
    }
    final appGlobalState = Provider.of<AppGlobalState>(context, listen: false);
    final api = await appGlobalState.getAuthenticatedApi();
    final response = await api.getCoreApi().getMe();
    if (response.data == null) {
      return Future.error("Failed to load me");
    }
    me = response.data;
  }
}
