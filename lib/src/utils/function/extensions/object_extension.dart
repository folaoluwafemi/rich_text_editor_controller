part of 'extensions.dart';

extension NullableObjectExtension on Object? {
  Widget buildWidget<T>(
    Widget Function(BuildContext context, T value) builder,
  ) {
    return Builder(
      builder: (context) => builder(context, this as T),
    );
  }
}
