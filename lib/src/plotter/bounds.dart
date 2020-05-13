part of plotter;

/// A boundary of data.
class Bounds {
  /// Indicate the bounds are empty.
  bool _empty;

  /// The minimum x of the bounds.
  double _xmin;

  /// The minimum y of the bounds.
  double _ymin;

  /// The maximum x of the bounds.
  double _xmax;

  /// The maximum y of the bounds.
  double _ymax;

  /// Creates a new empty bounds.
  Bounds.empty() {
    this._empty = true;
    this._xmin = this._ymin = this._xmax = this._ymax = 0.0;
  }

  /// Creates a new boundary for data.
  Bounds(this._xmin, this._ymin, this._xmax, this._ymax) {
    this._empty = false;
  }

  /// Indicates if the bounds are empty.
  bool get isEmpty => this._empty;

  /// Gets the minimum x of the bounds.
  double get xmin => this._xmin;

  /// Gets the minimum y of the bounds.
  double get ymin => this._ymin;

  /// Gets the maximum x of the bounds.
  double get xmax => this._xmax;

  /// Gets the maximum y of the bounds.
  double get ymax => this._ymax;

  /// Gets the width of the bounds.
  double get width => this._xmax - this._xmin;

  /// Gets the height of the bounds.
  double get height => this._ymax - this._ymin;

  /// Expands the bounds to include the given point.
  void expand(double x, double y) {
    if (this._empty) {
      this._empty = false;
      this._xmin = this._xmax = x;
      this._ymin = this._ymax = y;
    } else {
      if (this._xmin > x) this._xmin = x;
      if (this._ymin > y) this._ymin = y;
      if (this._xmax < x) this._xmax = x;
      if (this._ymax < y) this._ymax = y;
    }
  }

  /// Unions the other bounds into this bounds.
  void union(Bounds bounds) {
    if (this._empty) {
      this._empty = bounds._empty;
      this._xmin = bounds._xmin;
      this._ymin = bounds._ymin;
      this._xmax = bounds._xmax;
      this._ymax = bounds._ymax;
    } else {
      if (!bounds._empty) {
        if (this._xmin > bounds._xmin) this._xmin = bounds._xmin;
        if (this._ymin > bounds._ymin) this._ymin = bounds._ymin;
        if (this._xmax < bounds._xmax) this._xmax = bounds._xmax;
        if (this._ymax < bounds._ymax) this._ymax = bounds._ymax;
      }
    }
  }

  /// Gets the string of the bounds.
  String toString() => this._empty ? "[empty]" :
    "[${this._xmin}, ${this._ymin}, ${this._xmax}, ${this._ymax}]";
}
