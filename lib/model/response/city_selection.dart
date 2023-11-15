class CitySelection {
  String _name;
  bool _isSelect;
  int _id;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
  CitySelection(this._name, this._isSelect,this._id);

  bool get isSelect => _isSelect;

  set isSelect(bool value) {
    _isSelect = value;
  }
}