import 'package:flutter/cupertino.dart';

class CoinProvider with ChangeNotifier {
  final int initialCoins;
  CoinProvider({this.initialCoins = 0});

  int _coinAmount = 0;

  void setInitCoins() {
    _coinAmount = initialCoins;
    notifyListeners();
  }

  int get coins {
    return _coinAmount;
  }

  void increaseAmount(int amount) {
    _coinAmount = _coinAmount + amount;
    notifyListeners();
  }
}
