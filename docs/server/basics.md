# The Server

## Why Dart?
Golang would have been one of the best choices to use for the server of this project, but Dart was eventually preferred over Golang for the following reasons:
- Golang was good as a basic api for the project, but Dart was optimum for being able to serve the production files (which are necessary during production). Dart's [`Cascade`](https://pub.dev/documentation/shelf/latest/shelf/Cascade-class.html) was the major lead for this.