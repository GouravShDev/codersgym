import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';

/// Extension on the ProgrammingLanguage enum to provide sample code snippets for each language
extension ProgrammingLanguageSampleCodeExtension on ProgrammingLanguage {
  /// Returns a sample code snippet for the given programming language
  String get sampleCode {
    switch (this) {
      case ProgrammingLanguage.c:
        return """bool twoSum(char* s, int k) {
    // Implementation here
    return false;
}""";
      case ProgrammingLanguage.cpp:
        return """class Solution {
public:
    bool twoSum(string s, int k) {
        // Implementation here
        return false;
    }
};""";
      case ProgrammingLanguage.java:
        return """class Solution {
    public boolean twoSum(String s, int k) {
        // Implementation here
        return false;
    }
}""";
      case ProgrammingLanguage.python:
      case ProgrammingLanguage.python3:
        return """class Solution:
    def two_sum(self, s, k):
        # Implementation here
        return False""";
      case ProgrammingLanguage.csharp:
        return """public class Solution {
    public bool TwoSum(string s, int k) {
        // Implementation here
        return false;
    }
}""";
      case ProgrammingLanguage.kotlin:
        return """class Solution {
    fun twoSum(s: String, k: Int): Boolean {
        // Implementation here
        return false
    }
}""";
      case ProgrammingLanguage.javascript:
        return """/**
 * @param {string} s
 * @param {number} k
 * @return {boolean}
 */
var twoSum = function(s, k) {
    // Implementation here
    return false;
};""";
    }
  }
}
