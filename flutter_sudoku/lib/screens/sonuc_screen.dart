import 'package:flutter/material.dart';
import 'package:flutter_sudoku/screens/dil.dart';

class Sonuc extends StatefulWidget {
  const Sonuc({Key? key}) : super(key: key);

  @override
  State<Sonuc> createState() => _SonucState();
}

class _SonucState extends State<Sonuc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(dil['sonuc_title'])),
    );
  }
}
