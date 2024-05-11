import 'package:flutter/material.dart';
import 'package:personal_trainer_app/di/di_module.dart';
import 'package:personal_trainer_app/main_page.dart';

void main() {
  getIt.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

extension BuildContextExtension on BuildContext {
  Future<T?> push<T>(Widget widget) =>
      Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => widget));

  void pop<T>([T? result ]) => Navigator.of(this).pop(result);
}
