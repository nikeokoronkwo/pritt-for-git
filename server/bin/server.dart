import 'package:pritt_server/pritt_server.dart';

void main(List<String> args) async {
  final results = parse(args);

  final server = PrittServer().client(results.rest.isNotEmpty ? results.rest[0] : '../../client/dist');
  server.router..get('/repos', getReposHandler());
  server.run();
}
