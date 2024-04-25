import 'dart:developer';
import 'dart:io';

import 'package:pritt_server/gen/env.dart';
import 'package:shelf/shelf.dart';

Handler getReposHandler() {
  // Path of data relative to 'server'
  String pathToList = dataPath;
  try {
  String data = File(pathToList).readAsStringSync();
  
  return (Request req) => Response.ok(data);
  } on FileSystemException catch (e) {
    print("Error retrieving data: ${e.message}");
    log("Path: ${e.path}");

    return (Request req) => Response.internalServerError(body: "Data not found");
  } catch (e) {
    print("Unknown error occured");
    log("Error object: $e");

    return (Request req) => Response.internalServerError(body: "Unknown Error");
  }
}