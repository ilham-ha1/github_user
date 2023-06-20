import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_user/provider/theme_provider.dart';
import 'package:github_user/provider/user_provider.dart';
import 'package:github_user/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
            create: (context) => UserProvider(),
        )
      ],
      builder: (context, child){
        final provider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'Github User',
          theme: provider.theme,
          home: const MyHomePage(title: 'Github User'),
        );
      },
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => UserProvider(),
//       child: MaterialApp(
//         title: 'Github User',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
//           useMaterial3: true,
//         ),
//         home: const MyHomePage(title: 'Github User'),
//       ),
//     );
//   }
// }


