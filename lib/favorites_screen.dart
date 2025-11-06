import 'package:flutter/material.dart';
import 'home_screen.dart'; // We need this to get the 'WordItem' class

class FavoritesScreen extends StatefulWidget {
  // 1. We need to receive the list of ALL words from the HomeScreen
  final List<WordItem> allWords;

  // 2. We also need to receive the FUNCTION to call when
  //    we unfavorite an item.
  final Function(WordItem) onToggleFavorite;

  // 3. This is the constructor
  const FavoritesScreen({
    super.key,
    required this.allWords,
    required this.onToggleFavorite,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // 4. This will be our LOCAL list, containing ONLY the favorites.
  late List<WordItem> _favoritesList;

  @override
  void initState() {
    super.initState();
    // 5. When the widget is first created, we filter the main list
    //    and fill our local list.
    _favoritesList = widget.allWords.where((item) => item.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Favorites')),
      // 6. We build the body using our local list
      body: _buildFavoritesList(),
    );
  }

  Widget _buildFavoritesList() {
    // 7. Show a message if the list is empty
    if (_favoritesList.isEmpty) {
      return const Center(
        child: Text(
          'You have no favorites yet.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // 8. Build the ListView, just like on the HomeScreen
    return ListView.builder(
      itemCount: _favoritesList.length,
      itemBuilder: (context, index) {
        final item = _favoritesList[index];

        return ListTile(
          title: Text(item.text, style: TextStyle(fontSize: 18)),

          // 9. A simple "remove" button
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            tooltip: 'Remove from favorites',
            onPressed: () {
              // --- THIS IS THE KEY ---

              // 10. Call the function we received from HomeScreen
              // This updates the data in the *main* list
              widget.onToggleFavorite(item);

              // 11. Update our *local* UI instantly
              // We call our own setState to remove the item
              // from this screen's list.
              setState(() {
                _favoritesList.remove(item);
              });
              // --- END KEY ---
            },
          ),
        );
      },
    );
  }
}
