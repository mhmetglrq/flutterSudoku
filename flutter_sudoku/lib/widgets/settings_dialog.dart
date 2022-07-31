import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late Box _sudokuKutu;
  late String _sudokuString;
  final List _sudoku = [];
  String? nextLevelName;
  Future<Box> _kutuAc() async {
    _sudokuKutu = await Hive.openBox('sudoku');

    return await Hive.openBox('finished_sudokus');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AspectRatio(
        aspectRatio: 0.75,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFF3A015C),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(15),
                  child: const Text(
                    'Ayarlar',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: const Color(0xFFDAFFED),
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
                      Container(
                        margin: const EdgeInsets.all(4),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(1),
                          child: const Text(
                            'Tema',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(1),
                                    child: const Text(
                                      'Koyu',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset(
                                    'assets/icon.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(1),
                                    child: const Text(
                                      'Açık',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  child: Container(
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(
                                      'assets/icon.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              FutureBuilder<Box>(
                future: _kutuAc(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ValueListenableBuilder<Box>(
                      valueListenable: snapshot.data!.listenable(),
                      builder: (context, box, snapshot) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFF6184D8),
                          ),
                          alignment: Alignment.center,
                          child: MaterialButton(
                            onPressed: () {
                              setState(
                                () {
                                  box.clear();
                                },
                              );
                              Navigator.pop(
                                context,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFF6184D8),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Sıfırla',
                                style: TextStyle(
                                  color: Color(0xFFDAFFED),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: const Color(0xFFDAFFED),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.all(4),
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(20),
                  child: const Text(
                    'Geliştirici \n Mehmet Güler',
                    style: TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
