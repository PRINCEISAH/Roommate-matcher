import 'package:firebase_auth/firebase_auth.dart';
import '../../core/api_services/user_api_services.dart';
import '../../core/models/user.dart';
import '../../core/api_services/auth_api_service.dart';

// Todo Remove all print statement in this class after feature confirmation

/// MemberRepository is the single source of truth for user services
class UserRepository {
  final AuthApiService _authApi;
  UserRepository({AuthApiService userService})
      : _authApi = userService ?? AuthApiService();

  Future<User> getCurrentUser() async {
    String userId = await _authApi.getUserId();
    return UserApiService.getUser(userId);
  }

  Future<bool> isSignedIn() => _authApi.isSignedIn();
  void signOut() => _authApi.signOut();

  Future<void> signInWithCredentials(String email, String password) async {
    await _authApi.signInWithCredentials(email, password);
  }

  Future<void> signInWithGoogle() async {
    final firebaseUser = await _authApi.signInWithGoogle();
    User user = await UserApiService.getUser(firebaseUser.uid);
    if (user == null) {
      await UserApiService.saveUser(firebaseUser);
    }
  }

  Future signUp(String username, String email, String password) async {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = username;
    FirebaseUser firebaseUser =
        await _authApi.signUp(email: email, password: password);

    await firebaseUser.updateProfile(updateInfo);
    await firebaseUser.reload();
    firebaseUser = await FirebaseAuth.instance.currentUser();
    print('This is the  username after upload ${firebaseUser.displayName} ');

    await UserApiService.saveUser(firebaseUser);
  }

  Future<void> resetPassword(String email) => _authApi.resetPassword(email);
}
