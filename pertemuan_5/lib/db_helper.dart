import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart' show Catatan;

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  static const _key = 'catatan_list';

  Future<void> initDatabaseFactory() async {}

  Future<List<Catatan>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final list = raw
        .map((s) => Catatan.fromMap(jsonDecode(s) as Map<String, Object?>))
        .toList();
    list.sort((a, b) => b.dibuatPada.compareTo(a.dibuatPada));
    return list;
  }

  Future<void> _saveAll(List<Catatan> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      list.map((c) => jsonEncode(c.toMap())).toList(),
    );
  }

  Future<int> insert(Catatan c) async {
    final list = await getAll();
    final newId = DateTime.now().millisecondsSinceEpoch;
    final newCatatan = Catatan(
      id: newId,
      judul: c.judul,
      isi: c.isi,
      kategori: c.kategori,
      email: c.email,
      dibuatPada: c.dibuatPada,
    );
    list.add(newCatatan);
    await _saveAll(list);
    return newId;
  }

  Future<int> update(Catatan c) async {
    final list = await getAll();
    final idx = list.indexWhere((x) => x.id == c.id);
    if (idx != -1) list[idx] = c;
    await _saveAll(list);
    return 1;
  }

  Future<int> delete(int id) async {
    final list = await getAll();
    list.removeWhere((x) => x.id == id);
    await _saveAll(list);
    return 1;
  }
}
