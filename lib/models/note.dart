class Note {
  int _id;
  String _title;
  String _description;
  String _date;

  Note(this._title, this._description, this._date);
  Note.withId(this._id, this._title, this._description, this._date);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map["title"] = _title;
    map["description"] = _description;
    map["date"] = _date;

    if (_id != null) map["id"] = _id;

    return map;
  }

  Note.formObject(dynamic o) {
    this._id = o["id"];
    this._title = o["title"];
    this._description = o["description"];
    this._date = o["date"];
  }
}
