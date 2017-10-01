part of plotter;

/**
 * An attribute for setting the fill color.
 */
class FillColorAttr extends IAttribute {

    // The color to set, or null for no fill.
    Color _color;
    
    // The last color in the renderer.
    Color _last;
    
    /**
     * Creates a fill color attribute.
     * @param red The red value of the color.
     * @param green The green value of the color.
     * @param blue The blue value of the color.
     */
    FillColorAttr(Color color) {
        this._color = color;
        this._last = null;
    }

    /**
     * Creates a fill color attribute.
     * @param red The red value of the color.
     * @param green The green value of the color.
     * @param blue The blue value of the color.
     */
    FillColorAttr.rgb(double red, double green, double blue) {
        this._color = new Color(red, green, blue);
        this._last = null;
    }

    /**
     * Gets the color to apply for this attribute.
     * @return The color to apply.
     */
    Color color() {
        return this._color;
    }
    
    /**
     * Sets the line color to apply.
     * @param color The color to apply.
     */
    void set(Color color) {
        this._color = color;
    }
    
    /**
     * Sets the color to apply.
     * @param red The red value of the color.
     * @param green The green value of the color.
     * @param blue The blue value of the color.
     */
    void setRgb(double red, double green, double blue) {
        this._color = new Color(red, green, blue);
    }
    
    /**
     * Sets the fill color to no fill.
     */
    void clear() {
        this._color = null;
    }

    /**
     * Pushes the attribute to the renderer.
     * @param r The renderer to push to.
     */
    void _pushAttr(IRenderer r) {
        this._last = r.getFillColor();
        r.setFillColor(this._color);
    }

    /**
     * Pops the attribute from the renderer.
     * @param r The renderer to pop from.
     */
    void _popAttr(IRenderer r) {
        r.setFillColor(this._last);
        this._last = null;
    }
}
