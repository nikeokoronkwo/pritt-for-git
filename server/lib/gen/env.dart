import 'package:env/env.dart';

part 'env.g.dart';

@env('DATA_ENTRY')
String dataPath = DATA_ENTRY;

@env('CLIENT_DIR')
String client = CLIENT_DIR;