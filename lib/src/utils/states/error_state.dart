import 'package:rich_text_editor_controller/src/utils/utils_barrel.dart';

abstract class ErrorState extends RiverpodState {
  final Failure failure;

  const ErrorState({
    required this.failure,
  });
}
