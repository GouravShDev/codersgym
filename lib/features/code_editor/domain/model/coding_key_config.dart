import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class CodingKeyConfig extends Equatable {
  final String id;

  const CodingKeyConfig({
    required this.id,
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
  List<Object?> get props => [hashCode, id];
}

sealed class CodingTextKeyConfig extends CodingKeyConfig {
  final String label;
  CodingTextKeyConfig({
    required super.id,
    required this.label,
  });
}

sealed class CodingIconKeyConfig extends CodingKeyConfig {
  final IconData? icon;

  CodingIconKeyConfig({
    required super.id,
    required this.icon,
  });
}

// Text-based keys
class TabCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "tab";
  TabCodingKeyConfig() : super(id: ID, label: "Tab");
}

class CurlyCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "curly";
  CurlyCodingKeyConfig() : super(id: ID, label: "{}");
}

class ParenthesesCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "parentheses";
  ParenthesesCodingKeyConfig() : super(id: ID, label: "()");
}

class BracketsCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "brackets";
  BracketsCodingKeyConfig() : super(id: ID, label: "[]");
}

class PipeCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "pipe";
  PipeCodingKeyConfig() : super(id: ID, label: "|");
}

class AmpersandCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "ampersand";
  AmpersandCodingKeyConfig() : super(id: ID, label: "&");
}

class UnderscoreCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "underscore";
  UnderscoreCodingKeyConfig() : super(id: ID, label: "_");
}

class SemicolonCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "semicolon";
  SemicolonCodingKeyConfig() : super(id: ID, label: ";");
}

class AngleCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "angle";
  AngleCodingKeyConfig() : super(id: ID, label: "<>");
}

class DoubleQuoteCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "doubleQuote";
  DoubleQuoteCodingKeyConfig() : super(id: ID, label: '" "');
}

class SingleQuoteCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "singleQuote";
  SingleQuoteCodingKeyConfig() : super(id: ID, label: "' '");
}

class ExclamationCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "exclamation";
  ExclamationCodingKeyConfig() : super(id: ID, label: "!");
}

class QuestionCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "question";
  QuestionCodingKeyConfig() : super(id: ID, label: "?");
}

class ColonCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "colon";
  ColonCodingKeyConfig() : super(id: ID, label: ":");
}

class BackslashCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "backslash";
  BackslashCodingKeyConfig() : super(id: ID, label: "\\");
}

class PlusCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "plus";
  PlusCodingKeyConfig() : super(id: ID, label: "+");
}

class MinusCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "minus";
  MinusCodingKeyConfig() : super(id: ID, label: "-");
}

class MultiplyCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "multiply";
  MultiplyCodingKeyConfig() : super(id: ID, label: "*");
}

class DivideCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "divide";
  DivideCodingKeyConfig() : super(id: ID, label: "/");
}

class ModuloCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "modulo";
  ModuloCodingKeyConfig() : super(id: ID, label: "%");
}

class EqualsCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "equals";
  EqualsCodingKeyConfig() : super(id: ID, label: "=");
}

class CaretCodingKeyConfig extends CodingTextKeyConfig {
  static const String ID = "caret";
  CaretCodingKeyConfig() : super(id: ID, label: "^");
}

// Icon-based keys
class UndoCodingKeyConfig extends CodingIconKeyConfig {
  static const String ID = "undo";
  UndoCodingKeyConfig() : super(id: ID, icon: Icons.undo);
}

class RedoCodingKeyConfig extends CodingIconKeyConfig {
  static const String ID = "redo";
  RedoCodingKeyConfig() : super(id: ID, icon: Icons.redo);
}

class UpArrowCodingKeyConfig extends CodingIconKeyConfig {
  static const String ID = "up";
  UpArrowCodingKeyConfig() : super(id: ID, icon: Icons.arrow_upward);
}

class DownArrowCodingKeyConfig extends CodingIconKeyConfig {
  static const String ID = "down";
  DownArrowCodingKeyConfig() : super(id: ID, icon: Icons.arrow_downward);
}

class LeftArrowCodingKeyConfig extends CodingIconKeyConfig {
  static const String ID = "left";
  LeftArrowCodingKeyConfig() : super(id: ID, icon: Icons.arrow_back);
}

class RightArrowCodingKeyConfig extends CodingIconKeyConfig {
  static const String ID = "right";
  RightArrowCodingKeyConfig() : super(id: ID, icon: Icons.arrow_forward);
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
