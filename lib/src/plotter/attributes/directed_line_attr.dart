part of plotter;

/// An attribute for setting if the line is directed or not.
class DirectedLineAttr implements IAttribute {
  /// The directed line flag to set.
  bool _directed;

  /// The last directed line flag in the renderer.
  bool _last;

  /// Creates a directed line flag attribute.
  DirectedLineAttr([this._directed = true]) {
    this._last = false;
  }

  /// Gets the directed line flag to apply for this attribute.
  bool get directed => this._directed;
  set directed(bool directed) => this._directed = directed;

  /// Pushes the attribute to the renderer.
  void _pushAttr(IRenderer r) {
    this._last = r.directedLines;
    r.directedLines = this._directed;
  }

  /// Pops the attribute from the renderer.
  void _popAttr(IRenderer r) {
    r.directedLines = this._last;
    this._last = false;
  }
}
