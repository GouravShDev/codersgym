import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class CodingKeyConfig extends Equatable {
  final String id;

  final String description;
  const CodingKeyConfig({
    required this.id,
    required this.description,
  });

  static final Map<String, CodingKeyConfig Function()> lookupMap = {
    TabCodingKeyConfig.ID: () => TabCodingKeyConfig(),
    CurlyCodingKeyConfig.ID: () => CurlyCodingKeyConfig(),
    ParenthesesCodingKeyConfig.ID: () => ParenthesesCodingKeyConfig(),
    BracketsCodingKeyConfig.ID: () => BracketsCodingKeyConfig(),
    UndoCodingKeyConfig.ID: () => UndoCodingKeyConfig(),
    UpArrowCodingKeyConfig.ID: () => UpArrowCodingKeyConfig(),
    RedoCodingKeyConfig.ID: () => RedoCodingKeyConfig(),
    PipeCodingKeyConfig.ID: () => PipeCodingKeyConfig(),
    AmpersandCodingKeyConfig.ID: () => AmpersandCodingKeyConfig(),
    UnderscoreCodingKeyConfig.ID: () => UnderscoreCodingKeyConfig(),
    SemicolonCodingKeyConfig.ID: () => SemicolonCodingKeyConfig(),
    LeftArrowCodingKeyConfig.ID: () => LeftArrowCodingKeyConfig(),
    DownArrowCodingKeyConfig.ID: () => DownArrowCodingKeyConfig(),
    RightArrowCodingKeyConfig.ID: () => RightArrowCodingKeyConfig(),
    AngleCodingKeyConfig.ID: () => AngleCodingKeyConfig(),
    DoubleQuoteCodingKeyConfig.ID: () => DoubleQuoteCodingKeyConfig(),
    SingleQuoteCodingKeyConfig.ID: () => SingleQuoteCodingKeyConfig(),
    ExclamationCodingKeyConfig.ID: () => ExclamationCodingKeyConfig(),
    QuestionCodingKeyConfig.ID: () => QuestionCodingKeyConfig(),
    ColonCodingKeyConfig.ID: () => ColonCodingKeyConfig(),
    BackslashCodingKeyConfig.ID: () => BackslashCodingKeyConfig(),
    PlusCodingKeyConfig.ID: () => PlusCodingKeyConfig(),
    MinusCodingKeyConfig.ID: () => MinusCodingKeyConfig(),
    MultiplyCodingKeyConfig.ID: () => MultiplyCodingKeyConfig(),
    DivideCodingKeyConfig.ID: () => DivideCodingKeyConfig(),
    ModuloCodingKeyConfig.ID: () => ModuloCodingKeyConfig(),
    EqualsCodingKeyConfig.ID: () => EqualsCodingKeyConfig(),
    CaretCodingKeyConfig.ID: () => CaretCodingKeyConfig(),
  };

  static final List<String> defaultCodingKeyConfiguration = [
    TabCodingKeyConfig.ID,
    CurlyCodingKeyConfig.ID,
    ParenthesesCodingKeyConfig.ID,
    BracketsCodingKeyConfig.ID,
    UndoCodingKeyConfig.ID,
    UpArrowCodingKeyConfig.ID,
    RedoCodingKeyConfig.ID,
    PipeCodingKeyConfig.ID,
    AmpersandCodingKeyConfig.ID,
    UnderscoreCodingKeyConfig.ID,
    SemicolonCodingKeyConfig.ID,
    LeftArrowCodingKeyConfig.ID,
    DownArrowCodingKeyConfig.ID,
    RightArrowCodingKeyConfig.ID,
    AngleCodingKeyConfig.ID,
    DoubleQuoteCodingKeyConfig.ID,
    SingleQuoteCodingKeyConfig.ID,
    ExclamationCodingKeyConfig.ID,
    QuestionCodingKeyConfig.ID,
    ColonCodingKeyConfig.ID,
    BackslashCodingKeyConfig.ID,
    PlusCodingKeyConfig.ID,
    MinusCodingKeyConfig.ID,
    MultiplyCodingKeyConfig.ID,
    DivideCodingKeyConfig.ID,
    ModuloCodingKeyConfig.ID,
    EqualsCodingKeyConfig.ID,
    CaretCodingKeyConfig.ID,
  ];

  static CodingKeyConfig? fromId(String id) {
    final constructor = lookupMap[id];
    return constructor?.call();
  }

  @override
  List<Object?> get props => [id];
}

