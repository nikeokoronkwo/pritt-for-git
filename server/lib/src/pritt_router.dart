import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

class PrittServer {
  Cascade _cascade;
  final Router _router;

  Router get router => _router;

  PrittServer(): _cascade = Cascade(), _router = Router() {}

  PrittServer client(String path) {
    _cascade = _cascade.add(createStaticHandler(path, serveFilesOutsidePath: true, defaultDocument: 'index.html'));
    return this;
  }

  void run({String? ip, int? port}) async {
    _cascade.add(_router.call);
    final serverIp = ip ?? InternetAddress.anyIPv4;
    final handler = Pipeline().addMiddleware(logRequests()).addHandler(_cascade.handler);
    final serverPort = port ?? int.parse(Platform.environment['PORT'] ?? '8080');
    final server = await serve(handler, serverIp, serverPort);
    print('Server listening on port ${server.port}');
  }
}