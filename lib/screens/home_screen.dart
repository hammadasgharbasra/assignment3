import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../models/note.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DBHelper();
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final allNotes = await db.getNotes();
    setState(() {
      notes = allNotes;
    });
  }

  void _deleteNote(int id) async {
    await db.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved Locations")),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, i) {
          final note = notes[i];
          return ListTile(
            leading: note.imagePath.isNotEmpty ? Image.file(File(note.imagePath), width: 50) : null,
            title: Text(note.locationName),
            subtitle: Text(note.description),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: Icon(Icons.edit), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditNoteScreen(note: note))).then((_) => _loadNotes())),
              IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteNote(note.id!)),
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddNoteScreen())).then((_) => _loadNotes()),
        child: Icon(Icons.add),
      ),
    );
  }
}
