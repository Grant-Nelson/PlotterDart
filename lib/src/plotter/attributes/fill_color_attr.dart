part of plotter;

/// An attribute for setting the fill color.
class FillColorAttr extends IAttribute {
  /// The color to set, or null for no fill.
  Color _color;

  /// The last color in the renderer.
  Color _last;

  /// Creates a fill color attribute.
  FillColorAttr([this._color = null]) {
    this._last = null;
  }

  /// Creates a fill color attribute.
  factory FillColorAttr.rgb(double red, double green, double blue, [double alpha = 1.0]) =>
    new FillColorAttr(new Color(red, green, blue, alpha));

  /// The color to apply for this attribute.
  Color get color => this._color;
  set color(Color color) => this._color = color;

  /// Pushes the attribute to the renderer.
  void _pushAttr(IRenderer r) {
    this._last = r.fillColor;
    r.fillColor = this._color;
  }

  /// Pops the attribute from the renderer.
  void _popAttr(IRenderer r) {
    r.fillColor = this._last;
    this._last = null;
  }
}
