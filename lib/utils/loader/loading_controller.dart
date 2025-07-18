import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = Function();
typedef UpdateLoadingScreen = Function(String message);

@immutable
class LoadingController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingController({required this.close, required this.update});
}
