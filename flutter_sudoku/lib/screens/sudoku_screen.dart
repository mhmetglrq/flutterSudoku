import 'dart:async';
import 'dart:convert';
import 'dart:math';

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
        title: Text(dil['sudoku_title']),
        actions: [
          IconButton(
              onPressed: _sudokuOlustur,
              icon: const Icon(Icons.refresh_rounded)),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ValueListenableBuilder<Box>(
                valueListenable: _sudokuKutu.listenable(keys: ['sure']),
                builder: (context, box, widget) {
                  String sure = Duration(seconds: box.get('sure')).toString();
                  return Text(sure.split('.').first);
                }),
          )),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(_sudokuKutu.get('seviye', defaultValue: dil['seviye2'])),
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
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.all(8),
                      color: Colors.blueGrey,
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
                                                  margin:
                                                      const EdgeInsets.all(1),
                                                  color: xC == x && yC == y
                                                      ? Colors.green
                                                      : Colors.deepPurple
                                                          .withOpacity(
                                                              xC == x || yC == y
                                                                  ? 0.6
                                                                  : 1.0),
                                                  alignment: Alignment.center,
                                                  child:
                                                      "${replaceRows![x][y]}"
                                                              .startsWith("e")
                                                          ? Text(
                                                              replaceRows[x][y]
                                                                  .toString()
                                                                  .substring(1),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 22),
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
                                                                                            style: const TextStyle(fontSize: 10),
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
                                                                        replaceRows[x][y] !=
                                                                                "0"
                                                                            ? replaceRows[x][y].toString()
                                                                            : "",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                20),
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
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Card(
                                    margin: const EdgeInsets.all(2.5),
                                    color: Colors.amber,
                                    child: InkWell(
                                      onTap: () {
                                        String xy = _sudokuKutu.get(
                                          'xy',
                                        );
                                        if (xy != "99") {
                                          int xC =
                                                  int.parse(xy.substring(0, 1)),
                                              yC = int.parse(xy.substring(1));
                                          _sudoku[xC][yC] = "0";
                                          _sudokuKutu.put(
                                              'sudokuRows', _sudoku);
                                          _adimKaydet();
                                        }
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.delete_sharp,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            'Sil',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: ValueListenableBuilder<Box>(
                                      valueListenable: _sudokuKutu
                                          .listenable(keys: ['ipucu']),
                                      builder: (context, box, widget) {
                                        return Card(
                                          margin: const EdgeInsets.all(2.5),
                                          color: Colors.amber,
                                          child: InkWell(
                                            onTap: () {
                                              String xy = box.get(
                                                'xy',
                                              );
                                              if (xy != "99" &&
                                                  box.get("ipucu") > 0) {
                                                int xC = int.parse(
                                                        xy.substring(0, 1)),
                                                    yC = int.parse(
                                                        xy.substring(1));
                                                String cozumString =
                                                    box.get('_sudokuString');

                                                List cozumSudoku =
                                                    List.generate(
                                                  9,
                                                  (index) => List.generate(
                                                    9,
                                                    (j) => cozumString
                                                        .substring(index * 9,
                                                            (index + 1) * 9)
                                                        .split("")[j],
                                                  ),
                                                );
                                                if (_sudoku[xC][yC] !=
                                                    cozumSudoku[xC][yC]) {
                                                  _sudoku[xC][yC] =
                                                      cozumSudoku[xC][yC];
                                                  box.put(
                                                      'sudokuRows', _sudoku);
                                                  box.put("ipucu",
                                                      box.get("ipucu") - 1);
                                                  _adimKaydet();
                                                }
                                              }
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.lightbulb,
                                                      color: Colors.black,
                                                    ),
                                                    Text(
                                                        ": ${box.get("ipucu")}")
                                                  ],
                                                ),
                                                const Text(
                                                  'İpucu',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Card(
                                    margin: const EdgeInsets.all(2.5),
                                    color: _note
                                        ? Colors.amber.withOpacity(0.6)
                                        : Colors.amber,
                                    child: InkWell(
                                      onTap: () =>
                                          setState(() => _note = !_note),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.note_add,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            'Not',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Card(
                                    margin: const EdgeInsets.all(2.5),
                                    color: Colors.amber,
                                    child: InkWell(
                                      onTap: () {
                                        if (_sudokuHistory.length > 1) {
                                          _sudokuHistory.removeLast();
                                          Map onceki =
                                              jsonDecode(_sudokuHistory.last);
                                          /* Map historyItem = {
                                          'sudokuRows': _sudokuKutu.get('sudokuRows'),
                                          'xy': _sudokuKutu.get('xy'),
·                                          'ipucu': _sudokuKutu.get('ipucu'),
                                        }; */

                                          _sudokuKutu.put('sudokuRows',
                                              onceki['sudokuRows']);
                                          _sudokuKutu.put('xy', onceki['xy']);
                                          _sudokuKutu.put(
                                              'ipucu', onceki['ipucu']);

                                          _sudokuKutu.put(
                                              'sudokuHistory', _sudokuHistory);
                                          _sudoku = onceki[
                                              'sudokuRows']; // Sayılar geri alındıktan sonra farklı bir sayı girildiğinde silinen sayıların geri dönmemesi için
                                        }

                                        print(_sudokuHistory.length);
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.undo,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            'Geri Al',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        ],
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
                                        int xC = int.parse(xy.substring(0, 1)),
                                            yC = int.parse(xy.substring(1));
                                        if (!_note) {
                                          _sudoku[xC][yC] = "${i + j}";
                                        } else {
                                          if ("${_sudoku[xC][yC]}".length < 8) {
                                            _sudoku[xC][yC] = "000000000";
                                          }

                                          _sudoku[xC][yC] =
                                              "${_sudoku[xC][yC]}".replaceRange(
                                            i + j - 1,
                                            i + j,
                                            "${_sudoku[xC][yC]}".substring(
                                                        i + j - 1, i + j) ==
                                                    "${i + j}"
                                                ? "0"
                                                : "${i + j}",
                                          );
                                        }

                                        _sudokuKutu.put('sudokuRows', _sudoku);
                                        _adimKaydet();
                                        print("${i + j}");
                                      }
                                    },
                                    child: Card(
                                      shape: const CircleBorder(),
                                      color: Colors.amber,
                                      child: Container(
                                        margin: const EdgeInsets.all(3),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${i + j}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
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
            )
          ],
        ),
      ),
    );
  }
}
