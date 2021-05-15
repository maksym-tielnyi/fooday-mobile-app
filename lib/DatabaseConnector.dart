import 'package:mysql1/mysql1.dart';

class DatabaseConnector {
  static Future<MySqlConnection> createConnectionAsync() async {
    var settings = new ConnectionSettings(
        host: 'sql11.freesqldatabase.com',
        port: 3306,
        user: 'sql11412037',
        password: '9YXDiKr1az',
        db: 'sql11412037');
    MySqlConnection connection;
    try {
      connection = await MySqlConnection.connect(settings);
    } catch (e) {
      return null;
    }
    return connection;
  }

  static Future<Results> getQueryResultsAsync(
      String query, List<dynamic> params,
      {MySqlConnection connection}) async {
    bool tempConnection = connection == null;
    if (tempConnection) {
      connection = await createConnectionAsync();
      if (connection == null) {
        return null;
      }
    }

    Results results;
    try {
      results = await connection.query(query, params);
    } finally {
      if (tempConnection) {
        connection.close();
      }
    }
    return results;
  }
}
