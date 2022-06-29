import 'package:flutter/material.dart';
import 'package:flutter_sudoku/screens/dil.dart';
import 'package:flutter_sudoku/screens/sudoku_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class Giris extends StatefulWidget {
  const Giris({Key? key}) : super(key: key);

  @override
  State<Giris> createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  late Box _sudokuKutu;
  Future<Box> _openBox() async {
    _sudokuKutu = await Hive.openBox("sudoku");
    return await Hive.openBox('finished_sudokus');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dil['giris_title'],
        ),
        actions: [
          IconButton(
              onPressed: () {
                var box = Hive.box('ayarlar');
                box.put('karanlik_tema',
                    !box.get('karanlik_tema', defaultValue: false));
              },
              icon: const Icon(Icons.theater_comedy_sharp)),
          PopupMenuButton(
            icon: const Icon(Icons.add_box),
            onSelected: (val) {
              if (_sudokuKutu.isOpen) {
                _sudokuKutu.put('seviye', val);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Sudoku()));
              }
            },
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: dil['seviye_secin'],
                enabled: false,
                child: Text(
                  dil['seviye_secin'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
              ),
              for (String k in sudokuSeviyeleri.keys)
                PopupMenuItem(
                  value: k,
                  child: Text(k),
                )
            ],
          )
        ],
      ),
      body: FutureBuilder<Box>(
        future: _openBox(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (snapshot.data.length == 0)
                    Text(dil['tamamlanan_yok'],
                        style: GoogleFonts.cairo(
                            textStyle: const TextStyle(fontSize: 18))),
                  for (var eleman in snapshot.data.values)
                    Center(child: Text('$eleman'))
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
