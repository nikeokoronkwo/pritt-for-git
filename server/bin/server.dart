import 'package:pritt_server/pritt_server.dart';

void main(List<String> args) async {
  final results = parse(args);
  // Use any available host or container IP (usually `0.0.0.0`).
  PrittServer().client(results.rest.isNotEmpty ? results.rest[0] : '../../client/dist')
  // .router..get('/repos', )
  .run()
  ;
}
