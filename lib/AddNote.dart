// add_note_screen.dart

import 'package:flutter/material.dart';
import 'package:todo_app/NoteClass.dart';
import 'package:todo_app/Helper.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
//  TextEditingController IdController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
 // TextEditingController dueToController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /*TextField(
              controller:IdController,
              decoration: InputDecoration(labelText: 'Id'),
            ),*/
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
           /* TextField(
              controller: dueToController,
              decoration: InputDecoration(labelText: 'Due To'),
            ),*/
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Create a new note with the entered values
                Notes newNote = Notes(
             //     id: int.parse(IdController.text),
                  Notetitle: titleController.text,
                  NoteDescription: descriptionController.text,
                 // Dueto: DateTime.parse(dueToController.text),
                );
                print("Button Pressed");
                print("Title: ${titleController.text}");
                print("Description: ${descriptionController.text}");
             //   print("Due To: ${dueToController.text}");
                // Insert the new note into the database
                await DatabaseHelper.instance.insertNote(newNote);

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
