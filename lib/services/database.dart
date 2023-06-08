import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Database {
  final String connectionString;
  late mongo.Db db;
  Database({
    this.connectionString = 'mongodb://localhost:27017',
  });

  init() async {
    if (connectionString.contains('mongodb+srv://')) {
      db = await mongo.Db.create(connectionString);
    } else {
      db = mongo.Db(connectionString);
    }
    await db.open();
    print('Connected to database');
  }

  mongo.DbCollection get posts => db.collection('posts');
  mongo.DbCollection get users => db.collection('users');
  mongo.DbCollection get cents => db.collection('cents');
}

Database get db {
  if (GetIt.instance.isRegistered<Database>() == false) {
    GetIt.instance.registerSingleton<Database>(Database());
  }
  return GetIt.instance.get<Database>();
}
