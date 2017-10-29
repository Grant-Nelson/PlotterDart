part of plotter;

/// A plotter item for drawing rectangles.
class Rectangles extends BasicCoordsItem {

  /// Creates a new rectangle plotter item.
  Rectangles(): super._(4);

  List<double> get _lefts => _coords[0];
  List<double> get _tops => _coords[1];
  List<double> get _widths => _coords[2];
  List<double> get _heights => _coords[3];

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    r.drawRects(_lefts, _tops, _widths, _heights);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) {
      double x = _lefts[i];
      double y = _tops[i];
      b.expand(x, y);
      b.expand(x + _widths[i], y + _heights[i]);
    }
    return trans.transform(b);
  }
}
