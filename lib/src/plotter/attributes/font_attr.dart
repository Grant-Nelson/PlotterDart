part of plotter;

/// An attribute for setting the font.
class FontAttr extends IAttribute {
  /// The font to set.
  String _font;

  /// The last font in the renderer.
  String _last;

  /// Creates a line font attribute.
  FontAttr(String this._font) {
    this._font = font;
  }

  /// The font to apply for this attribute.
  String get font => this._font;
  set font(String font) => this._font = font;

  /// Pushes the attribute to the renderer.
  void _pushAttr(IRenderer r) {
    this._last = r.font;
    r.font = this._font;
  }

  /// Pops the attribute from the renderer.
  void _popAttr(IRenderer r) {
    r.font = this._last;
    this._last = null;
  }
}
