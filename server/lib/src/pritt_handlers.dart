import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:pritt_server/gen/env.dart';
import 'package:pritt_server/src/utils/cors.dart';
import 'package:pritt_server/src/utils/log.dart';
import 'package:shelf/shelf.dart';
import 'package:path/path.dart' as p;

Handler getReposHandler(int port, [bool preprod = false]) {
  // Path of data relative to 'server'
  String pathToList = dataPath;
  try {
  String data = File(pathToList).readAsStringSync();
  
  return (Request req) {
    Map<String, Object> headers = {'Content-Type': 'application/json'};
    headers.addAll(corsHeaders(preprod ? null : port));
    return Response.ok(data, headers: headers);
  };

  } on FileSystemException catch (e) {
    prittLog("Error retrieving data: ${e.message}", true);
    log("Path: ${e.path}");

    return (Request req) => Response.internalServerError(body: "Data not found");
  } catch (e) {
    prittLog("Unknown error occured", true);
    log("Error object: $e");

    return (Request req) => Response(808, body: "Unknown Error");
  }
}
Handler addRepoHandler(String name, int port, [bool preprod = false]) {
  String pathToList = dataPath;
  List data = [];

  Map<String, Object> headers = corsHeaders(preprod ? null : port);

  try {
    data = json.decode(File(pathToList).readAsStringSync());
  } on FileSystemException catch (e) {
    prittLog("Error retrieving data: ${e.message}", true);
    return (Request req) => Response.internalServerError(body: "Data not found");
  } on TypeError catch (e) {
    prittLog("The JSON isn't valid: ${e.stackTrace}", true);
    return (Request req) => Response.badRequest(body: "Invalid JSON");
  } catch (e) {
    prittLog("Unknown error occured", true);
    return (Request req) => Response(808, body: "Unknown Error");
  }

  return (Request req) async {
    final jsonData = json.decode(await req.readAsString());
    final path = p.join(jsonData['base'] ?? '', jsonData['path'] ?? '');

    prittLog("${jsonData} produces ${path} that is added to ${data}", false);
    
    return Response.ok("", headers: headers);
  };
}
