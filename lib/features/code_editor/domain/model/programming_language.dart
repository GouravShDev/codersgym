import 'package:highlight/highlight.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/python.dart';

enum ProgrammingLanguage { cpp, java, python, python3 }

extension ProgrammingLanguageExt on ProgrammingLanguage {
  Mode get mode {
    return switch (this) {
      ProgrammingLanguage.cpp => cpp,
      ProgrammingLanguage.java => java,
      ProgrammingLanguage.python => python,
      ProgrammingLanguage.python3 => python,
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
    }
  }
}
