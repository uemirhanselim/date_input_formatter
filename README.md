<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
# DateInputFormatter

A Dart package that provides a custom `TextInputFormatter` for formatting and validating date input in Flutter.

Note: This package is the improved version of `pattern_formatter` package by adding validations to `DateInputFormatter`.

## Installation

Add `dateinputformatter` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  dateinputformatter: ^1.0.0
```

## How to use

```dart
import 'package:date_input_formatter/date_input_formatter.dart';
```

## Usage

I strongly suggest these below parts while using this package to prevent undesired problems:    
    -  set `enableInteractiveSelection` to `false`
    -  also use `FilteringTextInputFormatter.allow(RegExp(r'[0-9/-]'))` 

```dart
    TextField(
        enableInteractiveSelection: false,
        inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9/-]')),
            DateInputFormatter(),
        ],
        decoration: const InputDecoration(border: OutlineInputBorder()),
    ),
```