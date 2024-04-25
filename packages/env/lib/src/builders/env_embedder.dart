import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../env_base.dart';

class EnvEmbedder extends GeneratorForAnnotation<env> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final envValue = annotation.read('name').literalValue as String;

    String value = "";

    try {
      final dotEnvFile = File(".env").readAsLinesSync();
      value = dotEnvFile.lastWhere((element) => element.split("=").first == envValue, orElse: () => "").split("=").last;
    } on FileSystemException catch (e) {
      print("Error reading .env file: ${e.message}");
    } catch (e) {
      print("Unknown error occured");
    }

    return "String $envValue = ${value == "" ? "''" : value};";
  }

}