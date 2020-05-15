part of plotter;

/// Implementations of the plot output should at minimum implement
/// this abstract class so that the plot output can be easily swapped out.
abstract class IPlot {

  /// Refreshes the render.
  void refresh();

  /// Gets the plotter to render.
  Plotter get plotter;
}
