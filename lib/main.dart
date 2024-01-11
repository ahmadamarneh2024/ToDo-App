// main.dart

import 'package:flutter/material.dart';
import 'package:todo_app/NoteClass.dart';
import 'package:todo_app/Helper.dart';
import 'AddNote.dart';  // Import the AddNoteScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Ensure database is initialized
    await DatabaseHelper.instance.database;
    print("Database initialized successfully.");
  } catch (e) {
    print("Error initializing database: $e");
  }

  runApp(const NavigationBarApp());
}
class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
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
        title: Text("ToDo App"),
        centerTitle: true,
        actions: [
          if (currentPageIndex == 0)
            IconButton(
              onPressed: () {
                // Navigate to the AddNoteScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNoteScreen()),
                );
              },
              icon: Icon(Icons.add),
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
      future: notesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
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

class CompletedNotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Completed Notes Page'),
    );
  }
}