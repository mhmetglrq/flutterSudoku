import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sudoku/screens/color.dart';
import 'package:flutter_sudoku/screens/sudoku_screen.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/settings_dialog.dart';
import 'dil.dart';

class Giris extends StatefulWidget {
  final bool lose;
  const Giris({final Key? key, required this.lose}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GirisState createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  late Box _sudokuKutu;
  late Box _sudokuTemaKutu;
  Future<Box> _kutuAc() async {
    _sudokuKutu = await Hive.openBox('sudoku');
    _sudokuTemaKutu = await Hive.openBox('ayarlar');

    return await Hive.openBox('finished_sudokus');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: FutureBuilder<Box>(
        future: _kutuAc(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ValueListenableBuilder<Box>(
                valueListenable: Hive.box('ayarlar').listenable(),
                builder: (context, themeBox, _) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: themeBox.get('tema') == 'dark'
                          ? girisDarkAppBarColor
                          : girisLightAppBarColor,
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      actions: <Widget>[
                        Expanded(
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: themeBox.get('tema') == 'dark'
                                        ? const AssetImage(
                                            'assets/icon.png',
                                          )
                                        : const AssetImage(
                                            'assets/iconLight.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'ZENSUDOKU',
                              style: TextStyle(
                                  fontFamily: 'Visitor',
                                  fontSize: 30,
                                  color: themeBox.get('tema') == 'dark'
                                      ? girisDarkBaslikColor
                                      : girisLightBaslikColor),
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(
                              Icons.settings,
                              color: themeBox.get('tema') == 'dark'
                                  ? girisDarkBaslikColor
                                  : girisLightBaslikColor,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => const SettingsDialog(),
                                  useSafeArea: false);
                            },
                          ),
                        ),
                      ],
                    ),
                    body: Container(
                      decoration: BoxDecoration(
                        color: themeBox.get('tema') == 'dark'
                            ? girisDarkBgColor
                            : girisLightBgColor,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: ValueListenableBuilder<Box>(
                        valueListenable: snapshot.data!.listenable(),
                        builder: (context, box, _) {
                          return Column(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: AspectRatio(
                                  aspectRatio: 6,
                                  child: Center(
                                    child: Text(
                                      "Eski Oyunlar",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 22,
                                        color: themeBox.get('tema') == 'dark'
                                            ? girisDarkBaslikColor
                                            : girisLightBaslikColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 12,
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      width: 3,
                                      color: themeBox.get('tema') == 'dark'
                                          ? girisDarkBoxBorderColor
                                          : girisLightBoxBorderColor,
                                    ),
                                  ),
                                  child: box.length == 0
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              //Text Tipi değişicek
                                              dil['tamamlanan_yok'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 24.0,
                                                  color: themeBox.get('tema') ==
                                                          'dark'
                                                      ? girisDarkBaslikColor
                                                      : girisLightBaslikColor),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: box.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var model = box.values.elementAt(
                                                (box.length - 1) - index);
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: AspectRatio(
                                                        aspectRatio: 3,
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),

                                                            // border: Border.all(
                                                            //   width: 1,
                                                            //   color: Colors.white,
                                                            // ),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  model['tarih']
                                                                      .toString()
                                                                      .split(
                                                                          '.')
                                                                      .elementAt(
                                                                          0),
                                                                  style:
                                                                      GoogleFonts
                                                                          .oswald(
                                                                    textStyle: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            18,
                                                                        color: themeBox.get('tema') ==
                                                                                'dark'
                                                                            ? girisDarkBaslikColor
                                                                            : girisLightBaslikColor),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  "${Duration(seconds: model['sure'])}"
                                                                      .split(
                                                                          '.')
                                                                      .first,
                                                                  style: GoogleFonts
                                                                      .passionOne(
                                                                    textStyle: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize:
                                                                            18,
                                                                        color: themeBox.get('tema') ==
                                                                                'dark'
                                                                            ? girisDarkBaslikColor
                                                                            : girisLightBaslikColor),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: AspectRatio(
                                                        aspectRatio: 3,
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                              width: 1,
                                                              color: themeBox.get(
                                                                          'tema') ==
                                                                      'dark'
                                                                  ? girisDarkBoxBorderColor
                                                                  : girisLightBoxBorderColor,
                                                            ),
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            model['seviye']
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: themeBox.get(
                                                                            'tema') ==
                                                                        'dark'
                                                                    ? girisDarkBaslikColor
                                                                    : girisLightBaslikColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    //   width: 1,
                                    //   color: Color(0xFFF1AA9B),
                                    // ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: AspectRatio(
                                          aspectRatio: 4,
                                          child: Center(
                                            child: Text(
                                              "Seviyeler",
                                              style: GoogleFonts.syne(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 22,
                                                  color: themeBox.get('tema') ==
                                                          'dark'
                                                      ? girisDarkBaslikColor
                                                      : girisLightBaslikColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              width: 2,
                                              color: themeBox.get('tema') ==
                                                      'dark'
                                                  ? girisDarkBoxBorderColor
                                                  : girisLightBoxBorderColor,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (_sudokuKutu
                                                              .isOpen) {
                                                            _sudokuKutu.put(
                                                                'seviye',
                                                                "İmkansız");
                                                            _sudokuKutu.put(
                                                                'sudokuRows',
                                                                null);

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      const Sudoku()),
                                                            );
                                                          }
                                                        },
                                                        child: Center(
                                                          child: AspectRatio(
                                                            aspectRatio: 5,
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(4),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: themeBox.get(
                                                                            'tema') ==
                                                                        'dark'
                                                                    ? girisDarkButtonColor
                                                                    : girisLightButtonColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: Text(
                                                                "İmkansız",
                                                                style:
                                                                    GoogleFonts
                                                                        .oswald(
                                                                  textStyle:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        18,
                                                                    color: themeBox.get('tema') ==
                                                                            'dark'
                                                                        ? girisDarkBaslikColor
                                                                        : girisLightBaslikColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //zor
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (_sudokuKutu
                                                              .isOpen) {
                                                            _sudokuKutu.put(
                                                                'seviye',
                                                                "Zor");
                                                            _sudokuKutu.put(
                                                                'sudokuRows',
                                                                null);

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      const Sudoku()),
                                                            );
                                                          }
                                                        },
                                                        child: Center(
                                                          child: AspectRatio(
                                                            aspectRatio: 3,
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(4),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: themeBox.get(
                                                                            'tema') ==
                                                                        'dark'
                                                                    ? girisDarkButtonColor
                                                                    : girisLightButtonColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: Text(
                                                                "Zor",
                                                                style:
                                                                    GoogleFonts
                                                                        .oswald(
                                                                  textStyle:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        18,
                                                                    color: themeBox.get('tema') ==
                                                                            'dark'
                                                                        ? girisDarkBaslikColor
                                                                        : girisLightBaslikColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    //Çok Zor
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (_sudokuKutu
                                                              .isOpen) {
                                                            _sudokuKutu.put(
                                                                'seviye',
                                                                "Çok Zor");
                                                            _sudokuKutu.put(
                                                                'sudokuRows',
                                                                null);

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      const Sudoku()),
                                                            );
                                                          }
                                                        },
                                                        child: Center(
                                                          child: AspectRatio(
                                                            aspectRatio: 3,
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(4),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: themeBox.get(
                                                                            'tema') ==
                                                                        'dark'
                                                                    ? girisDarkButtonColor
                                                                    : girisLightButtonColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: Text(
                                                                "Çok Zor",
                                                                style:
                                                                    GoogleFonts
                                                                        .oswald(
                                                                  textStyle:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        18,
                                                                    color: themeBox.get('tema') ==
                                                                            'dark'
                                                                        ? girisDarkBaslikColor
                                                                        : girisLightBaslikColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (_sudokuKutu
                                                              .isOpen) {
                                                            _sudokuKutu.put(
                                                                'seviye',
                                                                "Çok Kolay");
                                                            _sudokuKutu.put(
                                                                'sudokuRows',
                                                                null);

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      const Sudoku()),
                                                            );
                                                          }
                                                        },
                                                        child: AspectRatio(
                                                          aspectRatio: 1,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: themeBox.get(
                                                                          'tema') ==
                                                                      'dark'
                                                                  ? girisDarkButtonColor
                                                                  : girisLightButtonColor,
                                                            ),
                                                            child: Text(
                                                              "Çok Kolay",
                                                              style: GoogleFonts
                                                                  .oswald(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 18,
                                                                  color: themeBox
                                                                              .get('tema') ==
                                                                          'dark'
                                                                      ? girisDarkBaslikColor
                                                                      : girisLightBaslikColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (_sudokuKutu
                                                              .isOpen) {
                                                            _sudokuKutu.put(
                                                                'seviye',
                                                                "Kolay");
                                                            _sudokuKutu.put(
                                                                'sudokuRows',
                                                                null);

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      const Sudoku()),
                                                            );
                                                          }
                                                        },
                                                        child: AspectRatio(
                                                          aspectRatio: 1,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: themeBox.get(
                                                                          'tema') ==
                                                                      'dark'
                                                                  ? girisDarkButtonColor
                                                                  : girisLightButtonColor,
                                                            ),
                                                            child: Text(
                                                              "Kolay",
                                                              style: GoogleFonts
                                                                  .oswald(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 18,
                                                                  color: themeBox
                                                                              .get('tema') ==
                                                                          'dark'
                                                                      ? girisDarkBaslikColor
                                                                      : girisLightBaslikColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (_sudokuKutu
                                                              .isOpen) {
                                                            _sudokuKutu.put(
                                                                'seviye',
                                                                "Orta");
                                                            _sudokuKutu.put(
                                                                'sudokuRows',
                                                                null);

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      const Sudoku()),
                                                            );
                                                          }
                                                        },
                                                        child: AspectRatio(
                                                          aspectRatio: 1,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: themeBox.get(
                                                                          'tema') ==
                                                                      'dark'
                                                                  ? girisDarkButtonColor
                                                                  : girisLightButtonColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Text(
                                                              "Orta",
                                                              style: GoogleFonts
                                                                  .oswald(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 18,
                                                                  color: themeBox
                                                                              .get('tema') ==
                                                                          'dark'
                                                                      ? girisDarkBaslikColor
                                                                      : girisLightBaslikColor,
                                                                ),
                                                              ),
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
                                      ),
                                      //Eski Oyun
                                      if (_sudokuKutu.get('sudokuRows') !=
                                              null &&
                                          widget.lose == false)
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const Sudoku()),
                                                );
                                              }
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: themeBox.get('tema') ==
                                                          'dark'
                                                      ? girisDarkButtonColor
                                                      : girisLightButtonColor,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Eski oyuna devam et",
                                                  style: GoogleFonts.oswald(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18,
                                                      color: themeBox.get(
                                                                  'tema') ==
                                                              'dark'
                                                          ? girisDarkBaslikColor
                                                          : girisLightBaslikColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(
              color: girisDarkButtonColor,
            ),
          );
        },
      ),
    );
  }
}
