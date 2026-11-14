import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:recetas_app/models/resena.dart';

class ResenasDb {
  ResenasDb._();
  static final ResenasDb instancia = ResenasDb._();

  static const _nombreArchivo = 'recetas.db';
  static const _tabla = 'resenas';
  Database? _db;

  Future<Database> get _database async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), _nombreArchivo);
    return openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tabla (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            receta_id INTEGER NOT NULL,
            calificacion INTEGER NOT NULL CHECK (calificacion BETWEEN 1 AND 5),
            comentario TEXT NOT NULL,
            fecha TEXT NOT NULL
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_resenas_receta ON $_tabla (receta_id)',
        );
      },
    );
  }

  Future<int> insertar(Resena resena) async {
    final db = await _database;
    return db.insert(_tabla, resena.toMap());
  }

  Future<List<Resena>> obtenerPorReceta(int recetaId) async {
    final db = await _database;
    final filas = await db.query(
      _tabla,
      where: 'receta_id = ?',
      whereArgs: [recetaId],
      orderBy: 'id DESC',
    );
    return filas.map(Resena.fromMap).toList();
  }
  Future<({double promedio, int total})> obtenerResumen(int recetaId) async {
    final db = await _database;
    final filas = await db.rawQuery(
      'SELECT AVG(calificacion) AS promedio, COUNT(*) AS total '
      'FROM $_tabla WHERE receta_id = ?',
      [recetaId],
    );
    final promedio = (filas.first['promedio'] as num?)?.toDouble() ?? 0.0;
    final total = (filas.first['total'] as int?) ?? 0;
    return (promedio: promedio, total: total);
  }
}
