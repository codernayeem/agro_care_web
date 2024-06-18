class MyAgriOption {
  late String id;
  late String name;
  late bool selected;

  MyAgriOption.empty() {
    id = "";
    name = "";
    selected = false;
  }

  MyAgriOption(this.id, this.name, this.selected);
}
