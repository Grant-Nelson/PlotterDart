part of plotter;

/// A plotter item for coordinate based items.
abstract class BasicCoordsItem extends PlotterItem {
  /// The number of coordinate parts.
  final int _coordCount;

  /// The x coordinates for the points.
  List<List<double>> _coords;

  /// Creates a coordinate plotter item.
  BasicCoordsItem._(this._coordCount) {
    this._coords = new List<List<double>>();
    for (int i = 0; i < this._coordCount; i++) this._coords.add(new List<double>());
  }

  // Clears all the items.
  void clear() {
    for (int i = 0; i < this._coordCount; i++) this._coords[i].clear();
  }

  /// Adds values to the item.
  void add(List<double> val) {
    final int count = val.length;
    for (int i = 0; i < count; i += this._coordCount) {
      for (int j = 0; j < this._coordCount; j++) {
        this._coords[j].add(val[i + j]);
      }
    }
  }

  /// Sets the value to the item.
  void set(int index, List<double> val) {
    final int count = val.length;
    List<List<double>> coords = new List<List<double>>();
    for (int i = 0; i < this._coordCount; i++) coords.add(new List<double>());
    for (int i = 0; i < count; i += this._coordCount) {
      for (int j = 0; j < this._coordCount; j++) coords[j].add(val[i + j]);
    }
    for (int i = 0; i < this._coordCount; i++) this._coords[i].setAll(index, coords[i]);
  }

  /// Gets values from the item.
  List<double> get(int index, int count) {
    List<double> val = new List<double>();
    for (int i = 0; i < count; i++) {
      for (int j = 0; j < this._coordCount; j++) val.add(this._coords[j][index + i]);
    }
    return val;
  }

  /// The number of coordinate.
  int get count => this._coords[0].length;
}
