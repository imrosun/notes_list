import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todolist/auth/auth_service.dart';
import 'package:todolist/pages/login_screen.dart';
import 'package:todolist/todo/note_database.dart';
import 'package:todolist/todo/note.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // notes db
  final notesDatabase = NoteDatabase();

  // text controller
  final noteController = TextEditingController();

  final authService = AuthService();

  // Logout method
  void logout() async {
    await authService.signOut();
    // Navigate back to login page after logout
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  final _textController = TextEditingController();

  // Supabase client instance shortcut
  final _supabase = Supabase.instance.client;

  // Stream of notes from Supabase
  late final Stream<List<Map<String, dynamic>>> _notesStream;

  @override
  void initState() {
    super.initState();

    // Initialize the notes stream with primary key for real-time updates
    _notesStream = _supabase.from('notes').stream(primaryKey: ['id']);
  }

  // Show dialog to add a new note
  void _addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Note'),
        content: TextField(
          controller: _textController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter note content',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _textController.clear();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final text = _textController.text.trim();
              if (text.isNotEmpty) {
                await _saveNote(text);
              }
              Navigator.pop(context);
              _textController.clear();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Insert note into Supabase
  Future<void> _saveNote(String content) async {
    try {
      await _supabase.from('notes').insert({'content': content});
    } catch (e) {
      // Handle error, e.g. show snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add note: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // user wants to add new note
  // void addNewNote() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("New Note"),
  //       content: TextField(
  //         controller: noteController,
  //       ),
  //       actions: [
  //         // cancel button
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             noteController.clear();
  //           },
  //           child: const Text("Cancel"),
  //         ), // TextButton

  //         // save button
  //         TextButton(
  //           onPressed: () {
  //             // create a new note
  //             final newNote = Note(content: noteController.text);
  //             // save in db
  //             notesDatabase.createNote(newNote);
  //             Navigator.pop(context);
  //             noteController.clear();
  //           },
  //           child: const Text("Save"),
  //         ), // TextButton
  //       ],
  //     ), // AlertDialog
  //   );
  // }

  // user wants to update note
  void updateNote(Note note) {
    // pre-fill text controller with exisiting one
    noteController.text = note.content;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Note"),
        content: TextField(
          controller: noteController,
        ), // TextField
        actions: [
          // cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text("Cancel"),
          ), // TextButton

          // save button
          TextButton(
            onPressed: () {
              // save in db
              notesDatabase.updateNote(note, noteController.text);
              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text("Save"),
          ), // TextButton
        ],
      ), // AlertDialog
    );
  }

  // user wants to delete note
  void deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Note"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text("Cancel"),
          ), // TextButton

          // save button
          TextButton(
            onPressed: () {
              // save in db
              notesDatabase.deleteNote(note);
              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text("Delete"),
          ),
        ],
      ), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout, 
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewNote(); 
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: notesDatabase.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.content), 
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => updateNote(note),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteNote(note),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
