import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../screens/giris_screen.dart';
import '../screens/sudoku_screen.dart';

class WinDialog extends StatefulWidget {
  const WinDialog({Key? key}) : super(key: key);

  @override
  State<WinDialog> createState() => _WinDialogState();
}

class _WinDialogState extends State<WinDialog> {
  final Box _sudokuKutu = Hive.box('sudoku');
  late String _sudokuString;
  final List _sudoku = [];
  String? nextLevelName;
  _clearBox() {
    _sudokuKutu.put('sudokuRows', null);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFF3A015C),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(15),
                  child: const Text(
                    'Tebrikler!',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(4),
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(4),
                  child: const Text(
                    'Oyunu başarıyla tamamladın. Tebrikler',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ValueListenableBuilder<Box>(
                  valueListenable:
                      _sudokuKutu.listenable(keys: ['currentLevel']),
                  builder: (context, box, snapshot) {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFF6184D8)),
                      alignment: Alignment.center,
                      child: MaterialButton(
                        onPressed: () {
                          _sudokuKutu.put('sudokuRows', null);
                          String currentLevel = box.get('currentLevel');
                          if (currentLevel == "Çok Kolay") {
                            _sudokuKutu.put('nextLevel', 'Kolay');
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
                            _sudokuKutu.put('nextLevel', 'Orta');
                            _sudokuKutu.put('seviye', "Orta");
                            _sudokuKutu.put('sudokuRows', null);
                            nextLevelName = 'Orta';
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Sudoku(),
                              ),
                              (route) => false,
                            );
                          } else if (currentLevel == "Orta") {
                            _sudokuKutu.put('nextLevel', 'Zor');

                            _sudokuKutu.put('seviye', "Zor");
                            _sudokuKutu.put('sudokuRows', null);
                            nextLevelName = 'Zor';
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Sudoku(),
                              ),
                              (route) => false,
                            );
                          } else if (currentLevel == "Zor") {
                            _sudokuKutu.put('nextLevel', 'Çok Zor');

                            _sudokuKutu.put('seviye', "Çok Zor");
                            _sudokuKutu.put('sudokuRows', null);
                            nextLevelName = 'Çok Zor';
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Sudoku(),
                              ),
                              (route) => false,
                            );
                          } else if (currentLevel == "Çok Zor") {
                            _sudokuKutu.put('nextLevel', 'İmkansız');

                            _sudokuKutu.put('seviye', "İmkansız");
                            _sudokuKutu.put('sudokuRows', null);
                            nextLevelName = 'İmkansız';

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
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFF6184D8)),
                          alignment: Alignment.center,
                          child: Text(
                            'Sonraki Seviyeye Geç ${_sudokuKutu.get('nextLevel')}',
                            style: const TextStyle(
                              color: Color(0xFFDAFFED),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => const Giris(
                                  lose: true,
                                ),
                              ),
                              (route) => false).then((value) => _clearBox());
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: const Color(0xFFEDBBB4),
                        child: const Text(
                          'Ana Menüye Dön',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        onPressed: () {
                          _clearBox();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Sudoku()),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: const Color(0xffDBABBE),
                        child: const Text(
                          'Yeniden Başlat',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
