import 'package:flutter/material.dart';
import 'package:notes_app/modules/note.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNewNote extends StatefulWidget {
  final bool isUpdate;
  final Note? note;
  const AddNewNote({Key? key, required this.isUpdate, this.note})
      : super(key: key);

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  void addNewNote() {
    Note newNote = Note(
      id: const Uuid().v1(),
      title: titleController.text,
      content: contentController.text,
      userid: 'himanshu@gmail.com',
      dateAdded: DateTime.now(),
    );
    Provider.of<NotesProvider>(context, listen: false).addnote(newNote);
    Navigator.pop(context);
  }

  void updateNote() {
    widget.note!.title = titleController.text;
    widget.note!.content = contentController.text;
    Provider.of<NotesProvider>(context, listen: false).update(widget.note!);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      titleController.text = widget.note!.title!;
      contentController.text = widget.note!.content!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Note"),
        actions: [
          IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                if (titleController.text.isEmpty &&
                    contentController.text.isEmpty) {
                  Navigator.pop(context);
                } else {
                  if (widget.isUpdate) {
                    updateNote();
                  } else {
                    addNewNote();
                  }
                }
              }),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            controller: titleController,
            autofocus: (widget.isUpdate == true) ? false : true,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          Expanded(
            child: TextField(
              controller: contentController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Note',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
