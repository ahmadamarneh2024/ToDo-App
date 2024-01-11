import 'package:flutter/material.dart';
import 'package:todo_app/NoteClass.dart';
import 'package:todo_app/Helper.dart';
import 'package:todo_app/main.dart';
import 'AddNote.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Ensure database is initialized
    await DatabaseHelper.instance.database;
    print("Database initialized successfully.");
  } catch (e) {
    print("Error initializing database: $e");
  }

  runApp(MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: const NavigationExample(),
  ));
}
class NavigationExample extends StatefulWidget {
  const NavigationExample({Key? key}) : super(key: key);

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo App"),
        centerTitle: true,
        actions: [
          if (currentPageIndex == 0)
            IconButton(
              onPressed: () {
                // Navigate to the AddNoteScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNoteScreen()),
                );
              },
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blueGrey,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.note),
            label: 'All',
          ),
          NavigationDestination(
            icon: Icon(Icons.task),
            label: 'Completed',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: <Widget>[
          AllNotesPage(),
          CompletedNotesPage(),
        ],
      ),
    );
  }
}

class AllNotesPage extends StatefulWidget {
  const AllNotesPage({Key? key}) : super(key: key);

  @override
  _AllNotesPageState createState() => _AllNotesPageState();
}

class _AllNotesPageState extends State<AllNotesPage> {
  Future<List<Notes>>? notesFuture;

  @override
  void initState() {
    super.initState();
    notesFuture = loadAllNotes();
  }

  Future<List<Notes>> loadAllNotes() async {
    List<Notes> allNotes = await DatabaseHelper.instance.getAllNotes();
    return allNotes;
  }

  @override
  void didUpdateWidget(covariant AllNotesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload notes when the widget is updated
    notesFuture = loadAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Notes>>(
        key: UniqueKey(),
        future: notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Notes> notes = snapshot.data ?? [];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    for (var note in notes)
                      Card(
                        child: ListTile(
                          title: Text(note.Notetitle),
                          subtitle: Text(note.NoteDescription),
                          onTap: () {
                            // Show dialog to ask the user to set note as completed
                            showConfirmationDialog(note);
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Delete the note when the delete button is pressed
                              deleteNoteAndReload(note);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
        });
  }

  Future<void> showConfirmationDialog(Notes note) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Note as Completed?'),
          content: Text('Do you want to set this note as completed?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Toggle completion status of the note and reload
                toggleNoteCompletionStatusAndReload(note);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Set Completed'),
            ),
          ],
        );
      },
    );
  }

  Future<void> toggleNoteCompletionStatusAndReload(Notes note) async {
    if (note.id != null) {
      // Toggle completion status of the note in the database
      await DatabaseHelper.instance.toggleNoteCompletionStatus(note.id!);

      // Reload notes
      setState(() {
        notesFuture = loadAllNotes();
      });
    }
  }

  Future<void> deleteNoteAndReload(Notes note) async {
    if (note.id != null) {
      // Delete the note from the database
      await DatabaseHelper.instance.deleteNote(note.id!);

      // Reload notes
      setState(() {
        notesFuture = loadAllNotes();
      });
    }
  }
}
class CompletedNotesPage extends StatelessWidget {
  const CompletedNotesPage({Key? key}) : super(key: key);

  Future<List<Notes>> loadCompletedNotes() async {
    List<Notes> allNotes = await DatabaseHelper.instance.getAllNotes();
    return allNotes.where((note) => note.completed).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Notes>>(
      future: loadCompletedNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Notes> completedNotes = snapshot.data ?? [];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  for (var note in completedNotes)
                    Card(
                      child: ListTile(
                        title: Text(note.Notetitle),
                        subtitle: Text(note.NoteDescription),
                        // Additional widgets or customization for completed notes
                      ),
                    ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}