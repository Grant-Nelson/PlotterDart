part of main;

/// The signature for handling changes to the boolean vlue.
typedef void OnBoolValueChange(bool newValue);

/// Boolean value handler for keeping track of changes in the UI and driver.
/// Kind of like a mini-store variable.
class BoolValue {
  bool _toggle;
  bool _value;
  List<OnBoolValueChange> _changed;

  /// Creates a new boolean value.
  /// [toggle] indicates if the value will changed to true when value is false
  /// and false when the value is true or if the value should only be set to true on click.
  BoolValue(bool toggle, [bool value = false]) {
    _toggle = toggle;
    _value = value;
    _changed = new List<OnBoolValueChange>();
  }

  /// Handles the value being clicked on.
  void onClick() {
    if (_toggle) {
      value = !_value;
    } else {
      value = true;
    }
  }

  /// Handles the value being set.
  void set value(bool value) {
    if (_value != value) {
      _value = value;
      for (OnBoolValueChange hndl in _changed) {
        hndl(_value);
      }
    }
  }

  /// Gets the currently set value.
  bool get value => _value;

  /// Gets the list of listeners who are watching for changes to this value.
  List<OnBoolValueChange> get onChange => _changed;
}
