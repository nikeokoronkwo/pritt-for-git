import 'package:env/env.dart';

part 'env.g.dart';

@env('DATA_JSON')
String dataPath = DATA_JSON;

@env('CLIENT_DIR')
String client = CLIENT_DIR;

@env('SERVICES_DIR')
String services = SERVICES_DIR;

@env('DEV')
bool isDev = bool.parse(DEV);
