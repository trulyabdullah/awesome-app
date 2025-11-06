import 'package:flutter/material.dart';
import 'package:my_awesome_app/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<WordItem> _words = [];

  @override
  Widget build(BuildContext context) {
    void _navigateToFavorites() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoritesScreen(
            allWords: _words,
            onToggleFavorite: _toggleFavorite,
          ),
        ),
      ).then((_) {
        setState(() {});
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Word List'),
        actions: [
          IconButton(
            key: const Key('favoritesAppBarButton'),
            icon: Icon(Icons.favorite),
            tooltip: 'View Favorites',
            onPressed: () {
              _navigateToFavorites();
            },
          ),
        ],
      ),

      body: _buildWordList(),

      floatingActionButton: FloatingActionButton(
        key: const Key('newWordButton'),
        onPressed: () {
          _showAddWordDialog();
        },
        tooltip: 'Add new word',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWordList() {
    if (_words.isEmpty) {
      return const Center(
        child: Text(
          'No text added.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _words.length,

      itemBuilder: (context, index) {
        final item = _words[index];

        return ListTile(
          leading: Icon(
            item.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: item.isFavorite ? Colors.red : null,
          ),

          title: Text(item.text, style: TextStyle(fontSize: 18)),

          trailing: PopupMenuButton(
            onSelected: (String value) {
              if (value == 'favorite') {
                _toggleFavorite(item);
              } else if (value == 'delete') {
                _deleteWord(index);
              }
            },

            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                key: const Key('favorite'),
                value: 'favorite',
                child: Text(item.isFavorite ? 'Unfavorite' : 'Favorite'),
              ),
              const PopupMenuItem(
                key: const Key('delete'),
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAddWordDialog() async {
    final TextEditingController textController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Add a new word'),
          content: TextField(
            key: const Key('newWordTextField'),
            controller: textController,
            decoration: const InputDecoration(hintText: "Enter your word here"),
            autofocus: true,
          ),

          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                // Just closes the dialog
                Navigator.of(dialogContext).pop();
              },
            ),

            ElevatedButton(
              key: const Key('addWordDialogButton'),
              child: const Text('Add'),
              onPressed: () {
                final String word = textController.text;
                if (word.isNotEmpty) {
                  setState(() {
                    _words.add(WordItem(text: word));
                  });
                }

                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteWord(int index) {
    setState(() {
      _words.removeAt(index);
    });
  }

  void _toggleFavorite(WordItem item) {
    setState(() {
      item.isFavorite = !item.isFavorite;
    });
  }
}

class WordItem {
  String text;
  bool isFavorite;

  WordItem({required this.text, this.isFavorite = false});
}
