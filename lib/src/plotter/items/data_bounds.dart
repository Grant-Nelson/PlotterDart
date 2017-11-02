part of plotter;

/// A plotter item to draw the data bounds.
class DataBounds extends PlotterItem {
  /// Creates a new data bound plotter item.
  /// Adds a default color attribute.
  DataBounds() {
    addColor(1.0, 0.75, 0.75);
  }

  /// Called to draw to the panel.
  void _onDraw(IRenderer r) {
    Bounds bound = r.dataBounds;
    r.drawRect(bound.xmin, bound.ymin, bound.xmax, bound.ymax);
  }

  /// Get the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    return new Bounds.empty();
  }
}
