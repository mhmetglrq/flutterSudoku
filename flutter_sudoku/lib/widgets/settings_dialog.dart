import 'package:flutter/material.dart';
import 'package:flutter_sudoku/screens/color.dart';
import 'package:flutter_sudoku/screens/giris_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late Box _sudokuKutu;

  String? nextLevelName;
  Future<Box> _kutuAc() async {
    _sudokuKutu = await Hive.openBox('sudoku');

    return await Hive.openBox('finished_sudokus');
  }

  Future<Box> _temaKutuAc() async {
    return await Hive.openBox('ayarlar');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
      future: _temaKutuAc(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ValueListenableBuilder<Box>(
              valueListenable: snapshot.data!.listenable(),
              builder: (context, themeBox, _) {
                return Dialog(
                  backgroundColor: transparent,
                  child: AspectRatio(
                    aspectRatio: 0.85,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: themeBox.get('tema') == 'dark'
                            ? dialogDarkBgColor
                            : dialogLightBgColor,
                      ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              alignment: Alignment.center,
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(10),
                                child: Text(
                                  'Ayarlar',
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
                          ),
                          Expanded(
                            flex: 11,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: themeBox.get('tema') == 'dark'
                                      ? dialogDarkIconandTextColor
                                      : dialogLightIconandTextColor,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.all(4),
                              alignment: Alignment.center,
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: const EdgeInsets.all(4),
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.all(1),
                                          child: Text(
                                            'Tema',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: themeBox.get('tema') ==
                                                      'dark'
                                                  ? dialogDarkIconandTextColor
                                                  : dialogLightIconandTextColor,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 17,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                themeBox.put('tema', 'dark');
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: themeBox
                                                                .get('tema') ==
                                                            'dark'
                                                        ? dialogDarkIconandTextColor
                                                        : dialogLightIconandTextColor,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              4),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        margin: const EdgeInsets
                                                            .all(1),
                                                        child: Text(
                                                          'Koyu',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: themeBox.get(
                                                                        'tema') ==
                                                                    'dark'
                                                                ? dialogDarkIconandTextColor
                                                                : dialogLightIconandTextColor,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                          width: 2,
                                                          color: themeBox.get(
                                                                      'tema') ==
                                                                  'dark'
                                                              ? dialogDarkIconandTextColor
                                                              : dialogLightIconandTextColor,
                                                        ),
                                                      ),
                                                      child: Image.asset(
                                                        'assets/icon.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                themeBox.put('tema', 'light');
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: themeBox
                                                                .get('tema') ==
                                                            'dark'
                                                        ? dialogDarkIconandTextColor
                                                        : dialogLightIconandTextColor,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              4),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        margin: const EdgeInsets
                                                            .all(1),
                                                        child: Text(
                                                          'Açık',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: themeBox.get(
                                                                        'tema') ==
                                                                    'dark'
                                                                ? dialogDarkIconandTextColor
                                                                : dialogLightIconandTextColor,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .all(6),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                            width: 2,
                                                            color: themeBox.get(
                                                                        'tema') ==
                                                                    'dark'
                                                                ? dialogDarkIconandTextColor
                                                                : dialogLightIconandTextColor,
                                                          ),
                                                        ),
                                                        child: Image.asset(
                                                          'assets/iconLight.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                          ),
                          Expanded(
                            flex: 2,
                            child: FutureBuilder<Box>(
                              future: _kutuAc(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ValueListenableBuilder<Box>(
                                    valueListenable:
                                        snapshot.data!.listenable(),
                                    builder: (context, box, snapshot) {
                                      return InkWell(
                                        onTap: () {
                                          setState(
                                            () {
                                              box.clear();
                                              _sudokuKutu.clear();
                                            },
                                          );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Giris(
                                                          lose: false)));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: themeBox.get('tema') ==
                                                    'dark'
                                                ? dialogDarkTryAgainOrNextButtonColor
                                                : dialogLightTryAgainOrNextButtonColor,
                                          ),
                                          alignment: Alignment.center,
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
                                              'Sıfırla',
                                              style: TextStyle(
                                                color: themeBox.get('tema') ==
                                                        'dark'
                                                    ? dialogDarkIconandTextColor
                                                    : dialogLightIconandTextColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: themeBox.get('tema') == 'dark'
                                      ? dialogDarkIconandTextColor
                                      : dialogLightIconandTextColor,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.all(4),
                              alignment: Alignment.center,
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(10),
                                child: Text(
                                  'Never Ever STUDIO',
                                  style: TextStyle(
                                    fontFamily: 'Visitor',
                                    fontSize: 25,
                                    color: themeBox.get('tema') == 'dark'
                                        ? dialogDarkIconandTextColor
                                        : dialogLightIconandTextColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
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
      },
    );
  }
}
