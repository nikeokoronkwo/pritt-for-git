import 'package:env/env.dart';

part 'env.g.dart';

@env('DATA_JSON')
String dataPath = DATA_ENTRY;

@env('CLIENT_DIR')
String client = CLIENT_DIR;

@env('SERVICES_DIR')
String services = SERVICES_DIR;