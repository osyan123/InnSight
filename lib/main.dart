import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const InnSightApp());
}

class InnSightApp extends StatelessWidget {
  const InnSightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InnSight',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      ),

      initialRoute: AppRoutes.gate,
      routes: AppRoutes.routes,

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'screens/manager/floor_plan_editor_screen.dart';

// void main() {
//   runApp(const InnSightApp());
// }

// class InnSightApp extends StatelessWidget {
//   const InnSightApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'InnSight Manager',
//       theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
//       home: const FloorPlanEditorScreen(),
//     );
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }
