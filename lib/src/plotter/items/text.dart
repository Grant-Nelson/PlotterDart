part of plotter;

/// A plotter item for points.
class Text extends PlotterItem {
  double _x;
  double _y;
  double _size;
  String _text;
  bool _scale;

  /// Creates a points plotter item.
  Text([this._x = 0.0, this._y = 0.0, this._size = 10.0, this._text = "", this._scale = false]);

  /// The x location of the left of the text.
  double get x => this._x;
  set x(double value) => this._x = value;

  /// The y location of the bottom of the text.
  double get y => this._y;
  set y(double value) => this._y = value;

  /// The size of the text in pixels.
  double get size => this._size;
  set size(double value) => this._size = value;

  /// The text to draw.
  String get text => this._text;
  set text(String value) => this._text = value;

  /// Indicates if the text should scale and track the graph.
  bool get scale => this._scale;
  set scale(bool value) => this._scale = value;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    if (this._text.length > 0)
      r.drawText(this._x, this._y, this._size, this._text, this._scale);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    if (this._text.length > 0) b.expand(this._x, this._y);
    return trans.transform(b);
  }
}
