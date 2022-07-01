import 'dart:async';
import 'dart:convert';
import 'dart:math';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/screens/dil.dart';
import 'package:flutter_sudoku/sudokular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wakelock/wakelock.dart';

final Map<String, int> sudokuSeviyeleri = {
  dil['seviye1']: 62,
  dil['seviye2']: 53,
  dil['seviye3']: 44,
  dil['seviye4']: 35,
  dil['seviye5']: 26,
  dil['seviye6']: 17,
};

class Sudoku extends StatefulWidget {
  const Sudoku({Key? key}) : super(key: key);

  @override
  State<Sudoku> createState() => _SudokuState();
}

class _SudokuState extends State<Sudoku> {
  final Box _sudokuKutu = Hive.box('sudoku');

  List _sudoku = [], _sudokuHistory = [];
  late Timer _sayac;
  late String _sudokuString;

  bool _note = false;
  bool _finished = false;
  void _sudokuOlustur() {
    int? gorulecekSayisi = sudokuSeviyeleri[
        _sudokuKutu.get('seviye', defaultValue: dil['seviye2'])];

    _sudokuString = sudokular[Random().nextInt(sudokular.length)];
    _sudokuKutu.put('_sudokuString', _sudokuString);

    _sudoku = List.generate(
      9,
      (index) => List.generate(
        9,
        (j) =>
            "e${_sudokuString.substring(index * 9, (index + 1) * 9).split("")[j]}",
      ),
    );

    int i = 0;
    while (i < 81 - gorulecekSayisi!) {
      int x = Random().nextInt(9);
      int y = Random().nextInt(9);
      if (_sudoku[x][y] != "0") {
        _sudoku[x][y] = "0";
        i++;
      }
    }

    _sudokuKutu.put('sudokuRows', _sudoku);
    _sudokuKutu.put('xy', "99");
    _sudokuKutu.put('ipucu', 39);
    _sudokuKutu.put('sure', 0);

    print(gorulecekSayisi);
    print(_sudokuString);
  }

