import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/note.dart';
import '../db_helper.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  final db = DBHelper();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.note.locationName;
    _descController.text = widget.note.description;
    if (widget.note.imagePath.isNotEmpty) {
      _image = File(widget.note.imagePath);
    }
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void _deleteImage() {
    setState(() {
      _image = null;
    });
  }

  void _saveChanges() async {
    final updatedNote = Note(
      id: widget.note.id,
      locationName: _nameController.text,
      description: _descController.text,
      imagePath: _image?.path ?? '',
    );

    await db.updateNote(updatedNote);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Note")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Location Name'),
          ),
          TextField(
            controller: _descController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(onPressed: _pickImage, child: Text("Change Image")),
              SizedBox(width: 10),
              if (_image != null)
                ElevatedButton(onPressed: _deleteImage, child: Text("Delete Image")),
            ],
          ),
          SizedBox(height: 10),
          if (_image != null) Image.file(_image!, height: 100),
          SizedBox(height: 10),
          ElevatedButton(onPressed: _saveChanges, child: Text("Save Changes")),
        ]),
      ),
    );
  }
}
