import 'package:flutter/material.dart';
import 'package:flutter_sudoku/screens/sudoku_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'dil.dart';

class Giris extends StatefulWidget {
  @override
  _GirisState createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  late Box _sudokuKutu;
  Future<Box> _kutuAc() async {
    _sudokuKutu = await Hive.openBox('sudoku');
    return await Hive.openBox('finished_sudokus');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
      future: _kutuAc(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(dil['giris_title']),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Box kutu = Hive.box('ayarlar');
                    kutu.put(
                      'karanlik_tema',
                      !kutu.get('karanlik_tema', defaultValue: false),
                    );
                  },
                ),
                if (_sudokuKutu.get('sudokuRows') != null)
                  IconButton(
                    icon: const Icon(Icons.play_circle_outline),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Sudoku()),
                      );
                    },
                  ),
                PopupMenuButton(
                  icon: const Icon(Icons.add),
                  onSelected: (deger) {
                    if (_sudokuKutu.isOpen) {
                      _sudokuKutu.put('seviye', deger);
                      _sudokuKutu.put('sudokuRows', null);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Sudoku()),
                      );
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
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        ),
                      ),
                    ),
                    for (String k in sudokuSeviyeleri.keys)
                      PopupMenuItem(
                        value: k,
                        child: Text(k),
                      ),
                  ],
                ),
              ],
            ),
            body: ValueListenableBuilder<Box>(
              valueListenable: snapshot.data!.listenable(),
              builder: (context, box, _) {
                return Column(
                  children: <Widget>[
                    if (box.length == 0)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          dil['tamanlanan_yok'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lobster(
                            textStyle: const TextStyle(fontSize: 24.0),
                          ),
                        ),
                      ),
                    for (Map eleman in box.values.toList().reversed.take(30))
                      ListTile(
                        onTap: () {},
                        title: Text("${eleman['tarih']}"),
                        subtitle: Text("${Duration(seconds: eleman['sure'])}"
                            .split('.')
                            .first),
                      )
                  ],
                );
              },
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
