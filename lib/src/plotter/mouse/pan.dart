part of plotter;

/// A mouse handler for translating the view port.
class MousePan implements IMouseHandle {
  /// The plotter this mouse handle is changing.
  Plotter _plot;

  /// Indicates if mouse panning is enabled or not.
  bool _enabled;

  /// The mouse button pressed.
  final MouseButtonState _state;

  /// The initial mouse x location on a mouse pressed.
  double _msx;

  /// The initial mouse y location on a mouse pressed.
  double _msy;

  /// The initial view x offset on a mouse pressed.
  double _viewx;

  /// The initial view y offset on a mouse pressed.
  double _viewy;

  /// True indicates a mouse move has been started.
  bool _moveStarted;

  /// Creates a new mouse pan handler.
  MousePan(this._plot, this._state) {
    this._enabled = true;
    this._msx = 0.0;
    this._msy = 0.0;
    this._viewx = 0.0;
    this._viewy = 0.0;
    this._moveStarted = false;
  }

  /// Indicates of the mouse panning is enabled or not.
  bool get enabled => this._enabled;
  set enabled(bool value) => this._enabled = value;

  /// handles mouse down.
  void mouseDown(MouseEvent e) {
    if (this._enabled && e.state.equals(this._state)) {
      this._viewx = this._plot.view.dx;
      this._viewy = this._plot.view.dy;
      this._msx = e.x;
      this._msy = e.y;
      this._moveStarted = true;
    }
  }

  /// Gets the change in the view x location.
  double _viewDX(MouseEvent e) =>
    this._viewx + (e.x - this._msx) / e.projection.xScalar;

  /// Gets the change in the view y location.
  double _viewDY(MouseEvent e) =>
    this._viewy - (e.y - this._msy) / e.projection.yScalar;

  /// handles mouse moved.
  void mouseMove(MouseEvent e) {
    if (this._moveStarted) {
      this._plot.setViewOffset(this._viewDX(e), this._viewDY(e));
      e.redraw = true;
    }
  }

  /// handles mouse up.
  void mouseUp(MouseEvent e) {
    if (_moveStarted) {
      this._plot.setViewOffset(this._viewDX(e), this._viewDY(e));
      this._moveStarted = false;
      e.redraw = true;
    }
  }
}
