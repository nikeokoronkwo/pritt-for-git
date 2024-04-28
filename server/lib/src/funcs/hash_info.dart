import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

String hashInfo(String name, String path) {
  var nameChunk = utf8.encode(name);
  var pathChunk = utf8.encode(path);

  var output = AccumulatorSink<Digest>();
  var input = sha256.startChunkedConversion(output);
  input.add(nameChunk);
  input.add(pathChunk);
  input.close();

  var digest = output.events.single;

  return digest.toString();
}
