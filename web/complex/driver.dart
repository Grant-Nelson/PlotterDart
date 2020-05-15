part of main;


class Driver {
  plotter.IPlot _plotOut;
  plotter.Plotter _plot;

  BoolValue _centerView;
  BoolValue _panView;
  BoolValue _addPoints;
  BoolValue _clearAll;

  Driver(this._plotOut) {
    this._plot = this._plotOut.plotter;
    this._centerView = new BoolValue(false)..onChange.add(_onCenterViewChange);
    this._panView = new BoolValue(true)..onChange.add(_onPanViewChange);
    this._addPoints = new BoolValue(false)..onChange.add(_onAddPointsChange);
    this._clearAll = new BoolValue(false)..onChange.add(_onClearAllChange);
  }

  BoolValue get centerView => this._centerView;
  BoolValue get panView => this._panView;
  BoolValue get addPoints => this._addPoints;
  BoolValue get clearAll => this._clearAll;

  void _onCenterViewChange(bool value) {
    if (value) {
      this._centerView.value = false;
      this._plot.updateBounds();
      this._plot.focusOnData();
      this._plotOut.refresh();
    }
  }
  
  void _onPanViewChange(bool value) {
  }

  void _onAddPointsChange(bool value) {
  }
  
  void _onClearAllChange(bool value) {
  }

}
