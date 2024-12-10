import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A comprehensive BlocObserver utility for tracking and logging Bloc events and state changes
class AppBlocObserver extends BlocObserver {
  /// Called when a Bloc is initially created
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('[AppBlocObserver] Bloc Created: '
        'Type = ${bloc.runtimeType}, '
        'HashCode = ${bloc.hashCode}');
  }

  /// Called when a Bloc is about to be closed
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('[AppBlocObserver] Bloc Closed: '
        'Type = ${bloc.runtimeType}, '
        'HashCode = ${bloc.hashCode}');
  }

  /// Called whenever a Change occurs in any Bloc
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('[AppBlocObserver] Bloc State Change: '
        'Type = ${bloc.runtimeType}, '
        'Current State = ${change.currentState}, '
        'Next State = ${change.nextState}');
  }

  /// Called whenever an Event is added to any Bloc
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('[AppBlocObserver] Bloc Event Added: '
        'Type = ${bloc.runtimeType}, '
        'Event = ${event.runtimeType}, '
        'Event Details = ${event.toString()}');
  }

  /// Called whenever an Error occurs in any Bloc
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('[AppBlocObserver] Bloc Error Occurred: '
        'Type = ${bloc.runtimeType}, '
        'Error = $error, '
        'StackTrace = $stackTrace');
  }

  /// Optional: Method to initialize the BlocObserver in the main app
  static void initialize() {
    Bloc.observer = AppBlocObserver();
  }
}
