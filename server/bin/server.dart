import 'package:pritt_server/pritt_server.dart';
// import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  final results = parse(args);

  var server = PrittServer();
  if (!results.wasParsed('dev')) {
    server = server.client(results.rest.isNotEmpty ? results.rest[0] : '../client/dist');
  }
  server.router..get('/api/repos', getReposHandler());
  server.run(port: int.parse(results['port'] ?? '8080'));
}
