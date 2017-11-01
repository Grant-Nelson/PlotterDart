part of plotter;

/// A mouse handler for translating the view port.
class MousePan implements iMouseHandle {
  /// The plotter this mouse handle is changing.
  Plotter _plot;

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
    _msx = 0.0;
    _msy = 0.0;
    _viewx = 0.0;
    _viewy = 0.0;
    _moveStarted = false;
  }

  /// handles mouse down.
  void mouseDown(MouseEvent e) {
    if (e.state.equals(_state)) {
      _viewx = _plot.view.dx;
      _viewy = _plot.view.dy;
      _msx = e.x;
      _msy = e.y;
      _moveStarted = true;
    }
  }

  /// Gets the change in the view x location.
  double _viewDX(MouseEvent e) {
    return _viewx + (e.x - _msx) / e.transformer.xScalar;
  }

  /// Gets the change in the view y location.
  double _viewDY(MouseEvent e) {
    return _viewy - (e.y - _msy) / e.transformer.yScalar;
  }

  /// handles mouse moved.
  void mouseMove(MouseEvent e) {
    if (_moveStarted) {
      _plot.setViewOffset(_viewDX(e), _viewDY(e));
      e.redraw = true;
    }
  }

  /// handles mouse up.
  void mouseUp(MouseEvent e) {
    if (_moveStarted) {
      _plot.setViewOffset(_viewDX(e), _viewDY(e));
      _moveStarted = false;
      e.redraw = true;
    }
  }
}
