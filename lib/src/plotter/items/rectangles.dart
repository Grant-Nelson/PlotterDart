part of plotter;

/// A plotter item for drawing rectangles.
class Rectangles extends BasicCoordsItem {
  /// Creates a new rectangle plotter item.
  Rectangles() : super._(4);

  List<double> get _lefts => this._coords[0];
  List<double> get _tops => this._coords[1];
  List<double> get _widths => this._coords[2];
  List<double> get _heights => this._coords[3];

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) =>
    r.drawRects(this._lefts, this._tops, this._widths, this._heights);

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = this.count - 1; i >= 0; --i) {
      double x = this._lefts[i];
      double y = this._tops[i];
      b.expand(x, y);
      b.expand(x + this._widths[i], y + this._heights[i]);
    }
    return trans.transform(b);
  }
}
