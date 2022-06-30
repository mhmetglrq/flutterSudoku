import 'package:flutter/material.dart';
import 'package:flutter_sudoku/screens/giris_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter('sudoku');
  await Hive.openBox('ayarlar');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable:
            Hive.box('ayarlar').listenable(keys: ['karanlik_tema', 'dil']),
        builder: (context, box, widget) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: box.get('karanlik_tema', defaultValue: false)
                ? ThemeData.dark()
                : ThemeData.light(),
            home: Giris(),
          );
        });
  }
}
