import 'package:rich_text_editor_controller/src/utils/utils_barrel.dart';

abstract class RiverpodStateWithStatus extends RiverpodState {
  final bool success;
  final bool loading;
  final Failure? error;

  const RiverpodStateWithStatus({
    required this.success,
    required this.loading,
    this.error,
  });

  dynamic copyWith({
    bool? success,
    bool? loading,
    Failure? error,
  });
}
