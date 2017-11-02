part of plotter;

/// A plotter item for drawing lines.
class Lines extends BasicCoordsItem {
  /// Creates a new line plotter item.
  Lines() : super._(4);

  List<double> get _x1 => _coords[0];
  List<double> get _y1 => _coords[1];
  List<double> get _x2 => _coords[2];
  List<double> get _y2 => _coords[3];

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    r.drawLines(_x1, _y1, _x2, _y2);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) {
      b.expand(_x1[i], _y1[i]);
      b.expand(_x2[i], _y2[i]);
    }
    return trans.transform(b);
  }
}
