import 'package:bloc/bloc.dart';
import '../../../gitit/gitit.dart';
import '../../repository/authentication_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository = locator.get();

  AuthBloc() : super(AuthInitState()) {
    on<AuthLoginRequest>((event, emit) async {
      emit(AuthLoadingState());
      var login = await _authRepository.login(event.username, event.password);
      print("Login response: $login");

      emit(AuthRequestSuccessState(login));
    });
    on<AuthRegisterRequest>((event, emit) async {
      emit(AuthLoadingState());
      var register = await _authRepository.register(
          event.email, event.password, event.passwordConfirm, event.name);

      emit(AuthRequestSuccessState(register));
    });
  }
}