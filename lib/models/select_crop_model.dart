class Crop {
  late String id;
  late String engName;
  late String bdName;
  late String icon;
  late bool selected;

  Crop.empty() {
    id = "";
    engName = "";
    bdName = "";
    icon = "";
    selected = false;
  }

  Crop(this.id, this.engName, this.bdName, this.icon, this.selected);
}
