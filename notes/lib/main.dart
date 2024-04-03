import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/note_provider.dart';
import 'package:notes/sqf_lite_helper.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SQLHelper.getDatabase;
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NoteProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController idController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  int _counter = 0;

  late String newTitle;
  late String newContent;

  @override
  void initState() {
    context.read<NoteProvider>().loadNotesProvider();
    super.initState();
  }

  void showMyDialog() {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => Material(
        color: Colors.white.withOpacity(0.3),
        child: CupertinoAlertDialog(
          title: const Text('Add New Note'),
          content: Column(
            children: [
              TextField(
                controller: idController,
              ),
              TextField(
                controller: titleController,
              ),
              TextField(
                controller: contentController,
              ),
            ],
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
            CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  // close() {
                  //   Navigator.of(context).pop();
                  // }
                  // final contextProvider = context.read<NoteProvider>();
                  // var existingItem = await SQLHelper.loadNotes().then((list) =>
                  //     list.firstWhereOrNull((element) =>
                  //         element.containsValue(int.parse(idController.text))));
                  var existingItem = context
                      .read<NoteProvider>()
                      .getItems
                      .firstWhereOrNull((element) =>
                          element.id == int.parse(idController.text));
                  existingItem == null
                      ? context.read<NoteProvider>().addItem(Note(
                            id: int.parse(idController.text),
                            title: titleController.text,
                            content: contentController.text,
                          ))
                      : print('Object existing');
                  idController.clear();
                  titleController.clear();
                  contentController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Yes')),
          ],
        ),
      ),
    );
  }

  void showDialogTodo() {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => Material(
        color: Colors.white.withOpacity(0.3),
        child: CupertinoAlertDialog(
          title: const Text('Add New Todo'),
          content: TextField(
            controller: titleController,
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
            CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  SQLHelper.insertTodo(Todo(title: titleController.text))
                      .whenComplete(() => setState(() {}));
                  // SQLHelper.insertNote(Note(
                  //   title: titleController.text,
                  //   content: contentController.text,
                  // ));
                  titleController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Yes')),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    String titleInit,
    String contentInit,
    int id,
  ) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => Material(
        color: Colors.white.withOpacity(0.3),
        child: CupertinoAlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            children: [
              TextFormField(
                initialValue: titleInit,
                // controller: titleController,
                onChanged: (value) {
                  newTitle = value;
                  print(newTitle);
                },
              ),
              TextFormField(
                initialValue: contentInit,
                // controller: titleController,
                onChanged: (value) {
                  newContent = value;
                },
              ),
            ],
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
            CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  context.read<NoteProvider>().updateItems(Note(
                        id: id,
                        title: newTitle,
                        content: newContent,
                        description: 'new Description',
                      ));
                  titleController.clear();
                  contentController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Yes')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              context.read<NoteProvider>().clearItems();
            },
            icon: Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          return ListView.builder(
            itemCount: noteProvider.count,
            itemBuilder: (context, index) {
              var items = noteProvider.getItems[index];
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) =>
                    context.read<NoteProvider>().deleteItem(items.id),
                child: Card(
                  color: Colors.lightBlueAccent,
                  child: Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            _showEditDialog(
                              items.title,
                              items.content,
                              items.id,
                            );
                          },
                          icon: Icon(Icons.edit)),
                      Text(('id: ') + (items.id.toString())),
                      Text(('title: ') + (items.title.toString())),
                      Text(('content: ') + (items.content.toString())),
                      Text(('description: ') + (items.description.toString())),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.lightBlueAccent,
            onPressed: showMyDialog,
            tooltip: 'Add task',
            child: const Icon(Icons.add),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: FloatingActionButton(
              backgroundColor: Colors.lightGreenAccent,
              onPressed: showDialogTodo,
              tooltip: 'Add task',
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
