class Cell {
  final int i;
  final int j;
  var _value = 0;

  int get value => _value;

  Cell(this.i, this.j);

  setValue(int v) {
    _value = v;
  }
}
