import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../screens/giris_screen.dart';
import '../screens/sudoku_screen.dart';

class LoseDialog extends StatefulWidget {
  const LoseDialog({Key? key}) : super(key: key);

  @override
  State<LoseDialog> createState() => _LoseDialogState();
}

class _LoseDialogState extends State<LoseDialog> {
  final Box _sudokuKutu = Hive.box('sudoku');
  late String _sudokuString;
  final List _sudoku = [];
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
                    'Oyun Bitti!',
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
                    '3 Hatayı aştığınız için oyunu kaybettiniz.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF6184D8)),
                alignment: Alignment.center,
                child: MaterialButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'İkinci Şans',
                        style: TextStyle(
                          color: Color(0xFFDAFFED),
                          fontSize: 15,
                        ),
                      ),
                      Icon(
                        Icons.smart_display_outlined,
                        color: Color(0xFFDAFFED),
                      ),
                    ],
                  ),
                ),
              ),
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
