part of plotter;

/// Mouse button state.
class MouseButtonState {
  /// The mouse button pressed.
  final int button;

  /// Indicates if the shift key is pressed.
  final bool shiftKey;

  /// Indicates if the control key is pressed.
  final bool ctrlKey;

  /// Indicates if the alt key is pressed.
  final bool altKey;

  /// Creates a new mouse button state.
  MouseButtonState(this.button, {this.shiftKey: false, this.ctrlKey: false, this.altKey: false});

  /// Determines if the given state is the same as this state.
  bool equals(MouseButtonState other) {
    return (this.button == other.button) &&
        (this.shiftKey == other.shiftKey) &&
        (this.ctrlKey == other.ctrlKey) &&
        (this.altKey == other.altKey);
  }
}

/// Mouse event arguments
class MouseEvent {
  /// The bounds for the client viewport.
  final Bounds window;

  /// Transformer for converting from graphics view coordinate system to screen coordinate system.
  final Transformer projection;

  /// X location of the mouse.
  final double x;

  /// Y location of the mouse.
  final double y;

  final MouseButtonState state;

  /// Indicates the plotter needs to be redrawn.
  bool _redraw;

  /// Creates a new mouse event arguments.
  MouseEvent(this.window, this.projection, this.x, this.y, this.state) {
    this._redraw = false;
  }

  /// Indicates if the plotter should be redrawn.
  bool get redraw => this._redraw;
  set redraw(bool draw) => this._redraw = draw;

  /// Gets the graphic coordinate system mouse x location.
  double get px => this.projection.untransformX(this.x);

  /// Gets the graphic coordinate system mouse y location.
  double get py => this.projection.untransformY(this.window.ymax - this.y);
}

/// A mouse handler for managing user input.
abstract class IMouseHandle {
  /// handles mouse down.
  void mouseDown(MouseEvent e);

  /// handles mouse moved.
  void mouseMove(MouseEvent e);

  /// handles mouse up.
  void mouseUp(MouseEvent e);
}
