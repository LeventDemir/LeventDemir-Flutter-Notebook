import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notebook/database/db.dart';
import 'package:notebook/models/note.dart';
import 'package:image_picker/image_picker.dart';

class CreateNote extends StatefulWidget {
  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final _formKey = GlobalKey<FormState>();
  final _titleEditingController = TextEditingController();
  final _descriptionEditingController = TextEditingController();
  final picker = ImagePicker();
  String _image;

  Future<void> _showPhotoSources() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                FlatButton(
                  child: Text('Camera'),
                  onPressed: () => getImage(ImageSource.camera),
                ),
                FlatButton(
                  child: Text('Gallery'),
                  onPressed: () => getImage(ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getImage(source) async {
    Navigator.pop(context);

    PickedFile pickedFile = await picker.getImage(source: source);

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

  void create() {
    if (_formKey.currentState.validate()) {
      DbHelper dbHelper = new DbHelper();

      Note note = new Note(
        _titleEditingController.text,
        _descriptionEditingController.text,
        _image,
        DateTime.now().toIso8601String(),
      );

      dbHelper.save(note);

      Navigator.pop(context);

      Fluttertoast.showToast(msg: 'Note created');
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
              SizedBox(height: 20),
              OutlineButton(
                highlightedBorderColor: Colors.amber,
                textColor: Colors.amber,
                padding: EdgeInsets.symmetric(vertical: 8),
                borderSide: BorderSide(width: 2, color: Colors.amber),
                child: Icon(Icons.camera_alt),
                onPressed: _showPhotoSources,
              ),
              SizedBox(height: 5),
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
                child: Text("Create", style: TextStyle(fontSize: 17)),
                color: Colors.indigo,
                textColor: Colors.white,
                onPressed: create,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
