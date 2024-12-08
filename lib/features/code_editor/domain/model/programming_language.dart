import 'package:highlight/highlight.dart';
import 'package:highlight/languages/cpp.dart';

enum ProgrammingLanguage { cpp, java, python }

extension ProgrammingLanguageExt on ProgrammingLanguage {
  Mode get mode {
    return switch (this) {
      ProgrammingLanguage.cpp => cpp,
      ProgrammingLanguage.java => cpp,
      ProgrammingLanguage.python => cpp,
    };
  }

  String get displayText {
    switch (this) {
      case ProgrammingLanguage.cpp:
        return 'C++';
      case ProgrammingLanguage.java:
        return 'Java';
      case ProgrammingLanguage.python:
        return 'Python';
    }
  }
}
