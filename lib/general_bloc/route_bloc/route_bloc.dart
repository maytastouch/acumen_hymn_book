import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define your Route events
abstract class RouteEvent {}

class GetLastRoute extends RouteEvent {}

class SetNewRoute extends RouteEvent {
  final String routeName;
  SetNewRoute(this.routeName);
}

// Define your Route states
abstract class RouteState {}

class RouteInitial extends RouteState {}

class RouteLoaded extends RouteState {
  final String routeName;
  RouteLoaded(this.routeName);
}

// RouteBloc implementation
class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc() : super(RouteInitial()) {
    on<GetLastRoute>(_onGetLastRoute);
    on<SetNewRoute>(_onSetNewRoute);
  }

  // Handler for GetLastRoute event
  Future<void> _onGetLastRoute(
      GetLastRoute event, Emitter<RouteState> emit) async {
    final lastRoute = await _getLastSavedRoute();
    emit(RouteLoaded(lastRoute));
  }

  // Handler for SetNewRoute event
  Future<void> _onSetNewRoute(
      SetNewRoute event, Emitter<RouteState> emit) async {
    await _saveRoute(event.routeName);
    emit(RouteLoaded(event.routeName));
  }

  Future<void> _saveRoute(String routeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_route', routeName);
    print('Saved route: $routeName'); // Debugging
  }

  Future<String> _getLastSavedRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final routeName = prefs.getString('last_route') ?? 'default_route';
    print('Loaded route: $routeName'); // Debugging
    return routeName;
  }
}
