part of plotter;

/**
 * A boundary of data.
 */
class Bounds {

  // Indicate the bounds are empty.
  bool _empty;

  // The minimum x of the bounds.
  double _xmin;

  // The minimum y of the bounds.
  double _ymin;

  // The maximum x of the bounds.
  double _xmax;

  // The maximum y of the bounds.
  double _ymax;

  /**
   * Creates a new empty bounds.
   */
  Bounds.empty() {
    this._empty = true;
    this._xmin = 0.0;
    this._ymin = 0.0;
    this._xmax = 0.0;
    this._ymax = 0.0;
  }

  /**
   * Creates a new boundary for data.
   * @param xmin The minimum x of the bounds.
   * @param ymin The minimum y of the bounds.
   * @param xmax The maximum x of the bounds.
   * @param ymax The maximum y of the bounds.
   */
  Bounds(double xmin, double ymin, double xmax, double ymax) {
    this._empty = false;
    this._xmin = xmin;
    this._ymin = ymin;
    this._xmax = xmax;
    this._ymax = ymax;
  }

  /**
   * Indicates if the bounds are empty.
   * @return True if empty, false otherwise.
   */
  bool isEmpty() {
    return this._empty;
  }

  /**
   * Gets the minimum x of the bounds.
   * @return The minimum x of the bounds.
   */
  double xmin() {
    return this._xmin;
  }

  /**
   * Gets the minimum y of the bounds.
   * @return The minimum y of the bounds.
   */
  double ymin() {
    return this._ymin;
  }

  /**
   * Gets the maximum x of the bounds.
   * @return The maximum x of the bounds.
   */
  double xmax() {
    return this._xmax;
  }

  /**
   * Gets the maximum y of the bounds.
   * @return The maximum y of the bounds.
   */
  double ymax() {
    return this._ymax;
  }

  /**
   * Gets the width of the bounds.
   * @return The width of the bounds.
   */
  double width() {
    return this._xmax - this._xmin;
  }

  /**
   * Gets the height of the bounds.
   * @return The height of the bounds.
   */
  double height() {
    return this._ymax - this._ymin;
  }

  /**
   * Expands the bounds to include the given point.
   * @param x The x component of the point to add.
   * @param y The y component of the point to add.
   */
  void expand(double x, double y) {
    if (this._empty) {
      this._empty = false;
      this._xmin = x;
      this._ymin = y;
      this._xmax = x;
      this._ymax = y;
    } else {
      if (this._xmin > x) this._xmin = x;
      if (this._ymin > y) this._ymin = y;
      if (this._xmax < x) this._xmax = x;
      if (this._ymax < y) this._ymax = y;
    }
  }

  /**
   * Unions the other bounds into this bounds.
   * @param bounds The bounds to union into this one.
   */
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

  /**
   * Gets the string of the bounds.
   * @return The bound's string.
   */
  String toString() {
    if (this._empty) {
      return "[empty]";
    } else {
      return "[$this._xmin, $this._ymin, $this._xmax, $this._ymax]";
    }
  }
}
