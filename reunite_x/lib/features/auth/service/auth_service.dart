import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:reunite_x/shared/models/user_model.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

/// Mock authentication backed by the bundled `users.json` asset, standing
/// in for a real backend until one exists.
///
/// The dataset has no password field, so every account in `users.json`
/// authenticates with the same placeholder password: [demoPassword].
/// That's a testing convenience only — obviously not how a real login
/// should ever work.
///
/// `login()` keeps the same async signature a real HTTP call would have
/// (returns a Future, throws on failure) so replacing the body with a real
/// API request later doesn't require touching any calling code.
class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  static const demoPassword = 'password123';
  static const _usersAssetPath = 'assets/users.json';

  List<UserModel>? _cachedUsers;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<List<UserModel>> _loadUsers() async {
    if (_cachedUsers != null) return _cachedUsers!;
    final raw = await rootBundle.loadString(_usersAssetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _cachedUsers = (decoded['users'] as List)
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cachedUsers!;
  }

  /// Simulates a network round trip, checks the email against the dummy
  /// dataset, and throws [AuthException] with a user-facing message on
  /// failure — the same shape of error handling the UI will need once a
  /// real backend is behind this.
  Future<UserModel> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final users = await _loadUsers();
    final normalizedEmail = email.trim().toLowerCase();

    final matches = users.where((u) => u.email.toLowerCase() == normalizedEmail);
    if (matches.isEmpty) {
      throw AuthException('No account found for that email.');
    }
 

    _currentUser = matches.first;
    return _currentUser!;
  }

  void logout() {
    _currentUser = null;
  }
}