part of plotter;

/**
 * A generic transformation between two coordinate systems.
 * 
 * Since there are many packages that the plotter could be used to
 * output to, such as opengl, svg, gnuplot, swing, etc., this is a
 * simple non-matrix transformation to reduce complexity and to keep consistent.
 */
class Transformer {
  
    // The x-axis scalar.
    double _xScalar;
    
    // The y-axis scalar.
    double _yScalar;
    
    // The x-axis post-scale offset.
    double _dx;

    // The y-axis post-scale offset.
    double _dy;
    
    /**
     * Creates a new identity transformer.
     */
    Transformer.identity() {
        this._xScalar = 1.0;
        this._yScalar = 1.0;
        this._dx = 0.0;
        this._dy = 0.0;
    }

    /**
     * Creates a new transformer.
     * @param xScalar The initial x-axis scalar.
     * @param yScalar The initial y-axis scalar.
     * @param dx The initial x-axis post-scale offset.
     * @param dy The initial y-axis post-scale offset.
     */
    Transformer(this._xScalar, this._yScalar, this._dx, this._dy);
    
    /**
     * Creates a copy of the given transformer.
     * @param other The other transformer to copy.
     */
    Transformer.copy(Transformer other) {
        this._xScalar = other._xScalar;
        this._yScalar = other._yScalar;
        this._dx = other._dx;
        this._dy = other._dy;
    }
    
    /**
     * Resets the transformer to the identity.
     */
    void reset() {
        this._xScalar = 1.0;
        this._yScalar = 1.0;
        this._dx = 0.0;
        this._dy = 0.0;
    }
    
    /**
     * Sets the scalars of the transformation.
     * The scalars should be positive and non-zero.
     * @param xScalar The x-axis scalar to set.
     * @param yScalar The y-axis scalar to set.
     */
    void setScale(double xScalar, double yScalar) {
        this._xScalar = xScalar;
        this._yScalar = yScalar;
    }

    /**
     * Gets the x-axis scalar.
     * @return The x-axis scalar.
     */
    double xScalar() {
        return this._xScalar;
    }

    /**
     * Gets the y-axis scalar.
     * @return The y-axis scalar.
     */
    double yScalar() {
        return this._yScalar;
    }
    
    /**
     * Sets the post-scalar offset.
     * During a transformation the offset are added to the location after scaling, hence post-scalar.
     * @param dx The x-axis offset to set.
     * @param dy The y-axis offset to set.
     */
    void setOffset(double dx, double dy) {
        this._dx = dx;
        this._dy = dy;
    }
    
    /**
     * Gets the x-axis post-scalar offset.
     * @return The x-axis offset.
     */
    double dx() {
        return this._dx;
    }

    /**
     * Gets the y-axis post-scalar offset.
     * @return The y-axis offset.
     */
    double dy() {
        return this._dy;
    }
    
    /**
     * Creates a transformer which is the multiple of this transformer and the given transformer.
     * Transformers are not commutative when multiplying since they are coordinate transformations just like matrices.
     * @param trans The other transformer in the multiplication.
     * @return The product of the two transformers.
     */
    Transformer mul(Transformer trans) {
        return new Transformer(
            this._xScalar*trans._xScalar,
            this._yScalar*trans._yScalar,
                this.transformX(trans._dx),
                this.transformY(trans._dy));
    }
    
    /**
     * Transforms a bounds from the source coordinate system into the destination coordinate system.
     * @param b The bounds in the source coordinate system to transform.
     * @return The transformed bounds in the destination coordinate system.
     */
    Bounds transform(Bounds b) {
        if (b.isEmpty()) return new Bounds.empty();
        return new Bounds(
            untransformX(b.xmin()),
            untransformY(b.ymin()),
                untransformX(b.xmax()),
                untransformY(b.ymax()));
    }
    
    /**
     * Performs an inverse transformation on the given x value.
     * @param x The x value in the destination coordinate system to un-transform.
     * @return The x value in the source coordinate system.
     */
    double untransformX(double x) {
        return (x-this._dx)/this._xScalar;
    }

    /**
     * Performs an inverse transformation on the given y value.
     * @param y The y value in the destination coordinate system to un-transform.
     * @return The y value in the source coordinate system.
     */
    double untransformY(double y) {
        return (y-this._dy)/this._yScalar;
    }
    
    /**
     * Transforms the given x value from the source coordinate system into the destination coordinate system.
     * First the value is scaled then translated with the offset.
     * @param x The x value in the source coordinate system to transform.
     * @return The transformed x value in the destination coordinate system.
     */
    double transformX(double x) {
        return x*this._xScalar + this._dx;
    }

    /**
     * Transforms the given y value from the source coordinate system into the destination coordinate system.
     * First the value is scaled then translated with the offset.
     * @param y The y value in the source coordinate system to transform.
     * @return The transformed y value in the destination coordinate system.
     */
    double transformY(double y) {
        return y*this._yScalar + this._dy;
    }
}
