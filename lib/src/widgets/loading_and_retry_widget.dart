import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city_flutter/src/utils/get_error_message.dart';

class LoadingAndRetryWidget extends StatelessWidget {
  const LoadingAndRetryWidget({
    super.key,
    required this.loading,
    this.error,
    required this.builder,
    required this.onRetry,
  });

  final bool loading;
  final DioError? error;
  final Widget Function(BuildContext context) builder;
  final void Function() onRetry;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (error != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            getErrorMessage(error!),
          ),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      );
    } else {
      return builder(context);
    }
  }
}
