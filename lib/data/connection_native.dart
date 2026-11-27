import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Koneksi SQLite berkas untuk Android dan platform natif lain.
/// Berkas finaku.sqlite tersimpan di folder dokumen aplikasi, jadi
/// data bertahan antar sesi dan sepenuhnya luring.
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'finaku.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
