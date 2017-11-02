part of plotter;

/// An attribute for setting the fill color.
class FillColorAttr extends IAttribute {
  /// The color to set, or null for no fill.
  Color _color;

  /// The last color in the renderer.
  Color _last;

  /// Creates a fill color attribute.
  FillColorAttr([this._color = null]) {
    _last = null;
  }

  /// Creates a fill color attribute.
  factory FillColorAttr.rgb(double red, double green, double blue, [double alpha = 1.0]) {
    return new FillColorAttr(new Color(red, green, blue, alpha));
  }

  /// The color to apply for this attribute.
  Color get color => _color;
  set color(Color color) => _color = color;

  /// Pushes the attribute to the renderer.
  void _pushAttr(IRenderer r) {
    _last = r.fillColor;
    r.fillColor = _color;
  }

  /// Pops the attribute from the renderer.
  void _popAttr(IRenderer r) {
    r.fillColor = _last;
    _last = null;
  }
}
