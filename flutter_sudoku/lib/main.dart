import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sudoku/screens/giris_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter('sudoku');
  await Hive.openBox('ayarlar');
  final sudokuTemaKutu = Hive.box('ayarlar');
  if (sudokuTemaKutu.get('tema') == null) {
    sudokuTemaKutu.put('tema', 'dark');
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box('ayarlar').listenable(),
        builder: (context, box, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const Giris(
              lose: false,
            ),
            theme: box.get('tema') == 'dark'
                ? ThemeData.dark()
                : ThemeData.light(),
          );
        },);
  }
}
