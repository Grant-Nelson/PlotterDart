part of plotter;

/// The abstract for all plotter items.
abstract class PlotterItem {
  /// The set of attributes for this item.
  List<IAttribute> _attrs;

  /// Creates a plotter item.
  PlotterItem() {
    _attrs = new List<IAttribute>();
  }

  /// Gets the set of attributes for this item.
  List<IAttribute> get attributes => _attrs;

  /// Adds an attribute to this item.
  void addAttr(IAttribute attr) => _attrs.add(attr);

  /// Adds a color attribute to this item.
  void addColor(double red, double green, double blue) =>
      addAttr(new ColorAttr.rgb(red, green, blue));

  /// Adds a point size attribute to this item.
  void addPointSize(double size) => addAttr(new PointSizeAttr(size));

  /// Adds a filled attribute to this item.
  void addFillColor(double red, double green, double blue) =>
      addAttr(new FillColorAttr.rgb(red, green, blue));

  /// Adds a directed line attribute to this item.
  void addDirected(bool directed) => addAttr(new DirectedLineAttr(directed));

  /// Draws the item to the panel.
  void draw(IRenderer r) {
    final int count = _attrs.length;
    for (int i = 0; i < count; i++) _attrs[i]._pushAttr(r);
    _onDraw(r);
    for (int i = count - 1; i >= 0; i--) _attrs[i]._popAttr(r);
  }

  /// Gets the bounds for this item.
  Bounds getBounds(Transformer trans) {
    final int count = _attrs.length;
    for (int i = 0; i < count; i++) {
      IAttribute attr = _attrs[i];
      if (attr is TransAttr) {
        trans = attr.apply(trans);
      }
    }
    Bounds b = _onGetBounds(trans);
    for (int i = count - 1; i >= 0; i--) {
      IAttribute attr = _attrs[i];
      if (attr is TransAttr) {
        trans = attr.unapply(trans);
      }
    }
    return b;
  }

  /// The abstract method to draw to the panel.
  void _onDraw(IRenderer r);

  /// The abstract method for getting the bounds for the item.
  Bounds _onGetBounds(Transformer trans);
}
