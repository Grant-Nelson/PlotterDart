part of plotter;

/// A plotter item for points.
class Text extends PlotterItem {
  double _x;
  double _y;
  double _size;
  String _text;

  /// Creates a points plotter item.
  Text();

  /// The x location of the left of the text.
  double get x => _x;
  set x(double value) => _x = value;

  /// The y location of the bottom of the text.
  double get y => _y;
  set y(double value) => _y = value;

  /// The size of the text in pixels.
  double get size => _size;
  set size(double value) => _size = value;

  /// The text to draw.
  String get text => _text;
  set text(String value) => _text = value;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    if (_text.length > 0) r.drawText(_x, _y, _size, _text);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    if (_text.length > 0) b.expand(_x, _y);
    return trans.transform(b);
  }
}
