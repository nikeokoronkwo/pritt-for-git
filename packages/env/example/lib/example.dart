import 'package:env/env.dart';

part 'example.g.dart';

@env("MY_SECRET")
final secret = MY_SECRET;

@env("OUR_SECRET")
final shared = OUR_SECRET;