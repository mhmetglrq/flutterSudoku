import 'package:flutter/material.dart';
import 'package:flutter_sudoku/screens/sudoku_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'dil.dart';

class Giris extends StatefulWidget {
  const Giris({Key? key}) : super(key: key);

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
              backgroundColor: const Color(0xFF0F110C),
              automaticallyImplyLeading: false,
              elevation: 0,
              actions: <Widget>[
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          // image: const DecorationImage(
                          //   image: AssetImage(
                          //     'assets/logo.png',
                          //   ),
                          //   fit: BoxFit.fill,
                          // ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'SudokuZ',
                      style: GoogleFonts.getFont(
                        'Permanent Marker',
                        textStyle: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {},
                  ),
                ),

                // if (_sudokuKutu.get('sudokuRows') != null)
                //   IconButton(
                //     icon: const Icon(Icons.play_circle_outline),
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (_) => const Sudoku()),
                //       );
                //     },
                //   ),
                // PopupMenuButton(
                //   icon: const Icon(Icons.add),
                //   onSelected: (deger) {
                //     if (_sudokuKutu.isOpen) {
                //       _sudokuKutu.put('seviye', deger);
                //       _sudokuKutu.put('sudokuRows', null);

                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (_) => const Sudoku()),
                //       );
                //     }
                //   },
                //   itemBuilder: (context) => <PopupMenuEntry>[
                //     PopupMenuItem(
                //       value: dil['seviye_secin'],
                //       enabled: false,
                //       child: Text(
                //         dil['seviye_secin'],
                //         style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //           color: Theme.of(context).textTheme.bodyText1?.color,
                //         ),
                //       ),
                //     ),
                //     for (String k in sudokuSeviyeleri.keys)
                //       PopupMenuItem(
                //         value: k,
                //         child: Text(k),
                //       ),
                //   ],
                // ),
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0F110C),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ValueListenableBuilder<Box>(
                valueListenable: snapshot.data!.listenable(),
                builder: (context, box, _) {
                  return Column(
                    children: <Widget>[
                      const Expanded(
                        flex: 1,
                        child: AspectRatio(
                          aspectRatio: 6,
                          child: Center(
                            child: Text(
                              "Eski Oyunlar",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 22,
                                color: Color(0xFFF1AA9B),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 12,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 3,
                              color: const Color(0xFF312C51),
                            ),
                          ),
                          child: box.length == 0
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      //Text Tipi değişicek
                                      dil['tamamlanan_yok'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.getFont(
                                        'Permanen Marker',
                                        textStyle:
                                            const TextStyle(fontSize: 24.0),
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: box.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var model = box.values
                                        .elementAt((box.length - 1) - index);
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: AspectRatio(
                                                aspectRatio: 3,
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),

                                                    // border: Border.all(
                                                    //   width: 1,
                                                    //   color: Colors.white,
                                                    // ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          model['tarih']
                                                              .toString()
                                                              .split('.')
                                                              .elementAt(0),
                                                          style: GoogleFonts
                                                              .oswald(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "${Duration(seconds: model['sure'])}"
                                                              .split('.')
                                                              .first,
                                                          style: GoogleFonts
                                                              .passionOne(
                                                            textStyle:
                                                                const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: AspectRatio(
                                                aspectRatio: 3,
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: const Color(
                                                            0xFF312C51)),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(model['seviye']
                                                      .toString()),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  }),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            // border: Border.all(
                            //   width: 1,
                            //   color: Color(0xFFF1AA9B),
                            // ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: AspectRatio(
                                  aspectRatio: 4,
                                  child: Center(
                                    child: Text(
                                      "Seviyeler",
                                      style: GoogleFonts.syne(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22,
                                          color: Color(0xFFF1AA9B),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: const Color(0xFF312C51),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: AspectRatio(
                                                  aspectRatio: 5,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(4),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF312C51),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (_sudokuKutu
                                                            .isOpen) {
                                                          _sudokuKutu.put(
                                                              'seviye',
                                                              "İmkansız");
                                                          _sudokuKutu.put(
                                                              'sudokuRows',
                                                              null);

                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    const Sudoku()),
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        "İmkansız",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          textStyle:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //zor
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: AspectRatio(
                                                  aspectRatio: 3,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(4),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF312C51),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (_sudokuKutu
                                                            .isOpen) {
                                                          _sudokuKutu.put(
                                                              'seviye', "Zor");
                                                          _sudokuKutu.put(
                                                              'sudokuRows',
                                                              null);

                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    const Sudoku()),
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        "Zor",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          textStyle:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //Çok Zor
                                            Expanded(
                                              child: Center(
                                                child: AspectRatio(
                                                  aspectRatio: 3,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(4),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF312C51),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (_sudokuKutu
                                                            .isOpen) {
                                                          _sudokuKutu.put(
                                                              'seviye',
                                                              "Çok Zor");
                                                          _sudokuKutu.put(
                                                              'sudokuRows',
                                                              null);

                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    const Sudoku()),
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        "Çok Zor",
                                                        style:
                                                            GoogleFonts.oswald(
                                                          textStyle:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: AspectRatio(
                                                aspectRatio: 1,
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(4),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color:
                                                        const Color(0xFF312C51),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (_sudokuKutu.isOpen) {
                                                        _sudokuKutu.put(
                                                            'seviye',
                                                            "Çok Kolay");
                                                        _sudokuKutu.put(
                                                            'sudokuRows', null);

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  const Sudoku()),
                                                        );
                                                      }
                                                    },
                                                    child: Text(
                                                      "Çok Kolay",
                                                      style: GoogleFonts.oswald(
                                                        textStyle:
                                                            const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: AspectRatio(
                                                aspectRatio: 1,
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(4),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color:
                                                        const Color(0xFF312C51),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (_sudokuKutu.isOpen) {
                                                        _sudokuKutu.put(
                                                            'seviye', "Kolay");
                                                        _sudokuKutu.put(
                                                            'sudokuRows', null);

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  const Sudoku()),
                                                        );
                                                      }
                                                    },
                                                    child: Text(
                                                      "Kolay",
                                                      style: GoogleFonts.oswald(
                                                        textStyle:
                                                            const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: AspectRatio(
                                                aspectRatio: 1,
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(4),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF312C51),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (_sudokuKutu.isOpen) {
                                                        _sudokuKutu.put(
                                                            'seviye', "Orta");
                                                        _sudokuKutu.put(
                                                            'sudokuRows', null);

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  const Sudoku()),
                                                        );
                                                      }
                                                    },
                                                    child: Text(
                                                      "Orta",
                                                      style: GoogleFonts.oswald(
                                                        textStyle:
                                                            const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //Eski Oyun
                              if (_sudokuKutu.get('sudokuRows') != null)
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0xFF312C51),
                                      ),
                                      alignment: Alignment.center,
                                      child: InkWell(
                                        onTap: () {
                                          {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const Sudoku()),
                                            );
                                          }
                                        },
                                        child: Text(
                                          "Eski oyuna devam et",
                                          style: GoogleFonts.oswald(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
