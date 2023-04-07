import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rich_text_editor_controller/src/utils/error_handling/error_barrel.dart';

typedef ErrorFallback<Error> = FutureOr<Error> Function(Failure failure);

mixin BasicErrorHandlerMixin {
  Future<T> handleError<T>(
    Future<T> computation, {
    ErrorFallback<T>? catcher,
  }) async {
    try {
      return await computation;
    } catch (e, stackTrace) {
      late Failure failure;
      if (e is! Failure) {
        failure = Failure(message: '$e', stackTrace: stackTrace);
      } else {
        failure = e;
      }
      debugPrint('basic handler error: $failure');

      return catcher != null ? catcher.call(failure) : Future<T>.error(failure);
    }
  }
}
