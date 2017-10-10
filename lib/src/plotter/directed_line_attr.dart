part of plotter;

/// An attribute for setting if the line is directed or not.
class DirectedLineAttr implements IAttribute {
  /// The directed line flag to set.
  bool _directed;

  /// The last directed line flag in the renderer.
  bool _last;

  /// Creates a directed line flag attribute.
  DirectedLineAttr([this._directed = true]) {
    _last = false;
  }

  /// Gets the directed line flag to apply for this attribute.
  bool get directed => _directed;
  set directed(bool directed) => _directed = directed;

  /// Pushes the attribute to the renderer.
  void _pushAttr(IRenderer r) {
    _last = r.directedLines;
    r.directedLines = _directed;
  }

  /// Pops the attribute from the renderer.
  void _popAttr(IRenderer r) {
    r.directedLines = _last;
    _last = false;
  }
}
