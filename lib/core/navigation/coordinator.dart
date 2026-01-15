import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/services/navigation_service.dart';

/// Base interface for feature coordinators.
/// Each coordinator handles a subset of FlowEvents.
abstract class Coordinator {
  /// Returns true if this coordinator can handle the given event.
  bool canHandle(FlowEvent event);

  /// Handles the event. Only called if canHandle returns true.
  void handle(FlowEvent event);
}

/// Base class for coordinators with common functionality.
abstract class BaseCoordinator implements Coordinator {
  BaseCoordinator(this.navigation);

  final NavigationService navigation;
}
