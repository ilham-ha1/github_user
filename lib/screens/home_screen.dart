import 'package:flutter/material.dart';
import 'package:github_user/provider/user_provider.dart';
import 'package:github_user/screens/favorite_screen.dart';
import 'package:github_user/screens/theme_page.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  late UserProvider userProvider;
  late List<Map<String, dynamic>> favorites;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    favorites = [];
    getUserFavorites();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userProvider.getUser("ilham");
    });
  }

  Future<void> getUserFavorites() async {
    final items = await userProvider.getItem();
    setState(() {
      favorites = items;
    });
  }

  bool isFavorite(int id) {
    return favorites.any((item) => item['id'] == id);
  }

  @override
  Widget build(BuildContext context) {
    getUserFavorites();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {

            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemePage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = value.user;
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: user.length,
                    itemBuilder: (context, index) {
                      final currentUser = user[index];
                      final isCurrentUserFavorite = isFavorite(currentUser.id);
                      return Card(
                        key: ValueKey(currentUser.id),
                        color: Colors.blue,
                        elevation: 4,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(currentUser.avatarUrl),
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text(
                            currentUser.login,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: isCurrentUserFavorite ? Colors.red : Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              if (isCurrentUserFavorite) {
                                userProvider.deleteItem(currentUser.id);
                              } else {
                                userProvider.createItem(
                                  currentUser.id,
                                  currentUser.login,
                                  currentUser.avatarUrl,
                                );
                              }
                              getUserFavorites();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     super.initState();
//     //HOME INIT STATE COMPLETED
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       Provider.of<UserProvider>(context, listen: false)
//           .getUser("ilham"); //false because after context
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         title: Text(widget.title, style: TextStyle(color: Colors.white)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.favorite, color: Colors.white),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => FavoriteScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Consumer<UserProvider>(
//         builder: (context, value, child) {
//           if (value.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final user = value.user;
//           return Padding(
//             padding: const EdgeInsets.all(15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: user.length,
//                     itemBuilder: (context, index) {
//                       final currentUser = user[index];
//                       return FutureBuilder<bool>(
//                         future: userProvider.getItemById(currentUser.id),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const SizedBox();
//                           }
//                           print('snapshot ${snapshot.data}');
//                           final checkCurrentUser = snapshot.data ?? false; //true ?? false
//                           return Card(
//                             key: ValueKey(currentUser.id),
//                             color: Colors.blue,
//                             elevation: 4,
//                             child: ListTile(
//                               leading: CircleAvatar(
//                                 radius: 25,
//                                 backgroundImage:
//                                     NetworkImage(currentUser.avatarUrl),
//                                 backgroundColor: Colors.transparent,
//                               ),
//                               title: Text(
//                                 currentUser.login,
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                               trailing: IconButton(
//                                 icon: Icon(
//                                   Icons.favorite,
//                                   color: checkCurrentUser
//                                       ? Colors.white
//                                       : Colors.red,
//                                   size: 30,
//                                 ),
//                                 onPressed: () {
//                                   if (checkCurrentUser == false) { //logika if salah
//                                     context.read<UserProvider>().createItem(
//                                           currentUser.id,
//                                           currentUser.login,
//                                           currentUser.avatarUrl,
//                                         );
//                                     print("inside fav icon add");
//                                   } else {
//                                     context
//                                         .read<UserProvider>()
//                                         .deleteItem(currentUser.id);
//                                     print("inside fav icon delete");
//                                   }
//                                 },
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
