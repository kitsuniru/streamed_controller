/*
 *
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 25 July 2023
 */

extension $DurationExt on Duration {
  Duration substract(Duration other) =>
      Duration(seconds: other.inSeconds - inSeconds);

  Duration difference(Duration other) => substract(other).abs();

  Duration add(Duration other) =>
      Duration(seconds: other.inSeconds + inSeconds);
}
