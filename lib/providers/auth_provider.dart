import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/voter_model.dart';
import '../services/api_service.dart';

// Authentication state
class AuthState {
  final Voter? voter;
  final bool isLoading;
  final String? errorMessage;

  AuthState({this.voter, this.isLoading = false, this.errorMessage});

  AuthState copyWith({Voter? voter, bool? isLoading, String? errorMessage}) {
    return AuthState(
      voter: voter ?? this.voter,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Authentication notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  // Authenticate voter with corrected API call
  Future<bool> authenticateVoter(String uid) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Call the STATIC method from ApiService
      final result = await ApiService.authenticateVoter(uid);

      if (result['success']) {
        // Create voter from the response
        final voter = Voter(
          id: result['voterId'] as String,
          name: result['name'] as String? ?? 'Unknown',
          isVerified: result['isVerified'] as bool? ?? true,
        );

        state = state.copyWith(
          voter: voter,
          isLoading: false,
          errorMessage: null,
        );

        state = AuthState(voter: voter, isLoading: false, errorMessage: null);

        return true;
      } else {
        // Authentication failed
        state = AuthState(
          voter: null,
          isLoading: false,
          errorMessage: result['message'],
        );

        return false;
      }
    } catch (e) {
      state = AuthState(
        voter: null,
        isLoading: false,
        errorMessage: 'Authentication failed. Please try again.',
      );

      return false;
    }
  }

  // Mark voter as having voted
  void markAsVoted() {
    if (state.voter != null) {
      state = state.copyWith(voter: state.voter!.copyWith(hasVoted: true));
    }
  }

  // Logout
  void logout() {
    state = AuthState();
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
