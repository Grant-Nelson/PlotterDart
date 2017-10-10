part of plotter;

/// The interface for all attributes.
abstract class IAttribute {
  /// Pushes the attribute to the renderer.
  void _pushAttr(IRenderer r);

  /// Pops the attribute from the renderer.
  void _popAttr(IRenderer r);
}
