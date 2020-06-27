import 'package:flutter/material.dart';
import 'package:notebook/database/db.dart';
import 'package:notebook/models/note.dart';

class UpdateNote extends StatefulWidget {
  @override
  _UpdateNoteState createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  final _formKey = GlobalKey<FormState>();
  final _titleEditingController = TextEditingController();
  final _descriptionEditingController = TextEditingController();
  String dropdownValue = 'Low';
  DbHelper dbHelper = new DbHelper();
  Note note;

  @override
  void initState() {
    super.initState();

    note = ModalRoute.of(context).settings.arguments;

    _titleEditingController.text = note.title;
    _descriptionEditingController.text = note.description;
  }

  void update() {
    if (_formKey.currentState.validate()) {
      Note x = new Note.withId(
        note.id,
        _titleEditingController.text,
        _descriptionEditingController.text,
        note.date,
      );

      dbHelper.update(x);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notebook'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleEditingController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionEditingController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.keyboard_arrow_down),
                onChanged: (String newValue) {
                  setState(() => dropdownValue = newValue);
                },
                items: <String>['High', 'Medium', 'Low']
                    .map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 40),
              RaisedButton(
                child: Text("Update", style: TextStyle(fontSize: 17)),
                color: Colors.indigo,
                textColor: Colors.white,
                onPressed: update,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
