part of plotter;

/**
 * The interface for all attributes.
 */
abstract class IAttribute {
    
    /**
     * Pushes the attribute to the renderer.
     * @param r The renderer to push to.
     */
    void _pushAttr(IRenderer r);
    
    /**
     * Pops the attribute from the renderer.
     * @param r The renderer to pop from.
     */
    void _popAttr(IRenderer r);
}
