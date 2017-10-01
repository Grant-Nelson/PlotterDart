part of plotter;

/**
 * An attribute for setting the point size.
 */
class PointSizeAttr extends IAttribute {
  
    // The size of the point to set.
    double _size;
    
    // The previous size of the point to store.
    double _last;
    
    /**
     * Creates a new point size attribute.
     * @param size The point size to set.
     */
    PointSizeAttr(double size) {
        this._size = size;
        this._last = 0.0;
    }

    /**
     * Gets the size of the point for this attribute.
     * @return The point size.
     */
    double size() {
        return this._size;
    }
    
    /**
     * Sets the size of the point for this attribute.
     * @param size The point size to set.
     */
    void setSize(double size) {
        this._size = size;
    }

    /**
     * Pushes the attribute to the renderer.
     * @param r The renderer to push to.
     */
    void _pushAttr(IRenderer r) {
        this._last = r.pointSize();
        r.setPointSize(this._size);
    }

    /**
     * Pops the attribute from the renderer.
     * @param r The renderer to pop from.
     */
    void _popAttr(IRenderer r) {
        r.setPointSize(this._last);
    }
}
