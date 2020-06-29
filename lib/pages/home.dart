import 'package:flutter/material.dart';
import 'package:notebook/database/db.dart';
import 'package:notebook/models/note.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> notes = new List<Note>();
  DbHelper dbHelper = new DbHelper();

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  void getNotes() {
    var db = dbHelper.initalizeDb();
    db.then((result) {
      var noteFuture = dbHelper.getNotes();
      noteFuture.then((data) {
        List<Note> _notes = new List<Note>();
        for (int i = 0; i < data.length; i++) {
          _notes.add(Note.formObject(data[i]));
        }

        setState(() => notes = _notes);
      });
    });
  }

  void remove(int id, context) {
    dbHelper.remove(id);

    setState(() => notes);

    Fluttertoast.showToast(msg: 'Note deleted');
  }

  @override
  Widget build(BuildContext context) {
    getNotes();
    return Scaffold(
      appBar: AppBar(title: Text('Notebook'), centerTitle: true),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(notes[index].title + index.toString()),
            onDismissed: (direction) {
              print(notes[index].toMap());
              if (direction == DismissDirection.endToStart) {
                Navigator.pushNamed(
                  context,
                  '/update-note',
                  arguments: notes[index],
                );
              } else {
                remove(notes[index].id, context);
              }

              setState(() => notes.removeAt(index));
            },
            background: Card(
              color: Colors.red,
              child: ListTile(leading: Icon(Icons.delete, color: Colors.white)),
              elevation: 3.0,
            ),
            secondaryBackground: Card(
              color: Colors.green,
              child: ListTile(trailing: Icon(Icons.edit, color: Colors.white)),
              elevation: 3.0,
            ),
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text(notes[index].title),
                trailing: Text(
                  timeago.format(DateTime.parse(notes[index].date)),
                  style: TextStyle(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/create-note'),
      ),
    );
  }
}
