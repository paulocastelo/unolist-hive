import 'package:hive/hive.dart';

/// \uD83C\uDFC6 Servi\u00e7o respons\u00e1vel por controlar a pontua\u00e7\u00e3o do usu\u00e1rio.
class ScoreService {
  final Box<int> _box;

  ScoreService(this._box);

  /// Retorna a pontua\u00e7\u00e3o atual.
  Future<int> getScore() async {
    return _box.get('score', defaultValue: 0) ?? 0;
  }

  /// Incrementa a pontua\u00e7\u00e3o.
  Future<void> incrementScore([int value = 1]) async {
    final current = await getScore();
    await _box.put('score', current + value);
  }
}
