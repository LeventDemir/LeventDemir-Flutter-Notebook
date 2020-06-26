import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> notes = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notebook'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(notes[index]),
            onDismissed: (direction) {
              setState(() => notes.removeAt(index));

              if (direction == DismissDirection.endToStart) {
                Navigator.pushNamed(context, '/update-note');
              }
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
                title: Text('note title ${notes[index]}'),
                trailing: Text(
                  '01.10.2020 - 12.00',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
