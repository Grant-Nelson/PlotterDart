part of plotter;

/// A simple color for plotting.
///
/// Since there are many packages that the plotter could be used to
/// output to, such as opengl, svg, gnuplot, swing, etc.,
/// this is a generic color is used to reduce complexity and keep consistent.
class Color {
  // The red component for the color, 0 .. 1.
  double _red;

  // The green component for the color, 0 .. 1.
  double _green;

  // The blue component for the color, 0 .. 1.
  double _blue;

  // The alpha component for the color, 0 .. 1.
  double _alpha;

  /// Creates a color.
  Color(double red, double green, double blue, [double alpha = 1.0]) {
    _red = _clamp(red);
    _green = _clamp(green);
    _blue = _clamp(blue);
    _alpha = _clamp(alpha);
  }

  /// Sets the color to the given values.
  void set(double red, double green, double blue, [double alpha = 1.0]) {
    _red = _clamp(red);
    _green = _clamp(green);
    _blue = _clamp(blue);
    _alpha = _clamp(alpha);
  }

  /// The red component of the color.
  double get red => _red;
  set red(double red) => _red = _clamp(red);

  /// The green component of the color.
  double get green => _green;
  set green(double green) => _green = _clamp(green);

  /// The blue component of the color.
  double get blue => _blue;
  set blue(double blue) => _blue = _clamp(blue);

  /// The alpha component of the color.
  double get alpha => _alpha;
  set alpha(double alpha) => _alpha = _clamp(alpha);

  /// Clamps a value to between 0 and 1 inclusively.
  double _clamp(double val) =>
    (val > 1.0) ? 1.0 : ((val < 0.0) ? 0.0 : val);
}
