part of plotter;

/// A plotter item for drawing a line strip.
class LineStrip extends BasicCoordsItem {

  /// Creates a line strip plotter item.
  LineStrip(): super._(2);

  List<double> get _x => _coords[0];
  List<double> get _y => _coords[1];

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    r.drawStrip(_x, _y);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) b.expand(_x[i], _y[i]);
    return trans.transform(b);
  }
}
