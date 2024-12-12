import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/roro/damage_report/damage_report_list_sql_lite.dart';
import '../damage_report_models.dart';

class DBdamageReport {
  static Future<Database> openDBdamageReport() async {
    return openDatabase(join(await getDatabasesPath(), 'damageReport.db'),
        onCreate: (db, version) {
      db.execute("DROP TABLE IF EXISTS damageReport");
      return db.execute(
          "CREATE TABLE damageReport (idDamageReport INTEGER PRIMARY KEY, jornada INTEGER, fecha DATETIME, codDr TEXT, tipoOperacion TEXT null, chasis TEXT, marca TEXT, numeroTrabajador INTEGER, chassisFoto TEXT, stowagePosition TEXT, damageInformation TEXT null, tercerosOperacion TEXT null, companyName TEXT null, damageFound TEXT, damageOcurred TEXT, operation TEXT, cantidadDanos INTEGER, fotoVerificacion TEXT null, lugarAccidente TEXT, fechaAccidente DATETIME, comentarios TEXT, codQr TEXT, idServiceOrder INTEGER, idUsuarios INTEGER, idApmtc INTEGER null, idConductor INTEGER null, idVehicle INTEGER)");
    }, version: 1);
  }

  Future<Database> openDbDamageType() async {
    return openDatabase(join(await getDatabasesPath(), 'damageItem.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE damageItem (idDamageTypeRegister INTEGER PRIMARY KEY, codigoDao TEXT, daoRegistrado TEXT, cantidadDsMissing INTEGER ,descripcionFaltantes TEXT, parteVehiculo TEXT, zonaVehiculo TEXT, fotoDao TEXT, idDamageReport INTEGER)");
    }, version: 1);
  }

