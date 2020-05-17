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

  /// Adds a transformation to this item.
  TransAttr addTrans(double xScalar, double yScalar, double dx, double dy) {
    TransAttr attr = new TransAttr()
      ..transform = Transformer(xScalar, yScalar, dx, dy);
    this.addAttr(attr);
    return attr;
  }
  
  /// Adds an offset to this item.
  TransAttr addOffset(double dx, double dy) =>
    this.addTrans(1.0, 1.0, dx, dy);

  /// Adds a scalar to this item.
  TransAttr addScalar(double xScalar, double yScalar) =>
    this.addTrans(xScalar, yScalar, 0.0, 0.0);

  /// Adds a color attribute to this item.
  ColorAttr addColor(double red, double green, double blue, [double alpha = 1.0]) {
    ColorAttr attr = new ColorAttr.rgb(red, green, blue, alpha);
    this.addAttr(attr);
    return attr;
  }

  /// Adds a point size attribute to this item.
  PointSizeAttr addPointSize(double size) {
    PointSizeAttr attr = new PointSizeAttr(size);
    this.addAttr(attr);
    return attr;
  }

  /// Adds a filled attribute to this item.
  FillColorAttr addFillColor(double red, double green, double blue, [double alpha = 1.0]) {
    FillColorAttr attr = new FillColorAttr.rgb(red, green, blue, alpha);
    this.addAttr(attr);
    return attr;
  }

  /// Adds a filled attribute indicating no fill color to this item.
  FillColorAttr addNoFillColor() {
    FillColorAttr attr = new FillColorAttr(null);
    this.addAttr(attr);
    return attr;
  }

  /// Adds a font attribute to this item.
  FontAttr addFont(String font) {
    FontAttr attr = new FontAttr(font);
    this.addAttr(attr);
    return attr;
  }

  /// Adds a directed line attribute to this item.
  DirectedLineAttr addDirected(bool directed) {
    DirectedLineAttr attr = new DirectedLineAttr(directed);
    this.addAttr(attr);
    return attr;
  }

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
