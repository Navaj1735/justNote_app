import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justnote_app/controller/controller.dart';
import 'package:justnote_app/model/note_model.dart';
import 'package:justnote_app/screen/home/card_note.dart';
import 'package:justnote_app/utils/main_colors.dart';
import 'package:justnote_app/utils/textstyle.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Color selectedColor = Colors.grey;
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    context.read<NoteController>().loadEvents();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var providerWatch = context.watch<NoteController>();
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        centerTitle: true,
        title: Text(
          'NOTELY',
          style: maintextdark,
        ),
      ),

      body: Consumer<NoteController>(
        builder: (context, value, child) {
          return isloading
              ? Center(
              child: CircularProgressIndicator(
                color: primarycolordark,
              ))
              : value.notes.isEmpty
              ? Center(child: Lottie.asset('assets/animations/add_note_purple.json'))
              : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: value.notes.length,
                  itemBuilder: (context, index) {
                    final note = value.notes[index];
                    return NoteCard(
                      onEditPressed: () {
                        value.existingNoteIndex = index;
                        _addOrEditNote(context, existingNote: note);
                      },
                      onDeletePressed: () async {
                        await value.deleteEvent(index);
                        value.loadEvents();
                      },
                      category: note.category,
                      title: note.title,
                      description: note.description,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: primarycolorlight,
          onPressed: () {
            providerWatch.existingNoteIndex = -1;
            _addOrEditNote(context);
          },
          child: Icon(
            Icons.add,
            color: primarycolordark,
            size: 40,
          )),
    );
  }

  void _addOrEditNote(BuildContext ctx, {NoteModel? existingNote}) async {
    var providerRead = context.read<NoteController>();
    final isEditing = existingNote != null;
    final newNote = isEditing
        ? NoteModel.copy(existingNote)
        : NoteModel(
      category: '',
      title: '',
      description: '',
      date: DateTime.now(),
    );

    _categoryController.text = newNote.category;
    _titleController.text = newNote.title;
    _descriptionController.text = newNote.description;

    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Scaffold(
                backgroundColor: bgcolor,
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        AppBar(
                          backgroundColor: bgcolor,
                          leading: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: primarycolordark,
                              )),
                          centerTitle: true,
                          title: Text(isEditing ? 'Edit Note' : 'Add Note',
                              style: maintextdark),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Category',
                              labelStyle: subtextdark),
                          controller: _categoryController,
                          onChanged: (value) {
                            newNote.category = value;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Title',
                              labelStyle: subtextdark),
                          controller: _titleController,
                          onChanged: (value) {
                            newNote.title = value;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          maxLines: 5,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Description',
                              labelStyle: subtextdark),
                          controller: _descriptionController,
                          onChanged: (value) {
                            newNote.description = value;
                          },
                        ),
                        SizedBox(height: 20.0),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStatePropertyAll(Colors.grey)),
                              onPressed: () async {
                                if (_categoryController.text.isNotEmpty &&
                                    _titleController.text.isNotEmpty &&
                                    _descriptionController.text.isNotEmpty) {
                                  newNote.category = _categoryController.text;
                                  newNote.title = _titleController.text;
                                  newNote.description = _descriptionController.text;
                                  if (isEditing) {
                                    await providerRead.updateEvent(
                                        providerRead.existingNoteIndex, newNote);
                                  } else {
                                    await providerRead.addEvent(newNote);
                                  }
                                  providerRead.loadEvents();
                                  Navigator.of(context).pop();
                                } else {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 2,
                                              color: Colors.grey,
                                              style: BorderStyle.solid),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30))),
                                      backgroundColor: primarycolorlight,
                                      content: Center(
                                        child: Text(
                                          "Please add full details ❗",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                              fontSize: 17),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                isEditing ? 'Save' : 'Add',
                                style: subtextdark,
                              ),
                            ),
                            SizedBox(
                              width: 60,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStatePropertyAll(Colors.grey)),
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: subtextdark,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
