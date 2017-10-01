part of plotter;

/**
 * A simple color for plotting.
 * 
 * Since there are many packages that the plotter could be used to
 * output to, such as opengl, svg, gnuplot, swing, etc.,
 * this is a generic color is used to reduce complexity and keep consistent.
 */
class Color {
  
  // The red component for the color, 0 .. 1.
  double _red;

  // The green component for the color, 0 .. 1.
  double _green;

  // The blue component for the color, 0 .. 1.
  double _blue;
    
  /**
   * Creates a color.
   * @param red The red component for the color, 0 .. 1.
   * @param green The green component for the color, 0 .. 1.
   * @param blue The blue component for the color, 0 .. 1.
   */
  Color(double red, double green, double blue) {
    this._red = this._clamp(red);
    this._green = this._clamp(green);
    this._blue = this._clamp(blue);
  }
    
  /**
   * Sets the color to the given values.
   * @param red The red component for the color, 0 .. 1.
   * @param green The green component for the color, 0 .. 1.
   * @param blue The blue component for the color, 0 .. 1.
   */
  void set(double red, double green, double blue) {
    this._red = this._clamp(red);
    this._green = this._clamp(green);
    this._blue = this._clamp(blue);
  }
  
  /**
   * Gets the red component of the color.
   * @return The red component, 0 .. 1.
   */
  double red() {
    return this._red;
  }

  /**
   * Gets the green component of the color.
   * @return The green component, 0 .. 1.
   */
  double green() {
    return this._green;
  }

  /**
   * Gets the blue component of the color.
   * @return The blue component, 0 .. 1.
   */
  double blue() {
    return this._blue;
  }
  
  /**
   * Sets the red component of the color.
   * @param red The red component to set, 0 .. 1.
   */
  void setRed(double red) {
    this._red = this._clamp(red);
  }

  /**
   * Sets the green component of the color.
   * @param green The green component to set, 0 .. 1.
   */
  void setGreen(double green) {
    this._green = this._clamp(green);
  }

  /**
   * Sets the blue component of the color.
   * @param blue The blue component to set, 0 .. 1.
   */
  void setBlue(double blue) {
    this._blue = this._clamp(blue);
  }
  
  /**
   * Clamps a value to between 0 and 1 inclusively.
   * @param val The value to clamp.
   * @return The clamped value between 0 and 1 inclusively.
   */
  double _clamp(double val) {
    return (val > 1.0) ? 1.0 : ((val < 0.0) ? 0.0 : val);
  }
}