  Future<int> insertDamageReport(
      DamageReportListSqlLite damageReport, List<DamageItem> damageItem) async {
    Database dbDBdamageReport = await openDBdamageReport();
    Database dbDbDamageType = await openDbDamageType();
    Batch batch = dbDbDamageType.batch();
    final result = await dbDBdamageReport.insert(
        "damageReport", damageReport.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    for (int count = 0; count < damageItem.length; count++) {
      batch.insert("damageItem", {
        "codigoDao": damageItem[count].codigoDao,
        "daoRegistrado": damageItem[count].daoRegistrado,
        "cantidadDsMissing": damageItem[count].cantidadDsMissing,
        "descripcionFaltantes": damageItem[count].descripcionFaltantes,
        "parteVehiculo": damageItem[count].parteVehiculo,
        "zonaVehiculo": damageItem[count].zonaVehiculo,
        "fotoDao": damageItem[count].fotoDao,
        "idDamageReport": result,
      });
    }
    await batch.commit();
    return result;
  }

  Future<int> clearTableDamageReport() async {
    Database database = await openDBdamageReport();
    Database dbDbDamageType = await openDbDamageType();
    await dbDbDamageType.delete("damageItem");
    return database.delete("damageReport");
  }

  static Future<Future<int>> deleteDamageR(
      DamageReportListSqlLite damageReport) async {
    Database database = await openDBdamageReport();
    return database.delete("damageReport",
        where: "id = ?", whereArgs: [damageReport.idDamageReport]);
  }

  Future<DamageReportListSqlLite> getDamageReportSQLiteById(
      int idDamageReport) async {
    Database database = await openDBdamageReport();
    final maps = await database.query("damageReport",
        columns: [
          "idDamageReport",
          "jornada",
          "fecha",
          "codDr",
          "numeroTrabajador",
          "chassisFoto",
          "stowagePosition",
          "damageFound",
          "damageOcurred",
          "operation",
          "cantidadDanos",
          "fotoVerificacion",
          "lugarAccidente",
          "fechaAccidente",
          "comentarios",
          "codQr",
          "idServiceOrder",
          "idUsuarios",
          "idApmtc",
          "idConductor",
          "idVehicle",
        ],
        where: '"idDamageReport"=?',
        whereArgs: [idDamageReport]);
    if (maps.isNotEmpty) {
      return DamageReportListSqlLite.fromJson(maps.first);
    } else {
      throw Exception("no se pudo obtener registros");
    }
  }

  Future<List<DamageReportListSqlLite>> getDamageReportList() async {
    Database database = await openDBdamageReport();
    List<Map> maps = await database.query(
      "damageReport",
      columns: [
        "idDamageReport",
        "jornada",
        "fecha",
        "codDr",
        "tipoOperacion",
        "numeroTrabajador",
        "chassisFoto",
        "stowagePosition",
        "damageInformation",
        "tercerosOperacion ",
        "companyName",
        "damageFound",
        "damageOcurred",
        "operation",
        "cantidadDanos",
        "fotoVerificacion",
        "lugarAccidente",
        "fechaAccidente",
        "comentarios",
        "codQr",
        "idServiceOrder",
        "idUsuarios",
        "idApmtc",
        "idConductor",
        "idVehicle",
      ],
    );
    return List.generate(
        maps.length,
        (i) => DamageReportListSqlLite(
              idDamageReport: maps[i]['idDamageReport'],
              jornada: maps[i]['jornada'],
              fecha: DateTime.tryParse(maps[i]['fecha']),
              codDr: maps[i]['codDr'],
              tipoOperacion: maps[i]['tipoOperacion'],
              numeroTrabajador: maps[i]['numeroTrabajador'],
              chassisFoto: maps[i]['chassisFoto'],
              stowagePosition: maps[i]['stowagePosition'],
              damageInformation: maps[i]['damageInformation'],
              tercerosOperacion: maps[i]['tercerosOperacion'],
              companyName: maps[i]['companyName'],
              damageFound: maps[i]['damageFound'],
              damageOcurred: maps[i]['damageOcurred'],
              operation: maps[i]['operation'],
              cantidadDanos: maps[i]['cantidadDanos'],
              fotoVerificacion: maps[i]['fotoVerificacion'],
              lugarAccidente: maps[i]['lugarAccidente'],
              fechaAccidente: DateTime.tryParse(maps[i]['fechaAccidente']),
              comentarios: maps[i]['comentarios'],
              codQr: maps[i]['codQr'],
              idServiceOrder: maps[i]['idServiceOrder'],
              idUsuarios: maps[i]['idUsuarios'],
              idApmtc: maps[i]['idApmtc'],
              idConductor: maps[i]['idConductor'],
              idVehicle: maps[i]['idVehicle'],
            ));
  }

  Future<List<DamageItem>> getDamageItemList() async {
    Database database = await openDbDamageType();
    List<Map> maps = await database.query("damageItem", columns: [
      "codigoDao",
      "daoRegistrado",
      "cantidadDsMissing",
      "descripcionFaltantes",
      "parteVehiculo",
      "zonaVehiculo",
      "fotoDao",
      "idDamageReport"
    ]);
    return List.generate(
        maps.length,
        (i) => DamageItem(
              codigoDao: maps[i]['codigoDao'],
              daoRegistrado: maps[i]['daoRegistrado'],
              cantidadDsMissing: maps[i]['cantidadDsMissing'],
              descripcionFaltantes: maps[i]['descripcionFaltantes'],
              parteVehiculo: maps[i]['parteVehiculo'],
              zonaVehiculo: maps[i]['zonaVehiculo'],
              fotoDao: maps[i]['fotoDao'],
              idDamageReport: maps[i]['idDamageReport'],
            ));
  }

  Future<List<DamageItem>> getDamageItemSQLiteByIdDamageReport(
      int idDamageReport) async {
    Database database = await openDbDamageType();
    List<Map> maps = await database.query("damageItem",
        columns: [
          "codigoDao",
          "daoRegistrado",
          "cantidadDsMissing",
          "descripcionFaltantes",
          "parteVehiculo",
          "zonaVehiculo",
          "fotoDao",
          "idDamageReport"
        ],
        where: '"idDamageReport"=?',
        whereArgs: [idDamageReport]);
    return List.generate(
        maps.length,
        (i) => DamageItem(
              codigoDao: maps[i]['codigoDao'],
              daoRegistrado: maps[i]['daoRegistrado'],
              cantidadDsMissing: maps[i]['cantidadDsMissing'],
              descripcionFaltantes: maps[i]['descripcionFaltantes'],
              parteVehiculo: maps[i]['parteVehiculo'],
              zonaVehiculo: maps[i]['zonaVehiculo'],
              fotoDao: maps[i]['fotoDao'],
              idDamageReport: maps[i]['idDamageReport'],
            ));
  }

  Future<List<DamageReportListSqlLite>> listDamageReportsSQlLite() async {
    Database database = await openDBdamageReport();
    List<Map> maps = await database.query(
      "damageReport",
      columns: [
        "idDamageReport",
        "codDr",
        "chasis",
        "marca",
        "cantidadDanos",
      ],
    );
    return List.generate(
        maps.length,
        (i) => DamageReportListSqlLite(
              idDamageReport: maps[i]['idDamageReport'],
              codDr: maps[i]['codDr'],
              chasis: maps[i]['chasis'],
              marca: maps[i]['marca'],
              cantidadDanos: maps[i]['cantidadDanos'],
            ));
  }

  Future<int> deleteDataDamageReporItemtByID(int idDamageReport) async {
    Database database = await openDBdamageReport();

    return database.delete("damageReport",
        where: '"idDamageReport"=?', whereArgs: [idDamageReport]);
  }

  Future<int> deleteDataDamageReportByID(int idDamageReport) async {
    Database database = await openDbDamageType();

    return database.delete("damageItem",
        where: '"idDamageReport"=?', whereArgs: [idDamageReport]);
  }

  Future<List<Map<String, Object?>>> listdamageitemSql() async {
    Database database = await openDbDamageType();
    final damageReportConsultaMap = await database.query(
      "damageItem",
    );

    return damageReportConsultaMap;
  }

  Future<List<Map<String, Object?>>> listDamageReportSql() async {
    Database database = await openDBdamageReport();
    final damageReportConsultaMap = await database.query(
      "damageReport",
    );

    return damageReportConsultaMap;
  }
}

class DbDamageReportSqlLite {
  Future<Database> openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'damageConsulta.db'),
        onCreate: (db, version) {
      db.execute("DROP TABLE IF EXISTS damageConsulta");
      return db.execute(
          "CREATE TABLE damageConsulta (idOrdenServicio INTEGER,idVehicle INTEGER, chasis TEXT, marca TEXT,modelo TEXT,agenciaMaritima TEXT, consignatario TEXT, bl TEXT)");
    }, version: 1);
  }

  Future<List> insertDamageReportData(
      List<DamageReportInsertSqlLite> damageConsulta) async {
    Database database = await openDB();
    database.delete("damageConsulta");
    Batch batch = database.batch();
    for (int count = 0; count < damageConsulta.length; count++) {
      batch.insert("damageConsulta", {
        "idOrdenServicio": damageConsulta[count].idServiceOrder,
        "idVehicle": damageConsulta[count].idVehiculo,
        "chasis": damageConsulta[count].chasis,
        "agenciaMaritima": damageConsulta[count].agenciaMaritima,
        "marca": damageConsulta[count].marca,
        "modelo": damageConsulta[count].modelo,
        "consignatario": damageConsulta[count].consigntario,
        "bl": damageConsulta[count].billOfLeading,
      });
    }
    final results = await batch.commit();
    return results;
  }

  Future<List<DamageReportInsertSqlLite>> listdamageReportConsultas() async {
    Database database = await openDB();
    final List<Map<String, dynamic>> damageReportConsultaMap =
        await database.query(
      "damageConsulta",
    );
    return List.generate(
        damageReportConsultaMap.length,
        (i) => DamageReportInsertSqlLite(
              chasis: damageReportConsultaMap[i]['chasis'],
              marca: damageReportConsultaMap[i]['marca'],
              modelo: damageReportConsultaMap[i]['modelo'],
              agenciaMaritima: damageReportConsultaMap[i]['agenciaMaritima'],
              consigntario: damageReportConsultaMap[i]['consignatario'],
              billOfLeading: damageReportConsultaMap[i]['bl'],
            ));
  }

  Future<List<DamageReportInsertSqlLite>> getVehicleByIdAndIdServiceOrder(
      int idServiceOrder, int idVehicle) async {
    Database database = await openDB();
    List<Map> result = await database.rawQuery(
      "select * from damageConsulta where idOrdenServicio=$idServiceOrder and idVehicle=$idVehicle", /*[idServiceOrder, idVehicle]*/
    );
    return List.generate(
        result.length,
        (i) => DamageReportInsertSqlLite(
              chasis: result[i]['chasis'],
              marca: result[i]['marca'],
              modelo: result[i]['modelo'],
              agenciaMaritima: result[i]['agenciaMaritima'],
              consigntario: result[i]['consignatario'],
              billOfLeading: result[i]['bl'],
            ));
  }

  Future<List<DamageReportInsertSqlLite>> getVehicleByChasisAndIdServiceOrder(
      int idServiceOrder, String chasis) async {
    Database database = await openDB();
    List<Map> result = await database.rawQuery(
      "select * from damageConsulta where idOrdenServicio=$idServiceOrder and chasis='$chasis'", /*[idServiceOrder, idVehicle]*/
    );
    return List.generate(
        result.length,
        (i) => DamageReportInsertSqlLite(
              chasis: result[i]['chasis'],
              marca: result[i]['marca'],
              modelo: result[i]['modelo'],
              agenciaMaritima: result[i]['agenciaMaritima'],
              consigntario: result[i]['consignatario'],
              idVehiculo: result[i]['idVehicle'],
              billOfLeading: result[i]['bl'],
            ));
  }
}
