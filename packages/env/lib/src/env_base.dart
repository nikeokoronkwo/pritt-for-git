
/// The `env` annotation, used to bind an enviroment variable value at the root of a project to a value in the dart application.
/// Whenever the annotation is initialised, the name of the environment variable, [name], is passed.
/// 
/// ```dart
/// @env("MY_ENV_VARIABLE")
/// String myVar = MY_ENV_VARIABLE;
/// ```
/// 
/// The generated code for the variable `MY_ENV_VARIABLE` will be built as a part builder to the file containing the `@env` annotation
// ignore: camel_case_types
class env {
  final String name;
  const env(this.name);
}