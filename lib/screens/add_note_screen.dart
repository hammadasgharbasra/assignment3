import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../db_helper.dart';
import '../models/note.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  final db = DBHelper();

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  void _saveNote() async {
    if (_image == null) return;
    final note = Note(
      locationName: _nameController.text,
      description: _descController.text,
      imagePath: _image!.path,
    );
    await db.insertNote(note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Location Note")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Location Name')),
          TextField(controller: _descController, decoration: InputDecoration(labelText: 'Description')),
          SizedBox(height: 10),
          ElevatedButton(onPressed: _pickImage, child: Text("Pick Image")),
          _image != null ? Image.file(_image!, height: 100) : Container(),
          SizedBox(height: 10),
          ElevatedButton(onPressed: _saveNote, child: Text("Save")),
        ]),
      ),
    );
  }
}
