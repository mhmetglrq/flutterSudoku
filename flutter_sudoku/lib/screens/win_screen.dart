import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'giris_screen.dart';
import 'sudoku_screen.dart';

class Sonuc extends StatefulWidget {
  final Map map;

  const Sonuc({
    Key? key,
    required this.map,
  }) : super(key: key);

  @override
  State<Sonuc> createState() => _SonucState();
}

class _SonucState extends State<Sonuc> {
  final Box _sudokuKutu = Hive.box('sudoku');
  String? nextLevelName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFF0F110C),
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "Tebrikler Sudokuyu Bitirdin!",
                  style: GoogleFonts.getFont(
                    'Permanent Marker',
                    textStyle: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const Giris(lose: false,),
                          ),
                          (route) => false,
                        );
                        _sudokuKutu.put('sudokuRows', null);
                      },
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 2,
                              color: const Color(0xFF312C51),
                            ),
                          ),
                          child: Text(
                            "Ana Menüye Dön",
                            style: GoogleFonts.getFont(
                              'Permanent Marker',
                              textStyle: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<Box>(
                      valueListenable:
                          _sudokuKutu.listenable(keys: ['currentLevel']),
                      builder: (context, box, snapshot) {
                        return Expanded(
                          child: InkWell(
                            onTap: () {
                              _sudokuKutu.put('sudokuRows', null);
                              String currentLevel = box.get('currentLevel');
                              if (currentLevel == "Çok Kolay") {
                                _sudokuKutu.put('seviye', "Kolay");
                                _sudokuKutu.put('sudokuRows', null);
                                nextLevelName = 'Kolay';
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Sudoku(),
                                  ),
                                  (route) => false,
                                );
                              } else if (currentLevel == "Kolay") {
                                _sudokuKutu.put('seviye', "Orta");
                                _sudokuKutu.put('sudokuRows', null);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Sudoku(),
                                  ),
                                  (route) => false,
                                );
                              } else if (currentLevel == "Orta") {
                                _sudokuKutu.put('seviye', "Zor");
                                _sudokuKutu.put('sudokuRows', null);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Sudoku(),
                                  ),
                                  (route) => false,
                                );
                              } else if (currentLevel == "Zor") {
                                _sudokuKutu.put('seviye', "Çok Zor");
                                _sudokuKutu.put('sudokuRows', null);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Sudoku(),
                                  ),
                                  (route) => false,
                                );
                              } else if (currentLevel == "Çok Zor") {
                                _sudokuKutu.put('seviye', "İmkansız");
                                _sudokuKutu.put('sudokuRows', null);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Sudoku(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: const Color(0xFFF1AA9B),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Bir Üst Seviyeye Geç",
                                        style: GoogleFonts.getFont(
                                          'Permanent Marker',
                                          textStyle: const TextStyle(
                                            fontSize: 25,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: Text(
                                    //     "",
                                    //     style: GoogleFonts.getFont(
                                    //       'Permanent Marker',
                                    //       textStyle: const TextStyle(
                                    //         fontSize: 25,
                                    //       ),
                                    //     ),
                                    //     textAlign: TextAlign.center,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
