part of plotter;

/**
 * A translation attribute for setting a special translation on some data.
 */
class TransAttr implements IAttribute {
  
    // The transformation to set.
    Transformer _trans;
    
    // True indicates the transformation should be multiplied with
    // the current transformation at that time, false to just set
    // the transformation overriding the current one at that time.
    bool _mul;
    
    // The previous transformation.
    Transformer _last;
    
    /**
     * Creates a new transformation attribute.
     */
    TransAttr() {
        this._trans = new Transformer.identity();
        this._mul = true;
        this._last = null;
    }
    
    /**
     * Gets the transformation for this attribute.
     * @return The transformer value.
     */
    Transformer transform() {
        return this._trans;
    }
    
    /**
     * Sets the transformation for this attribute.
     * @param trans The transformer value to set.
     */
    void setTransform(Transformer trans) {
        this._trans = trans;
    }
    
    /**
     * Gets the multiplier indicator.
     * @return True indicates the transformation should be multiplied with
     *         the current transformation at that time, false to just set
     *         the transformation overriding the current one at that time.
     */
    bool multiply() {
        return this._mul;
    }
    
    /**
     * Sets the multiplier indicator.
     * @param mul True indicates the transformation should be multiplied with
     *            the current transformation at that time, false to just set
     *            the transformation overriding the current one at that time.
     */
    void setMultiply(bool mul) {
        this._mul = mul;
    }

    /**
     * Applies this transformation attribute, similar to pushing but while calculating the data bounds. 
     * @param trans The current transformation.
     * @return The new transformation after this one is applied.
     */
    Transformer apply(Transformer trans) {
        this._last = null;
        if (this._trans != null) {
            this._last = trans;
            if (this._mul)
                return this._last.mul(this._trans);
            else return this._trans;
        }
        return trans;
    }

    /**
     * Un-applies this transformation attribute, similar as popping but while calculating the data bounds. 
     * @param trans The current transformation.
     * @return The previous transformation before this attribute was applied.
     */
    Transformer unapply(Transformer trans) {
        if (this._last != null) {
            trans = this._last;
            this._last = null;
        }
        return trans;
    }

    /**
     * Pushes the attribute to the renderer.
     * @param r The renderer to push to.
     */
    void _pushAttr(IRenderer r) {
        this._last = null;
        if (this._trans != null) {
            this._last = r.transform();
            if (this._mul)
                r.setTransform(this._last.mul(this._trans));
            else r.setTransform(this._trans);
        }
    }

    /**
     * Pops the attribute from the renderer.
     * @param r The renderer to pop from.
     */
    void _popAttr(IRenderer r) {
        if (this._last != null) {
            r.setTransform(this._last);
            this._last = null;
        }
    }
}
