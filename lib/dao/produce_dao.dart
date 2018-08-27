import 'package:app/database/dao.dart';
import 'package:app/database/database.dart';
import 'package:app/models/produce.dart';
import 'package:app/tables/produce_table.dart';
import 'package:meta/meta.dart';

Map<String, dynamic> _mapify(Produce produce) => produce.toMap();

Produce _parse(Map<String, dynamic> map) => Produce.fromMap(map);

class ProduceDao extends Dao<Produce> {
  ProduceDao({
    @required Database database,
  })  : assert(database != null),
        super(ProduceTable.name, database, _parse, _mapify);
}
