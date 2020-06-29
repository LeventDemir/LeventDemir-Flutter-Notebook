import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
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
  final picker = ImagePicker();
  DbHelper dbHelper = new DbHelper();
  String dropdownValue = 'Low';
  String _image;
  Note note;

  Future getImage() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() => _image = pickedFile.path);
  }

  Future<void> _showPhoto() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(child: Image.file(File(_image))),
        );
      },
    );
  }

  void update() {
    if (_formKey.currentState.validate()) {
      Note x = new Note.withId(
        note.id,
        _titleEditingController.text,
        _descriptionEditingController.text,
        _image,
        note.date,
      );

      dbHelper.update(x);

      Navigator.pop(context);

      Fluttertoast.showToast(msg: 'Note updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_formKey.currentState == null) {
      note = ModalRoute.of(context).settings.arguments;

      _titleEditingController.text = note.title;
      _descriptionEditingController.text = note.description;
      _image = note.photo;
    }
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
              OutlineButton(
                textColor: Colors.amber,
                highlightedBorderColor: Colors.amber,
                padding: EdgeInsets.symmetric(vertical: 8),
                borderSide: BorderSide(width: 2, color: Colors.amber),
                child: Icon(Icons.camera_alt),
                onPressed: getImage,
              ),
              _image == null
                  ? SizedBox(height: 0)
                  : Row(
                      children: [
                        GestureDetector(
                          child: Text(
                            'open image',
                            style: TextStyle(color: Colors.greenAccent),
                          ),
                          onTap: _showPhoto,
                        ),
                        Spacer(),
                        GestureDetector(
                          child: Text(
                            'remove image',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          onTap: () => setState(() => _image = null),
                        ),
                      ],
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
