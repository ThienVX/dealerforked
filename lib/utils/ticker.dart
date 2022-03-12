abstract class ITicker {
  Stream<int> tick({required int ticks});
}

class Ticker implements ITicker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}
