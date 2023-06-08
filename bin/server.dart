import 'dart:io';

import 'package:dollarydoo/server.dart';
import 'package:dollarydoo/services/database.dart';
import 'package:get_it/get_it.dart';

main() async {
  print('Starting server');
  print('Connecting to database');
  final database = Database(
      connectionString:
          Platform.environment['DB_URI'] ?? 'mongodb://localhost:27017');
  await database.init();
  GetIt.instance.registerSingleton(database);
  print('Database connected');
  print('Setting up routes');
  final server = Server();
  await server.init();
  print('Server running');
}
