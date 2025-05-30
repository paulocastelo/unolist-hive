/// 🔗 Extensões úteis para o projeto UnoList.
library;

import 'dart:math';

import 'package:flutter/material.dart';

/// 📅 Extensões para DateTime
extension DateTimeFormat on DateTime {
  /// Retorna a data no formato 'dd/MM/yyyy'
  String toShortDateString() {
    return '${day.toString().padLeft(2, '0')}/'
        '${month.toString().padLeft(2, '0')}/'
        '$year';
  }

  /// Retorna a data no formato 'yyyy-MM-dd'
  String toIsoDateString() {
    return '$year-'
        '${month.toString().padLeft(2, '0')}-'
        '${day.toString().padLeft(2, '0')}';
  }
}

/// 🔤 Extensões para String
extension StringValidation on String {
  /// Verifica se a string está vazia ou contém apenas espaços
  bool get isBlank => trim().isEmpty;

  /// Verifica se a string não está vazia
  bool get isNotBlank => trim().isNotEmpty;

  /// Capitaliza a primeira letra
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// 🔢 Extensões para int
extension NullableIntExtension on int? {
  /// Se nulo, retorna zero
  int orZero() => this ?? 0;
}

/// 🔢 Extensões para double
extension DoubleExtension on double {
  /// Arredonda para [decimals] casas decimais
  double roundTo(int decimals) {
    final factor = pow(10, decimals);
    return (this * factor).round() / factor;
  }
}

/// 🎨 Extensões para Color
extension ColorExtension on int {
  /// Converte um int ARGB para uma cor (Flutter)
  Color get toColor => Color(this);
}

/// 📚 Extensões para List
extension ListExtension<T> on List<T> {
  /// Retorna true se a lista estiver vazia ou nula
  bool get isNullOrEmpty => isEmpty;

  /// Retorna true se a lista tiver elementos
  bool get isNotNullOrEmpty => isNotEmpty;
}
