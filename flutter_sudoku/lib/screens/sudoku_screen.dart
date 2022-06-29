import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sudoku/screens/dil.dart';
import 'package:flutter_sudoku/sudokular.dart';
import 'package:hive/hive.dart';

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
  final List<List<int>> ornek = [
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
  ];
  final Box _sudokuKutusu = Hive.box('sudoku');
  List<List> _sudoku = [];
  late String _sudokuString;
  void _sudokuOlustur() {
    int? gorulecekSayisi = sudokuSeviyeleri[
        _sudokuKutusu.get('seviye', defaultValue: dil['seviye2'])];
    _sudokuString = sudokular[Random().nextInt(sudokular.length)];

    _sudoku = List.generate(
      9,
      (index) => List.generate(
        9,
        (j) => int.tryParse(
            _sudokuString.substring(index * 9, (index + 1) * 9).split("")[j]),
      ),
    );

    int i = 0;
    while (i < 81 - gorulecekSayisi!) {
      int x = Random().nextInt(9);
      int y = Random().nextInt(9);
      if (_sudoku[x][y] != 0) {
        _sudoku[x][y] = 0;
        i++;
      }
    }

    setState(() {});

    print(gorulecekSayisi);
    print(_sudokuString);
  }

  @override
  void initState() {
    _sudokuOlustur();
    super.initState();
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
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(_sudokuKutusu.get('seviye', defaultValue: dil['seviye2'])),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
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
                                            margin: const EdgeInsets.all(1),
                                            color: Colors.deepPurple,
                                            alignment: Alignment.center,
                                            child: Text(_sudoku[x][y] > 0
                                                ? _sudoku[x][y].toString()
                                                : ""),
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
              ),
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
                                    child: Container(
                                      margin: const EdgeInsets.all(3),
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      margin: const EdgeInsets.all(3),
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Card(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      margin: const EdgeInsets.all(3),
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      margin: const EdgeInsets.all(3),
                                      color: Colors.amber,
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
                                      print("${i + j}");
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
