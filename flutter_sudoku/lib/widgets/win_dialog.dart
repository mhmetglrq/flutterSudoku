import 'package:flutter/material.dart';
import 'package:flutter_sudoku/screens/color.dart';
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

  Future<Box> _temaKutuAc() async {
    return await Hive.openBox('ayarlar');
  }

  String? nextLevelName;
  _clearBox() {
    _sudokuKutu.put('sudokuRows', null);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: FutureBuilder<Box>(
          future: _temaKutuAc(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ValueListenableBuilder<Box>(
                  valueListenable: snapshot.data!.listenable(),
                  builder: (context, themeBox, _) {
                    return Dialog(
                      backgroundColor: transparent,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: themeBox.get('tema') == 'dark'
                                ? dialogDarkBgColor
                                : dialogLightBgColor,
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
                                  child: Text(
                                    'Tebrikler!',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: themeBox.get('tema') == 'dark'
                                          ? dialogDarkIconandTextColor
                                          : dialogLightIconandTextColor,
                                    ),
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
                                  child: Text(
                                    'Bu seviyeyi başarıyla tamamladın. Sıra gelecek seviyede!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: themeBox.get('tema') == 'dark'
                                          ? dialogDarkIconandTextColor
                                          : dialogLightIconandTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              ValueListenableBuilder<Box>(
                                  valueListenable: _sudokuKutu
                                      .listenable(keys: ['currentLevel']),
                                  builder: (context, box, snapshot) {
                                    if (box.get('currentLevel') ==
                                        "Çok Kolay") {
                                      _sudokuKutu.put('nextLevel', 'Kolay');
                                    } else if (box.get('currentLevel') ==
                                        "Kolay") {
                                      _sudokuKutu.put('nextLevel', 'Orta');
                                    } else if (box.get('currentLevel') ==
                                        "Orta") {
                                      _sudokuKutu.put('nextLevel', 'Zor');
                                    } else if (box.get('currentLevel') ==
                                        "Zor") {
                                      _sudokuKutu.put('nextLevel', 'Çok Zor');
                                    } else if (box.get('currentLevel') ==
                                        "Çok Zor") {
                                      _sudokuKutu.put('nextLevel', 'İmkansız');
                                    } else if (box.get('currentLevel') ==
                                        "İmkansız") {
                                      _sudokuKutu.put('nextLevel', 'İmkansız');
                                    }
                                    return Container(
                                      margin: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: themeBox.get('tema') == 'dark'
                                            ? dialogDarkTryAgainOrNextButtonColor
                                            : dialogLightTryAgainOrNextButtonColor,
                                      ),
                                      alignment: Alignment.center,
                                      child: MaterialButton(
                                        onPressed: () {
                                          _sudokuKutu.put('sudokuRows', null);

                                          String currentLevel =
                                              box.get('currentLevel');
                                          if (currentLevel == "Çok Kolay") {
                                            _sudokuKutu.put(
                                                'nextLevel', 'Kolay');
                                            _sudokuKutu.put('seviye', "Kolay");
                                            _sudokuKutu.put('sudokuRows', null);
                                            nextLevelName = 'Kolay';
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const Sudoku(),
                                              ),
                                              (route) => false,
                                            );
                                          } else if (currentLevel == "Kolay") {
                                            _sudokuKutu.put(
                                                'nextLevel', 'Orta');
                                            _sudokuKutu.put('seviye', "Orta");
                                            _sudokuKutu.put('sudokuRows', null);
                                            nextLevelName = 'Orta';
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
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
                                                builder:
                                                    (BuildContext context) =>
                                                        const Sudoku(),
                                              ),
                                              (route) => false,
                                            );
                                          } else if (currentLevel == "Zor") {
                                            _sudokuKutu.put(
                                                'nextLevel', 'Çok Zor');

                                            _sudokuKutu.put(
                                                'seviye', "Çok Zor");
                                            _sudokuKutu.put('sudokuRows', null);
                                            nextLevelName = 'Çok Zor';
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const Sudoku(),
                                              ),
                                              (route) => false,
                                            );
                                          } else if (currentLevel ==
                                              "Çok Zor") {
                                            _sudokuKutu.put(
                                                'nextLevel', 'İmkansız');

                                            _sudokuKutu.put(
                                                'seviye', "İmkansız");
                                            _sudokuKutu.put('sudokuRows', null);
                                            nextLevelName = 'İmkansız';

                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const Sudoku(),
                                              ),
                                              (route) => false,
                                            );
                                          }
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: themeBox.get('tema') ==
                                                    'dark'
                                                ? dialogDarkTryAgainOrNextButtonColor
                                                : dialogLightTryAgainOrNextButtonColor,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Sonraki Seviyeye Geç \n'
                                            '${_sudokuKutu.get('nextLevel')}',
                                            style: TextStyle(
                                              color: themeBox.get('tema') ==
                                                      'dark'
                                                  ? dialogDarkIconandTextColor
                                                  : dialogLightIconandTextColor,
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.center,
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
                                                builder: (builder) =>
                                                    const Giris(
                                                  lose: true,
                                                ),
                                              ),
                                              (route) => false);
                                          Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () {
                                              _clearBox();

                                              setState(
                                                () {
                                                  // Here you can write your code for open new view
                                                },
                                              );
                                            },
                                          );
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        color: themeBox.get('tema') == 'dark'
                                            ? dialogDarkCasualButtonColor
                                            : dialogLightCasualButtonColor,
                                        child: Text(
                                          'Ana Menüye Dön',
                                          style: TextStyle(
                                            color:
                                                dialogDarkCasualButtonTextColor,
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
                                            MaterialPageRoute(
                                                builder: (_) => const Sudoku()),
                                          );
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        color: themeBox.get('tema') == 'dark'
                                            ? dialogDarkCasualButtonColor
                                            : dialogLightCasualButtonColor,
                                        child: Text(
                                          'Yeniden Başlat',
                                          style: TextStyle(
                                            color:
                                                dialogDarkCasualButtonTextColor,
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
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
