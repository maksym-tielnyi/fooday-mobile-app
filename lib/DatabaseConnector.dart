import 'package:mysql1/mysql1.dart';

class DatabaseConnector {
  static Future<MySqlConnection> createConnectionAsync() async {
    var settings = new ConnectionSettings(
        host: '10.0.2.2',
        port: 3306,
        user: 'root',
        password: 'YflOe234fOEM',
        db: 'fooday');
    MySqlConnection connection;
    try {
      connection = await MySqlConnection.connect(settings);
    } catch (e) {
      return null;
    }
    return connection;
  }

  static Future<Results> getQueryResultsAsync(
      String query, List<dynamic> params) async {
    MySqlConnection connection = await createConnectionAsync();
    if (connection == null) {
      return null;
    }

    Results results;
    try {
      results = await connection.query(query, params);
    } catch (e) {
      print("Exception: ${e}");
      rethrow;
    } finally {
      connection.close();
    }
    return results;
  }
}
