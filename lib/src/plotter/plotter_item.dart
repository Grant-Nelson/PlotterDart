part of plotter;

/// The abstract for all plotter items.
abstract class PlotterItem {
  /// The set of attributes for this item.
  List<IAttribute> _attrs;

  /// Indicates if this item should be plotted or not. 
  bool _enabled;

  /// Creates a plotter item.
  PlotterItem() {
    this._attrs = new List<IAttribute>();
    this._enabled = true;
  }

  /// Enables or disables this item for being plotted.
  bool get enabled => this._enabled;
  set enabled(bool enabled) => this._enabled = enabled;

  /// Gets the set of attributes for this item.
  List<IAttribute> get attributes => this._attrs;

  /// Adds an attribute to this item.
  void addAttr(IAttribute attr) => this._attrs.add(attr);

  /// Adds a color attribute to this item.
  void addColor(double red, double green, double blue, [double alpha = 1.0]) =>
    this.addAttr(new ColorAttr.rgb(red, green, blue, alpha));

  /// Adds a point size attribute to this item.
  void addPointSize(double size) =>
    this.addAttr(new PointSizeAttr(size));

  /// Adds a filled attribute to this item.
  void addFillColor(double red, double green, double blue, [double alpha = 1.0]) =>
    this.addAttr(new FillColorAttr.rgb(red, green, blue, alpha));

  /// Adds a filled attribute indicating no fill color to this item.
  void addNoFillColor() =>
    this.addAttr(new FillColorAttr(null));

  /// Adds a directed line attribute to this item.
  void addDirected(bool directed) =>
    this.addAttr(new DirectedLineAttr(directed));

  /// Draws the item to the panel.
  void draw(IRenderer r) {
    if (!this._enabled) return;
    final int count = this._attrs.length;
    for (int i = 0; i < count; i++)
      this._attrs[i]._pushAttr(r);
    this._onDraw(r);
    for (int i = count - 1; i >= 0; i--)
      this._attrs[i]._popAttr(r);
  }

  /// Gets the bounds for this item.
  Bounds getBounds(Transformer trans) {
    if (!this._enabled) return new Bounds.empty();
    final int count = this._attrs.length;
    for (int i = 0; i < count; i++) {
      IAttribute attr = this._attrs[i];
      if (attr is TransAttr) trans = attr.apply(trans);
    }
    Bounds b = this._onGetBounds(trans);
    for (int i = count - 1; i >= 0; i--) {
      IAttribute attr = this._attrs[i];
      if (attr is TransAttr) trans = attr.unapply(trans);
    }
    return b;
  }

  /// The abstract method to draw to the panel.
  void _onDraw(IRenderer r);

  /// The abstract method for getting the bounds for the item.
  Bounds _onGetBounds(Transformer trans);
}
