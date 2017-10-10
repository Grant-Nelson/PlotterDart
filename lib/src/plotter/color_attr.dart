part of plotter;

/// An attribute for setting the line color.
class ColorAttr extends IAttribute {
  /// The color to set.
  Color _color;

  /// The last color in the renderer.
  Color _last;

  /// Creates a line color attribute.
  ColorAttr(Color color) {
    _color = color;
    _last = null;
  }

  /// Creates a line color attribute.
  factory ColorAttr.rgb(double red, double green, double blue,
      [double alpha = 1.0]) {
    return new ColorAttr(new Color(red, green, blue, alpha));
  }

  /// The color to apply for this attribute.
  Color get color => _color;
  set color(Color color) => _color = color;

  /// Pushes the attribute to the renderer.
  void _pushAttr(IRenderer r) {
    _last = r.color;
    r.color = _color;
  }

  /// Pops the attribute from the renderer.
  void _popAttr(IRenderer r) {
    r.color = _last;
    _last = null;
  }
}
