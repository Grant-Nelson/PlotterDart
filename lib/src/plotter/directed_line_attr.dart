part of plotter;

/**
 * An attribute for setting if the line is directed or not.
 */
class DirectedLineAttr implements IAttribute {

    // The directed line flag to set.
    bool _directed;

    // The last directed line flag in the renderer.
    bool _last;

    /**
     * Creates a directed line flag attribute.
     * @param directed The initial directed line flag.
     */
    DirectedLineAttr([bool directed = true]) {
        this._directed = directed;
        this._last = false;
    }

    /**
     * Gets the directed line flag to apply for this attribute.
     * @return The directed line flag to apply.
     */
    bool directed() {
        return this._directed;
    }

    /**
     * Sets the directed line flag to apply.
     * @param directed The directed line flag to apply.
     */
    void set(bool directed) {
        this._directed = directed;
    }

    /**
     * Pushes the attribute to the renderer.
     * @param r The renderer to push to.
     */
    void _pushAttr(IRenderer r) {
        this._last = r.getDirectedLines();
        r.setDirectedLines(this._directed);
    }

    /**
     * Pops the attribute from the renderer.
     * @param r The renderer to pop from.
     */
    void _popAttr(IRenderer r) {
        r.setDirectedLines(this._last);
        this._last = false;
    }
}
