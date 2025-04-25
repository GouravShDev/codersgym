import 'package:highlight/highlight.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cs.dart';
import 'package:highlight/languages/kotlin.dart';
import 'package:highlight/languages/javascript.dart';

enum ProgrammingLanguage {
  c,
  cpp,
  java,
  python,
  python3,
  csharp,
  kotlin,
  javascript,
}

extension ProgrammingLanguageExt on ProgrammingLanguage {
  Mode get mode {
    return switch (this) {
      ProgrammingLanguage.c => cpp,
      ProgrammingLanguage.cpp => cpp,
      ProgrammingLanguage.java => java,
      ProgrammingLanguage.python => python,
      ProgrammingLanguage.python3 => python,
      ProgrammingLanguage.csharp => cs,
      ProgrammingLanguage.kotlin => kotlin,
      ProgrammingLanguage.javascript => javascript,
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
      case ProgrammingLanguage.python3:
        return 'Python3';
      case ProgrammingLanguage.csharp:
        return 'C#';
      case ProgrammingLanguage.c:
        return 'C';
      case ProgrammingLanguage.kotlin:
        return 'Kotlin';
      case ProgrammingLanguage.javascript:
        return 'Javascript';
    }
  }

  /* 
  {
    "c": "c",
    "cpp": "cpp",
    "python": "py2",
    "python3": "py3",
    "java": "java",
    "golang": "go",
    "cangjie": "cangjie"
}
  */
  String get formatUrlCode {
    switch (this) {
      case ProgrammingLanguage.cpp:
        return 'cpp';
      case ProgrammingLanguage.java:
        return 'java';
      case ProgrammingLanguage.python:
        return 'py3'; // not sure using py3 here
      case ProgrammingLanguage.python3:
        return 'py3';
      case ProgrammingLanguage.csharp:
        return 'cs';
      case ProgrammingLanguage.c:
        return 'c';
      case ProgrammingLanguage.kotlin:
        return 'kotlin';
      case ProgrammingLanguage.javascript:
        return 'Javascript';
    }
  }
}

/// List of [ProgrammingLanguage] whose code formatting is not provided by leetcode
final List<ProgrammingLanguage> formatUnSupportedLanguages = [
  ProgrammingLanguage.csharp,
  ProgrammingLanguage.kotlin,
  ProgrammingLanguage.javascript,
];