  void _adimKaydet() {
    String sudoSonDurum = _sudokuKutu.get('sudokuRows').toString();
    if (sudoSonDurum.contains("0")) {
      Map historyItem = {
        'sudokuRows': _sudokuKutu.get('sudokuRows'),
        'xy': _sudokuKutu.get('xy'),
        'ipucu': _sudokuKutu.get('ipucu')
      };
      _sudokuHistory.add(jsonEncode(historyItem));
      _sudokuKutu.put('sudokuHistory', _sudokuHistory);
    } else {
      _sudokuString = _sudokuKutu.get('_sudokuString');
      String kontrol = sudoSonDurum.replaceAll(RegExp(r'[e, \][]'), '');
      print(_sudokuString);
      if (kontrol == _sudokuString) {
        Fluttertoast.showToast(
          msg: 'Tebrikler sudokuyu başarıyla bitirdiniz',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
        Box tamamlananKutusu = Hive.box('finished_sudokus');
        Map tamamlananSudoku = {
          'tarih': DateTime.now(),
          'cozulmus': _sudokuKutu.get('sudokuRows'),
          'sure': _sudokuKutu.get('sure'),
          'sudokuHistory': _sudokuKutu.get('sudokuHistory')
        };
        tamamlananKutusu.add(tamamlananSudoku);
        _sudokuKutu.put('sudokuRows', null);
        _finished = true;
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: 'Sudokunuz hatalı',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      }

      print(kontrol);
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    if (_sudokuKutu.get('sudokuRows') == null) {
      _sudokuOlustur();
    } else {
      _sudoku = _sudokuKutu.get('sudokuRows');
    }

    _sayac = Timer.periodic(const Duration(seconds: 1), (timer) {
      int sure = _sudokuKutu.get('sure');
      _sudokuKutu.put('sure', ++sure);
    });
  }

  @override
  void dispose() {
    // ignore: unnecessary_null_comparison
    if (_sayac != null && _sayac.isActive) {
      _sayac.cancel();
    }
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: const Color(0xFF0F110C),
        // title: Text(dil['sudoku_title']),
        actions: [
          Expanded(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              color: const Color(0xFFF1AA9B),
              icon: const Icon(Icons.arrow_back_ios_outlined),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {
                if (_sudokuHistory.length > 1) {
                  _sudokuHistory.removeLast();
                  Map onceki = jsonDecode(_sudokuHistory.last);
                  /* Map historyItem = {
                                            'sudokuRows': _sudokuKutu.get('sudokuRows'),
                                            'xy': _sudokuKutu.get('xy'),
                                                ·                                          'ipucu': _sudokuKutu.get('ipucu'),
                                          }; */

                  _sudokuKutu.put('sudokuRows', onceki['sudokuRows']);
                  _sudokuKutu.put('xy', onceki['xy']);
                  _sudokuKutu.put('ipucu', onceki['ipucu']);

                  _sudokuKutu.put('sudokuHistory', _sudokuHistory);
                  _sudoku = onceki[
                      'sudokuRows']; // Sayılar geri alındıktan sonra farklı bir sayı girildiğinde silinen sayıların geri dönmemesi için
                }

                print(_sudokuHistory.length);
              },
              color: const Color(0xFFF1AA9B),
              icon: const Icon(
                FeatherIcons.skipBack,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: _sudokuOlustur,
              color: const Color(0xFFF1AA9B),
              icon: const Icon(
                Icons.new_label,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Box>(
              valueListenable: _sudokuKutu.listenable(keys: ['ipucu']),
              builder: (context, box, widget) {
                return IconButton(
                  onPressed: () {
                    String xy = box.get(
                      'xy',
                    );
                    if (xy != "99" && box.get("ipucu") > 0) {
                      int xC = int.parse(xy.substring(0, 1)),
                          yC = int.parse(xy.substring(1));
                      String cozumString = box.get('_sudokuString');

                      List cozumSudoku = List.generate(
                        9,
                        (index) => List.generate(
                          9,
                          (j) => cozumString
                              .substring(index * 9, (index + 1) * 9)
                              .split("")[j],
                        ),
                      );
                      if (_sudoku[xC][yC] != cozumSudoku[xC][yC]) {
                        _sudoku[xC][yC] = cozumSudoku[xC][yC];
                        box.put('sudokuRows', _sudoku);
                        box.put("ipucu", box.get("ipucu") - 1);
                        _adimKaydet();
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.light_mode,
                    color: Color(0xFFF1AA9B),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF0F110C),
        child: Center(
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ValueListenableBuilder<Box>(
                    valueListenable:
                        _sudokuKutu.listenable(keys: ['xy', 'sudokuRows']),
                    builder: (context, box, widget) {
                      String xy = box.get(
                        'xy',
                      );
                      int xC = int.parse(xy.substring(0, 1)),
                          yC = int.parse(xy.substring(1));
                      List? sudokuRows = box.get('sudokuRows');
                      var replaceRows = sudokuRows;
                      return Container(
                        padding: const EdgeInsets.all(3),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F110C),
                          borderRadius: BorderRadius.circular(15),
                          // border: Border.all(
                          //   width: 1,
                          //   color: const Color(0xFFCCFCCB),
                          // ),
                        ),
                        child: Column(
                          children: <Widget>[
                            for (int x = 0; x < 9; x++)
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          for (int y = 0; y < 9; y++)
                                            Expanded(
                                                child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: xC == x && yC == y
                                                          ? const Color(
                                                              0xFF541690)
                                                          : xC == x || yC == y
                                                              ? const Color(
                                                                  0xFF48426D)
                                                              : const Color(
                                                                  0xFF312C51),
                                                    ),
                                                    margin:
                                                        const EdgeInsets.all(
                                                            1.2),
                                                    alignment: Alignment.center,
                                                    child:
                                                        "${replaceRows![x][y]}"
                                                                .startsWith("e")
                                                            ? Text(
                                                                replaceRows[x]
                                                                        [y]
                                                                    .toString()
                                                                    .substring(
                                                                        1),
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 20,
                                                                  color: Color(
                                                                      0xFFF1AA9B),
                                                                ),
                                                              )
                                                            : InkWell(
                                                                onTap: () {
                                                                  _sudokuKutu.put(
                                                                      'xy',
                                                                      "$x$y");
                                                                },
                                                                child: Center(
                                                                  child: "${replaceRows[x][y]}"
                                                                              .length >
                                                                          8
                                                                      ? Column(
                                                                          children: [
                                                                            for (int i = 0;
                                                                                i < 9;
                                                                                i += 3)
                                                                              Expanded(
                                                                                child: Center(
                                                                                  child: Row(
                                                                                    children: [
                                                                                      for (int j = 0; j < 3; j++)
                                                                                        Expanded(
                                                                                          child: Center(
                                                                                            child: Text(
                                                                                              "${replaceRows[x][y]}".split('')[i + j] == "0" ? "" : "${replaceRows[x][y]}".split('')[i + j],
                                                                                              style: const TextStyle(
                                                                                                fontSize: 10,
                                                                                                color: Color(0xFFF1AA9B),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                          ],
                                                                        )
                                                                      : Text(
                                                                          replaceRows[x][y] != "0"
                                                                              ? replaceRows[x][y].toString()
                                                                              : "",
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            color:
                                                                                Color(0xFFF1AA9B),
                                                                          ),
                                                                        ),
                                                                ),
                                                              ),
                                                  ),
                                                ),
                                                if (y == 2 || y == 5)
                                                  const SizedBox(
                                                    width: 2,
                                                  ),
                                              ],
                                            )),
                                        ],
                                      ),
                                    ),
                                    if (x == 2 || x == 5)
                                      const SizedBox(
                                        height: 2,
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFF1AA9B),
                        ),
                      ),
                      child: Text(
                        _sudokuKutu.get('seviye', defaultValue: dil['seviye2']),
                        style: const TextStyle(
                          color: Color(0xFFF1AA9B),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ValueListenableBuilder<Box>(
                            valueListenable:
                                _sudokuKutu.listenable(keys: ['sure']),
                            builder: (context, box, widget) {
                              String sure =
                                  Duration(seconds: box.get('sure')).toString();
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    width: 1,
                                    color: const Color(0xFFF1AA9B),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Icon(
                                        FeatherIcons.clock,
                                        size: 15,
                                        color: Color(0xFFF1AA9B),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        sure.split('.').first,
                                        style: const TextStyle(
                                          color: Color(0xFFF1AA9B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            // color: Colors.amber,
                            border: Border.all(
                              width: 1,
                              color: const Color(0xFFF1AA9B),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    for (int i = 1; i < 10; i += 3)
                                      Expanded(
                                          child: Row(
                                        children: <Widget>[
                                          for (int j = 0; j < 3; j++)
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  String xy = _sudokuKutu.get(
                                                    'xy',
                                                  );
                                                  if (xy != "99") {
                                                    int xC = int.parse(
                                                            xy.substring(0, 1)),
                                                        yC = int.parse(
                                                            xy.substring(1));
                                                    if (!_note) {
                                                      _sudoku[xC][yC] =
                                                          "${i + j}";
                                                    } else {
                                                      if ("${_sudoku[xC][yC]}"
                                                              .length <
                                                          8) {
                                                        _sudoku[xC][yC] =
                                                            "000000000";
                                                      }

                                                      _sudoku[xC][yC] =
                                                          "${_sudoku[xC][yC]}"
                                                              .replaceRange(
                                                        i + j - 1,
                                                        i + j,
                                                        "${_sudoku[xC][yC]}"
                                                                    .substring(
                                                                        i +
                                                                            j -
                                                                            1,
                                                                        i + j) ==
                                                                "${i + j}"
                                                            ? "0"
                                                            : "${i + j}",
                                                      );
                                                    }

                                                    _sudokuKutu.put(
                                                        'sudokuRows', _sudoku);
                                                    _adimKaydet();
                                                    print("${i + j}");
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    // color:
                                                    //     const Color(0xFFF1FFFA),
                                                    // border: const Border(
                                                    //   bottom: BorderSide(
                                                    //       width: 1.0,
                                                    //       color: Color(
                                                    //           0xFF6C72CB)),
                                                    //   top: BorderSide(
                                                    //       width: 1.0,
                                                    //       color: Color(
                                                    //           0xFF6C72CB)),
                                                    //   left: BorderSide(
                                                    //       width: 1.0,
                                                    //       color: Color(
                                                    //           0xFF6C72CB)),
                                                    //   right: BorderSide(
                                                    //       width: 1.0,
                                                    //       color: Color(
                                                    //           0xFF6C72CB)),
                                                    // ),
                                                  ),
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "${i + j}",
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFFF1AA9B),
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                // color: Colors.amber,
                                border: Border.all(
                                  width: 1,
                                  color: _note
                                      ? const Color(0xFF6C72CB)
                                      : const Color(0xFFF1AA9B),
                                ),
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () =>
                                      setState(() => _note = !_note),
                                  icon: Icon(
                                    FeatherIcons.clipboard,
                                    color: _note
                                        ? const Color(0xFF6C72CB)
                                        : const Color(0xFFF1AA9B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                // color: Colors.amber,
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xFFF1AA9B),
                                ),
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    String xy = _sudokuKutu.get(
                                      'xy',
                                    );
                                    if (xy != "99") {
                                      int xC = int.parse(xy.substring(0, 1)),
                                          yC = int.parse(xy.substring(1));
                                      _sudoku[xC][yC] = "0";
                                      _sudokuKutu.put('sudokuRows', _sudoku);
                                      _adimKaydet();
                                    }
                                  },
                                  icon: const Icon(
                                    FeatherIcons.trash,
                                    color: Color(0xFFF1AA9B),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
