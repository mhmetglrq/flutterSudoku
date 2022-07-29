import 'package:flutter/material.dart';
import 'package:flutter_sudoku/screens/giris_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoseScreen extends StatelessWidget {
  const LoseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Box sudokuKutu = Hive.box('sudoku');
    sudokuKutu.put('sudokuRows', null);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 8,
            child: Container(
              alignment: Alignment.center,
              child: const Text('Kaybettin.'),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => const Giris()),
                      (route) => false);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: const Color(0xFF312C51),
                child: const Text('Ana Menüye Dön'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
