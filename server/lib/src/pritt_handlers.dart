import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:pritt_server/gen/env.dart';
import 'package:pritt_server/src/funcs/hash_info.dart';
import 'package:pritt_server/src/utils/cors.dart';
import 'package:pritt_server/src/utils/log.dart';
import 'package:shelf/shelf.dart';
import 'package:path/path.dart' as p;

Handler getReposHandler(int port, [bool preprod = false]) {
  try {
    String data = File(dataPath).readAsStringSync();

    return (Request req) {
      Map<String, Object> headers = {'Content-Type': 'application/json'};
      headers.addAll(corsHeaders(preprod ? null : port));
      return Response.ok(data, headers: headers);
    };
  } on FileSystemException catch (e) {
    prittLog("Error retrieving data: ${e.message}", true);
    log("Path: ${e.path}");

    return (Request req) =>
        Response.internalServerError(body: "Data not found");
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
    return (Request req) =>
        Response.internalServerError(body: "Data not found");
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

    final hash = hashInfo(name, path);

    data.add({'name': name, 'path': path, 'hash': hash});

    try {
      File(pathToList).writeAsString(json.encode(data));
    } on FileSystemException catch (e) {
      prittLog("Error retrieving data: ${e.message}", true);
      return Response.internalServerError(body: "Data couldn't be added");
    } on TypeError catch (e) {
      prittLog("The JSON isn't valid: ${e.stackTrace}", true);
      return Response.badRequest(body: "Data couldn't be marshalled");
    } catch (e) {
      prittLog("Unknown error occured", true);
      return Response(808, body: "Unknown Error adding data");
    }

    return Response.ok("", headers: headers);
  };
}


Handler getRepoInfo(String name, int port, bool dev) {
  List jsonData = [];
  try {
    jsonData = json.decode(File(dataPath).readAsStringSync());
  } on FileSystemException catch (_) { 
    return (Request req) => Response.internalServerError(body: "Couldn't get data");
  } catch (e) {
    return (Request req) => Response(808, body: "Unknown Error");
  }

  String itemPath = jsonData.firstWhere((element) => element['name'] == name)['path'];

  return (Request req) async {
    if (dev) {
      String pathToGoGit = p.join(services, "git");
      final gitResult = await Process.run("go", ["run", ".", itemPath, "--json"], workingDirectory: pathToGoGit, stdoutEncoding: utf8, stderrEncoding: utf8);
      if (gitResult.exitCode != 0) {
        return Response.badRequest(body: "A git repository could not be found");
      } else {
        final jsonResult = gitResult.stdout as String;
        return Response.ok(jsonResult);
      }
    } else {
      String pathToGit = p.join(services, "git", "pritt-git");
      final gitResult = await Process.run(pathToGit, [itemPath, "--json"]);
      if (gitResult.exitCode != 0) {
        return Response.badRequest(body: "A git repository could not be found");
      } else {
        final jsonResult = gitResult.stdout as String;
        return Response.ok(jsonResult);
      }
    }
  };
  
}
