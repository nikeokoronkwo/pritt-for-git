import 'package:pritt_server/gen/env.dart';
import 'package:pritt_server/pritt_server.dart';
import 'package:pritt_server/src/pritt_handlers.dart';
import 'package:shelf/shelf.dart';
// import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  final results = parse(args);

  bool dev = results.wasParsed('dev');
  int port = int.parse(results['port'] ?? '8080');

  var server = PrittServer();
  if (!dev) {
    server = server.client(results.rest.isNotEmpty ? results.rest[0] : client);
  }
  server.router
    ..get('/api/repos', getReposHandler(port, dev))
    ..post('/api/new/<name>',
        (Request req, String name) => addRepoHandler(name, port, dev)(req))
    ..get('/api/repo/<name>', (Request req, String name) => getRepoInfo(name, port, dev)(req))
    ;
  server.run(port: port);
}
