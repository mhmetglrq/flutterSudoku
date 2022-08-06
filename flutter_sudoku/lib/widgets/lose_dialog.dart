import 'package:flutter/material.dart';
import 'package:flutter_sudoku/screens/color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../screens/giris_screen.dart';
import '../screens/sudoku_screen.dart';

class LoseDialog extends StatefulWidget {
  RewardedAd? rewardedAd;
  bool isLoaded;
  LoseDialog({Key? key, required this.isLoaded, required this.rewardedAd})
      : super(key: key);

  @override
  State<LoseDialog> createState() => _LoseDialogState();
}

class _LoseDialogState extends State<LoseDialog> {
  final Box _sudokuKutu = Hive.box('sudoku');
  Future<Box> _temaKutuAc() async {
    await Hive.openBox('sudoku');
    return await Hive.openBox('ayarlar');
  }

  _clearBox() {
    _sudokuKutu.put('sudokuRows', null);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                                  'Oyun Bitti!',
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
                                  '3 Hatayı aştığınız için oyunu kaybettiniz.',
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
                            InkWell(
                              onTap: () {
                                if (widget.isLoaded) {
                                  widget.rewardedAd!.show(onUserEarnedReward:
                                      (AdWithoutView ad, RewardItem reward) {
                                    _sudokuKutu.put('_hata', 1);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const Sudoku()),
                                    );
                                    print("${reward.amount} ${reward.type}");
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Daha reklam yüklenmedi. Lütfen biraz bekleyiniz.');
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: themeBox.get('tema') == 'dark'
                                      ? dialogDarkTryAgainOrNextButtonColor
                                      : dialogLightTryAgainOrNextButtonColor,
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'İkinci Şans',
                                        style: TextStyle(
                                          color: themeBox.get('tema') == 'dark'
                                              ? dialogDarkIconandTextColor
                                              : dialogLightIconandTextColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Icon(
                                        Icons.smart_display_outlined,
                                        color: themeBox.get('tema') == 'dark'
                                            ? dialogDarkIconandTextColor
                                            : dialogLightIconandTextColor,
                                      ),
                                    ],
                                  ),
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
                                      splashColor: Colors.transparent,
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (builder) => const Giris(
                                                lose: true,
                                              ),
                                            ),
                                            (route) => false);
                                        Future.delayed(
                                          const Duration(milliseconds: 100),
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
                                        borderRadius: BorderRadius.circular(8),
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
                                      splashColor: Colors.transparent,
                                      onPressed: () {
                                        _clearBox();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const Sudoku(),
                                          ),
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
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
        },
      ),
    );
  }
}