sealed class CodingTextKeyConfig extends CodingKeyConfig {
  final String label;
  CodingTextKeyConfig({
    required super.id,
    required super.description,
    required this.label,
  });
}

sealed class CodingIconKeyConfig extends CodingKeyConfig {
  final IconData? icon;

  CodingIconKeyConfig({
    required super.id,
    required super.description,
    required this.icon,
  });
}

// Text-based keys
class TabCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "tab";
  TabCodingKeyConfig() : super(
    id: ID, 
    label: "Tab", 
    description: "Insert indentation or move focus to next input field"
  );
}

class CurlyCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "curly";
  CurlyCodingKeyConfig() : super(
    id: ID, 
    label: "{}", 
    description: "Insert curly braces for code blocks or object literals"
  );
}

class ParenthesesCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "parentheses";
  ParenthesesCodingKeyConfig() : super(
    id: ID, 
    label: "()", 
    description: "Insert parentheses for function calls, grouping expressions"
  );
}

class BracketsCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "brackets";
  BracketsCodingKeyConfig() : super(
    id: ID, 
    label: "[]", 
    description: "Insert square brackets for arrays or indexing"
  );
}

class PipeCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "pipe";
  PipeCodingKeyConfig() : super(
    id: ID, 
    label: "|", 
    description: "Bitwise OR operator or used in lambda expressions"
  );
}

class AmpersandCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "ampersand";
  AmpersandCodingKeyConfig() : super(
    id: ID, 
    label: "&", 
    description: "Bitwise AND operator or reference operator"
  );
}

class UnderscoreCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "underscore";
  UnderscoreCodingKeyConfig() : super(
    id: ID, 
    label: "_", 
    description: "Used in variable naming or as a placeholder"
  );
}

class SemicolonCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "semicolon";
  SemicolonCodingKeyConfig() : super(
    id: ID, 
    label: ";", 
    description: "Statement terminator in many programming languages"
  );
}

class AngleCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "angle";
  AngleCodingKeyConfig() : super(
    id: ID, 
    label: "<>", 
    description: "Used for comparison or generics in type definitions"
  );
}

class DoubleQuoteCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "doubleQuote";
  DoubleQuoteCodingKeyConfig() : super(
    id: ID, 
    label: '" "', 
    description: "Enclose string literals in double quotes"
  );
}

class SingleQuoteCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "singleQuote";
  SingleQuoteCodingKeyConfig() : super(
    id: ID, 
    label: "' '", 
    description: "Enclose character or string literals in single quotes"
  );
}

class ExclamationCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "exclamation";
  ExclamationCodingKeyConfig() : super(
    id: ID, 
    label: "!", 
    description: "Logical NOT operator or add emphasis"
  );
}

class QuestionCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "question";
  QuestionCodingKeyConfig() : super(
    id: ID, 
    label: "?", 
    description: "Ternary operator or optional chaining"
  );
}

class ColonCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "colon";
  ColonCodingKeyConfig() : super(
    id: ID, 
    label: ":", 
    description: "Used in ternary expressions or key-value pair definitions"
  );
}

class BackslashCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "backslash";
  BackslashCodingKeyConfig() : super(
    id: ID, 
    label: "\\", 
    description: "Escape character or path separator"
  );
}

class PlusCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "plus";
  PlusCodingKeyConfig() : super(
    id: ID, 
    label: "+", 
    description: "Addition operator or positive sign"
  );
}

class MinusCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "minus";
  MinusCodingKeyConfig() : super(
    id: ID, 
    label: "-", 
    description: "Subtraction operator or negative sign"
  );
}

class MultiplyCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "multiply";
  MultiplyCodingKeyConfig() : super(
    id: ID, 
    label: "*", 
    description: "Multiplication operator or wildcard"
  );
}

class DivideCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "divide";
  DivideCodingKeyConfig() : super(
    id: ID, 
    label: "/", 
    description: "Division operator or path separator"
  );
}

class ModuloCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "modulo";
  ModuloCodingKeyConfig() : super(
    id: ID, 
    label: "%", 
    description: "Modulo operator for finding remainder"
  );
}

class EqualsCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "equals";
  EqualsCodingKeyConfig() : super(
    id: ID, 
    label: "=", 
    description: "Assignment operator or comparison"
  );
}

class CaretCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "caret";
  CaretCodingKeyConfig() : super(
    id: ID, 
    label: "^", 
    description: "Bitwise XOR operator or exponentiation"
  );
}

// Icon-based keys
class UndoCodingKeyConfig extends CodingIconKeyConfig {
  static const String ID = "undo";
  UndoCodingKeyConfig() : super(
    id: ID, 
    icon: Icons.undo,
    description: "Revert the last action or change"
  );
}

class RedoCodingKeyConfig extends CodingIconKeyConfig {
  static const String ID = "redo";
  RedoCodingKeyConfig() : super(
    id: ID, 
    icon: Icons.redo,
    description: "Restore the most recently undone action"
  );
}

class UpArrowCodingKeyConfig extends CodingIconKeyConfig {
  static const String ID = "up";
  UpArrowCodingKeyConfig() : super(
    id: ID, 
    icon: Icons.arrow_upward,
    description: "Move cursor or selection upward"
  );
}

class DownArrowCodingKeyConfig extends CodingIconKeyConfig {
  static const String ID = "down";
  DownArrowCodingKeyConfig() : super(
    id: ID, 
    icon: Icons.arrow_downward,
    description: "Move cursor or selection downward"
  );
}

class LeftArrowCodingKeyConfig extends CodingIconKeyConfig {
  static const String ID = "left";
  LeftArrowCodingKeyConfig() : super(
    id: ID, 
    icon: Icons.arrow_back,
    description: "Move cursor or selection to the left"
  );
}

class RightArrowCodingKeyConfig extends CodingIconKeyConfig {
  static const String ID = "right";
  RightArrowCodingKeyConfig() : super(
    id: ID, 
    icon: Icons.arrow_forward,
    description: "Move cursor or selection to the right"
  );
}
final List<CodingKeyConfig> allAvailableCodingKeys = [
  // Text-based keys - Basic Symbols
  TabCodingKeyConfig(),
  CurlyCodingKeyConfig(),
  ParenthesesCodingKeyConfig(),
  BracketsCodingKeyConfig(),
  PipeCodingKeyConfig(),
  AmpersandCodingKeyConfig(),
  UnderscoreCodingKeyConfig(),
  SemicolonCodingKeyConfig(),
  AngleCodingKeyConfig(),

  // Text-based keys - Quotes
  DoubleQuoteCodingKeyConfig(),
  SingleQuoteCodingKeyConfig(),

  // Text-based keys - Punctuation
  ExclamationCodingKeyConfig(),
  QuestionCodingKeyConfig(),
  ColonCodingKeyConfig(),
  BackslashCodingKeyConfig(),

  // Text-based keys - Operators
  PlusCodingKeyConfig(),
  MinusCodingKeyConfig(),
  MultiplyCodingKeyConfig(),
  DivideCodingKeyConfig(),
  ModuloCodingKeyConfig(),
  EqualsCodingKeyConfig(),
  CaretCodingKeyConfig(),

  // Icon-based keys - History Actions
  UndoCodingKeyConfig(),
  RedoCodingKeyConfig(),

  // Icon-based keys - Navigation
  UpArrowCodingKeyConfig(),
  DownArrowCodingKeyConfig(),
  LeftArrowCodingKeyConfig(),
  RightArrowCodingKeyConfig(),
];
