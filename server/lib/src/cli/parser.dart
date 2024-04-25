import 'package:args/args.dart';

ArgParser parser = ArgParser()
..addFlag('dev', abbr: 'd', hide: true, help: 'Whether this is the dev server or production server', defaultsTo: false)
..addOption('port', abbr: 'p', help: "The port to serve the application from");

ArgResults parse(List<String> args) => parser.parse(args);