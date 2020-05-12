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
    this._xScalar = 1.0;
    this._yScalar = 1.0;
    this._dx = 0.0;
    this._dy = 0.0;
  }

  /// Creates a new transformer.
  Transformer(this._xScalar, this._yScalar, this._dx, this._dy) {
    assert(this._xScalar > 0.0);
    assert(this._yScalar > 0.0);
  }

  /// Creates a copy of the given transformer.
  Transformer.copy(Transformer other) {
    this._xScalar = other._xScalar;
    this._yScalar = other._yScalar;
    this._dx = other._dx;
    this._dy = other._dy;
  }

  /// Resets the transformer to the identity.
  void reset() {
    this._xScalar = 1.0;
    this._yScalar = 1.0;
    this._dx = 0.0;
    this._dy = 0.0;
  }

  /// Sets the scalars of the transformation.
  /// The scalars should be positive and non-zero.
  void setScale(double xScalar, double yScalar) {
    this._xScalar = xScalar;
    this._yScalar = yScalar;
    assert(this._xScalar > 0.0);
    assert(this._yScalar > 0.0);
  }

  /// Gets the x-axis scalar.
  double get xScalar => this._xScalar;

  /// Gets the y-axis scalar.
  double get yScalar => this._yScalar;

  /// Sets the post-scalar offset.
  /// During a transformation the offset are added to the location after scaling, hence post-scalar.
  void setOffset(double dx, double dy) {
    this._dx = dx;
    this._dy = dy;
  }

  /// Gets the x-axis post-scalar offset.
  double get dx => this._dx;

  /// Gets the y-axis post-scalar offset.
  double get dy => this._dy;

  /// Creates a transformer which is the multiple of this transformer and the given transformer.
  // Transformers are not commutative when multiplying since they are coordinate transformations just like matrices.
  Transformer mul(Transformer trans) => new Transformer(
    this._xScalar * trans._xScalar, this._yScalar * trans._yScalar,
    this.transformX(trans._dx), this.transformY(trans._dy));

  /// Transforms a bounds from the source coordinate system into the destination coordinate system.
  Bounds transform(Bounds b) {
    if (b.isEmpty) return new Bounds.empty();
    return new Bounds(
      this.untransformX(b.xmin), this.untransformY(b.ymin),
      this.untransformX(b.xmax), this.untransformY(b.ymax));
  }

  /// Performs an inverse transformation on the given x value.
  double untransformX(double x) => (x - this._dx) / this._xScalar;

  /// Performs an inverse transformation on the given y value.
  double untransformY(double y) => (y - this._dy) / this._yScalar;

  /// Transforms the given x value from the source coordinate system into the destination coordinate system.
  /// First the value is scaled then translated with the offset.
  double transformX(double x) => x * this._xScalar + this._dx;

  /// Transforms the given y value from the source coordinate system into the destination coordinate system.
  /// First the value is scaled then translated with the offset.
  double transformY(double y) => y * this._yScalar + this._dy;
}
