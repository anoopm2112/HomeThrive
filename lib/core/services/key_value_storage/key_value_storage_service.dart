import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/child_log_note/child_log_note.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class KeyValueStorageService {
  Box _hiveBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ChildAdapter());
    Hive.registerAdapter(ChildBehaviorAdapter());
    Hive.registerAdapter(ChildLogAdapter());
    Hive.registerAdapter(ChildLogNoteAdapter());
    Hive.registerAdapter(MoodRatingAdapter());
    _hiveBox = await Hive.openBox("fosterShare");
  }

  Future<void> save({
    dynamic key,
    dynamic value,
  }) async {
    _hiveBox.put(key, value);
  }

  T get<T>(dynamic key) {
    return _hiveBox.get(key) as T;
  }

  Future<void> delete(dynamic key) async {
    _hiveBox.delete(key);
  }

  bool containsKey(dynamic key) {
    return _hiveBox.containsKey(key);
  }
}
