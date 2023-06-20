import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:github_user/provider/user_provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late UserProvider userProvider;
  late List<Map<String, dynamic>> favorites;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    favorites = [];
    getUserFavorites();
  }

  Future<void> getUserFavorites() async {
    final items = await userProvider.getItem();
    setState(() {
      favorites = items;
    });
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("My Favorite User on Local", style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.pop(context); // Navigate back when back button is pressed
          },
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, value, child){
          if (value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final favorites = this.favorites;
          return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (_, index){
                final currentUser = favorites[index];
                final id = currentUser['id'];
                final username = currentUser['username'] ?? '';
                final avatarUrl = currentUser['avatarurl'] ?? '';
                return Card(
                  key: ValueKey(id),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(avatarUrl),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(username),
                    trailing: TextButton(
                      child: const Text(
                        'Remove',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: (){
                        userProvider.deleteItem(id);
                        getUserFavorites();
                      },
                    ),
                  ),
                );
              }
          );
        },
      ),
    );
  }
}
