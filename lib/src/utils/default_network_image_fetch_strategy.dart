import 'package:flutter_image/flutter_image.dart';

FetchStrategy defaultNetworkImageFetchStrategy = const FetchStrategyBuilder(
  maxAttempts: 5,
  timeout: Duration(seconds: 6),
).build();
