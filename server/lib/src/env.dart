import 'package:env/env.dart';

@env('DATA_JSON')
String dataPath = "../data/repos.json";

@env('CLIENT_DIR')
String client = "../client/dist";

@env('SERVICES_DIR')
String services = "../services";