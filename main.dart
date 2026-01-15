import 'package:flutter/material.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const NotesHomePage(),
    );
  }
}

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _notes = [];
  int? _editingIndex;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      if (_editingIndex != null) {
        _notes[_editingIndex!] = text;
        _editingIndex = null;
      } else {
        _notes.add(text);
      }
      _textController.clear();
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = null;
        _textController.clear();
      } else if (_editingIndex != null && _editingIndex! > index) {
        _editingIndex = _editingIndex! - 1;
      }
    });
  }

  void _editNote(int index) {
    setState(() {
      _editingIndex = index;
      _textController.text = _notes[index];
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingIndex = null;
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Заметки'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: _editingIndex != null
                        ? 'Редактировать заметку'
                        : 'Введите текст заметки',
                    border: const OutlineInputBorder(),
                    suffixIcon: _editingIndex != null
                        ? IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: _cancelEdit,
                            tooltip: 'Отменить редактирование',
                          )
                        : null,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveNote,
                    icon: Icon(
                      _editingIndex != null ? Icons.save : Icons.add,
                    ),
                    label: Text(
                      _editingIndex != null ? 'Сохранить изменения' : 'Сохранить',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Нет заметок',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Добавьте первую заметку',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            _notes[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.blue,
                                onPressed: () => _editNote(index),
                                tooltip: 'Редактировать',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () => _deleteNote(index),
                                tooltip: 'Удалить',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
