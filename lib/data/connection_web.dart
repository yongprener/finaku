import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Koneksi SQLite untuk web, memakai berkas sqlite3.wasm dan
/// drift_worker.js di folder web. Data tersimpan di IndexedDB
/// peramban pada perangkat pengguna sendiri.
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'finaku',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}
