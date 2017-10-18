part of plotter;

/// A group for plotter items.
class Group extends PlotterItem {
  /// The label for the group.
  String _label;

  /// Indicates that the group is enabled.
  bool _enabled;

  /// The plotter items in this group.
  List<PlotterItem> _items;

  /// Creates a new plotter item group.
  Group([this._label = "", this._enabled = true]) {
    _items = new List<PlotterItem>();
  }

  /// The label for the item.
  String get label => _label;
  set label(String label) => _label = label;

  /// Indicates if the item is enabled or disabled.
  bool get enabled => _enabled;
  set enabled(bool enabled) => _enabled = enabled;

  /// The number of items in the group.
  int get count => _items.length;

  /// The list of items in the group.
  List<PlotterItem> get items => _items;

  /// Adds plotter items to the group.
  void add(List<PlotterItem> items) {
    for (PlotterItem item in items) _items.add(item);
  }

  /// Adds a points plotter item with the given data.
  Points addPoints(List<double> val) {
    Points item = new Points()..add(val);
    add([item]);
    return item;
  }

  /// Adds a lines plotter item with the given data.
  Lines addLines(List<double> val) {
    Lines item = new Lines()..add(val);
    add([item]);
    return item;
  }

  /// Adds a line strip plotter item with the given data.
  LineStrip addLineStrip(List<double> val) {
    LineStrip item = new LineStrip()..add(val);
    add([item]);
    return item;
  }

  /// Adds a polygon plotter item with the given data.
  Polygon addPolygon(List<double> val) {
    Polygon item = new Polygon()..add(val);
    add([item]);
    return item;
  }

  /// Adds a rectangle plotter item with the given data.
  Rectangles addRects(List<double> items) {
    Rectangles item = new Rectangles()..add(items);
    add([item]);
    return item;
  }

  /// Adds a circle plotter item with the given data.
  Circles addCircles(List<double> items) {
    Circles item = new Circles()..add(items);
    add([item]);
    return item;
  }

  /// Adds a ellipses plotter item with the given data.
  Ellipses addEllipses(List<double> items) {
    Ellipses item = new Ellipses()..add(items);
    add([item]);
    return item;
  }

  /// Adds a child group item with the given items.
  Group addGroup([String label = "", List<PlotterItem> items = null, bool enabled = true]) {
    Group item = new Group()..label=label..enabled=enabled;
    if (items != null) item.add(items);
    add([item]);
    return item;
  }

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    if (_enabled) {
      for (PlotterItem item in _items) item.draw(r);
    }
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    if (_enabled) {
      for (PlotterItem item in _items) b.union(item.getBounds(trans));
    }
    return b;
  }
}
