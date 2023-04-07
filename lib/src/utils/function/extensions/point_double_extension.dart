part of 'extensions.dart';

extension PointDoubleExtension on Point<double> {
  Point<double> subtract(double value) {
    return Point(x - value, y - value);
  }

  Point<double> add(double value) {
    return Point(x + value, y + value);
  }

  Point<double> operator +(Point<double> other) {
    return Point(x + other.x, y + other.y);
  }

  Point<double> operator -(Point<double> other) {
    return Point(x - other.x, y - other.y);
  }
}
