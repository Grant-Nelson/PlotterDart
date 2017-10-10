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
    _empty = true;
    _xmin = _ymin = _xmax = _ymax = 0.0;
  }

  /// Creates a new boundary for data.
  Bounds(this._xmin, this._ymin, this._xmax, this._ymax) {
    _empty = false;
  }

  /// Indicates if the bounds are empty.
  bool get isEmpty => _empty;

  /// Gets the minimum x of the bounds.
  double get xmin => _xmin;

  /// Gets the minimum y of the bounds.
  double get ymin => _ymin;

  /// Gets the maximum x of the bounds.
  double get xmax => _xmax;

  /// Gets the maximum y of the bounds.
  double get ymax => _ymax;

  /// Gets the width of the bounds.
  double get width => _xmax - _xmin;

  /// Gets the height of the bounds.
  double get height => _ymax - _ymin;

  /// Expands the bounds to include the given point.
  void expand(double x, double y) {
    if (_empty) {
      _empty = false;
      _xmin = _xmax = x;
      _ymin = _ymax = y;
    } else {
      if (_xmin > x) _xmin = x;
      if (_ymin > y) _ymin = y;
      if (_xmax < x) _xmax = x;
      if (_ymax < y) _ymax = y;
    }
  }

  /// Unions the other bounds into this bounds.
  void union(Bounds bounds) {
    if (_empty) {
      _empty = bounds._empty;
      _xmin = bounds._xmin;
      _ymin = bounds._ymin;
      _xmax = bounds._xmax;
      _ymax = bounds._ymax;
    } else {
      if (!bounds._empty) {
        if (_xmin > bounds._xmin) _xmin = bounds._xmin;
        if (_ymin > bounds._ymin) _ymin = bounds._ymin;
        if (_xmax < bounds._xmax) _xmax = bounds._xmax;
        if (_ymax < bounds._ymax) _ymax = bounds._ymax;
      }
    }
  }

  /// Gets the string of the bounds.
  String toString() => _empty ? "[empty]" : "[$_xmin, $_ymin, $_xmax, $_ymax]";
}
