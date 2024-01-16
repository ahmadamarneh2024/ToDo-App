// add_note_screen.dart

import 'package:flutter/material.dart';
import 'package:todo_app/NoteClass.dart';
import 'package:todo_app/Helper.dart';
import 'package:todo_app/main.dart';

class AddNoteScreen extends StatefulWidget {
  final VoidCallback onNoteAdded;

  const AddNoteScreen({Key? key, required this.onNoteAdded}) : super(key: key);


  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isUrgent = false; // New boolean for Urgent
  Future<void> _saveNote() async {
    // Save the note to the database

    // Call the onNoteAdded callback to trigger a refresh in AllNotesPage
    widget.onNoteAdded();

    // Close the screen
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... existing code ...

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            CheckboxListTile(
              title: Text('Urgent'),
              value: isUrgent,
              onChanged: (value) {
                setState(() {
                  isUrgent = value ?? false;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Create a new note with the entered values
                Notes newNote = Notes(
                  Notetitle: titleController.text,
                  NoteDescription: descriptionController.text,
                  urgent: isUrgent,
                );

                // Insert the new note into the database
                await DatabaseHelper.instance.insertNote(newNote);

                // Trigger the onNoteAdded callback to refresh the UI in AllNotesPage
                widget.onNoteAdded();

                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
