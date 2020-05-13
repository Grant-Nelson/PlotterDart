part of plotter;

/// A translation attribute for setting a special translation on some data.
class TransAttr implements IAttribute {
  /// The transformation to set.
  Transformer _trans;

  /// True indicates the transformation should be multiplied with
  /// the current transformation at that time, false to just set
  /// the transformation overriding the current one at that time.
  bool _mul;

  /// The previous transformation.
  Transformer _last;

  /// Creates a new transformation attribute.
  TransAttr() {
    this._trans = new Transformer.identity();
    this._mul = true;
    this._last = null;
  }

  /// The transformation for this attribute.
  Transformer get transform => this._trans;
  set transform(Transformer trans) => this._trans = trans;

  /// The multiplier indicator.
  /// True indicates the transformation should be multiplied with
  /// the current transformation at that time, false to just set
  /// the transformation overriding the current one at that time.
  bool get multiply => this._mul;
  set multiply(bool mul) => this._mul = mul;

  /// Applies this transformation attribute, similar to pushing but while calculating the data bounds.
  Transformer apply(Transformer trans) {
    this._last = null;
    if (this._trans != null) {
      this._last = trans;
      return (this._mul) ? this._last.mul(this._trans) : this._trans;
    }
    return trans;
  }

  /// Un-applies this transformation attribute, similar as popping but while calculating the data bounds.
  Transformer unapply(Transformer trans) {
    if (this._last != null) {
      trans = this._last;
      this._last = null;
    }
    return trans;
  }

  /// Pushes the attribute to the renderer.
  void _pushAttr(IRenderer r) {
    this._last = null;
    if (this._trans != null) {
      this._last = r.transform;
      r.transform = (this._mul) ? this._last.mul(this._trans) : this._trans;
    }
  }

  /// Pops the attribute from the renderer.
  void _popAttr(IRenderer r) {
    if (this._last != null) {
      r.transform = this._last;
      this._last = null;
    }
  }
}
