import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final supabase = Supabase.instance.client;


  Future<void> signUpUser( {required String email, required String password, required String lastName, required String firstName}) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'lastName': lastName,
        'firstName': firstName,
      },

    );
    print('Utilisateur inscrit : ${response.user?.email}');
    print('response: ${response.user}');
  }

  Future<void> signInUser({required String email, required String password}) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    print('Utilisateur connecté : ${response.user?.email}');
    print('response: ${response.user}');
    print('response: ${response}');
  }

  Future<void> signOutUser() async {
    await supabase.auth.signOut();
  }

  bool isLogged() {
    final user = supabase.auth.currentUser;
    return (user != null);
  }


}
