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
    _trans = new Transformer.identity();
    _mul = true;
    _last = null;
  }

  /// The transformation for this attribute.
  Transformer get transform => _trans;
  set transform(Transformer trans) => _trans = trans;

  /// The multiplier indicator.
  /// True indicates the transformation should be multiplied with
  /// the current transformation at that time, false to just set
  /// the transformation overriding the current one at that time.
  bool get multiply => _mul;
  set multiply(bool mul) => _mul = mul;

  /// Applies this transformation attribute, similar to pushing but while calculating the data bounds.
  Transformer apply(Transformer trans) {
    _last = null;
    if (_trans != null) {
      _last = trans;
      if (_mul)
        return _last.mul(_trans);
      else
        return _trans;
    }
    return trans;
  }

  /// Un-applies this transformation attribute, similar as popping but while calculating the data bounds.
  Transformer unapply(Transformer trans) {
    if (_last != null) {
      trans = _last;
      _last = null;
    }
    return trans;
  }

  /// Pushes the attribute to the renderer.
  void _pushAttr(IRenderer r) {
    _last = null;
    if (_trans != null) {
      _last = r.transform;
      if (_mul)
        r.transform = _last.mul(_trans);
      else
        r.transform = _trans;
    }
  }

  /// Pops the attribute from the renderer.
  void _popAttr(IRenderer r) {
    if (_last != null) {
      r.transform = _last;
      _last = null;
    }
  }
}
