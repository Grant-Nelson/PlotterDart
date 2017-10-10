part of plotter;

/// A generic transformation between two coordinate systems.
///
/// Since there are many packages that the plotter could be used to
/// output to, such as opengl, svg, gnuplot, swing, etc., this is a
/// simple non-matrix transformation to reduce complexity and to keep consistent.
class Transformer {
  /// The x-axis scalar.
  double _xScalar;

  /// The y-axis scalar.
  double _yScalar;

  /// The x-axis post-scale offset.
  double _dx;

  /// The y-axis post-scale offset.
  double _dy;

  /// Creates a new identity transformer.
  Transformer.identity() {
    _xScalar = 1.0;
    _yScalar = 1.0;
    _dx = 0.0;
    _dy = 0.0;
  }

  /// Creates a new transformer.
  Transformer(this._xScalar, this._yScalar, this._dx, this._dy);

  /// Creates a copy of the given transformer.
  Transformer.copy(Transformer other) {
    _xScalar = other._xScalar;
    _yScalar = other._yScalar;
    _dx = other._dx;
    _dy = other._dy;
  }

  /// Resets the transformer to the identity.
  void reset() {
    _xScalar = 1.0;
    _yScalar = 1.0;
    _dx = 0.0;
    _dy = 0.0;
  }

  /// Sets the scalars of the transformation.
  /// The scalars should be positive and non-zero.
  void setScale(double xScalar, double yScalar) {
    this._xScalar = xScalar;
    this._yScalar = yScalar;
  }

  /// Gets the x-axis scalar.
  double get xScalar => _xScalar;

  /// Gets the y-axis scalar.
  double get yScalar => _yScalar;

  /// Sets the post-scalar offset.
  /// During a transformation the offset are added to the location after scaling, hence post-scalar.
  void setOffset(double dx, double dy) {
    _dx = dx;
    _dy = dy;
  }

  /// Gets the x-axis post-scalar offset.
  double get dx => _dx;

  /// Gets the y-axis post-scalar offset.
  double get dy => _dy;

  /// Creates a transformer which is the multiple of this transformer and the given transformer.
  // Transformers are not commutative when multiplying since they are coordinate transformations just like matrices.
  Transformer mul(Transformer trans) {
    return new Transformer(_xScalar * trans._xScalar, _yScalar * trans._yScalar,
        transformX(trans._dx), transformY(trans._dy));
  }

  /// Transforms a bounds from the source coordinate system into the destination coordinate system.
  Bounds transform(Bounds b) {
    if (b.isEmpty) return new Bounds.empty();
    return new Bounds(untransformX(b.xmin), untransformY(b.ymin),
        untransformX(b.xmax), untransformY(b.ymax));
  }

  /// Performs an inverse transformation on the given x value.
  double untransformX(double x) => (x - _dx) / _xScalar;

  /// Performs an inverse transformation on the given y value.
  double untransformY(double y) => (y - _dy) / _yScalar;

  /// Transforms the given x value from the source coordinate system into the destination coordinate system.
  /// First the value is scaled then translated with the offset.
  double transformX(double x) => x * _xScalar + _dx;

  /// Transforms the given y value from the source coordinate system into the destination coordinate system.
  /// First the value is scaled then translated with the offset.
  double transformY(double y) => y * _yScalar + _dy;
}
