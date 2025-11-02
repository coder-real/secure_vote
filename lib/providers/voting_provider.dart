import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/candidate_model.dart';
import '../services/api_service.dart';

// Voting state
class VotingState {
  final List<Candidate> candidates;
  final Candidate? selectedCandidate;
  final bool isLoading;
  final bool voteSubmitted;
  final String? transactionHash;
  final String? errorMessage;

  VotingState({
    this.candidates = const [],
    this.selectedCandidate,
    this.isLoading = false,
    this.voteSubmitted = false,
    this.transactionHash,
    this.errorMessage,
  });

  VotingState copyWith({
    List<Candidate>? candidates,
    Candidate? selectedCandidate,
    bool? isLoading,
    bool? voteSubmitted,
    String? transactionHash,
    String? errorMessage,
  }) {
    return VotingState(
      candidates: candidates ?? this.candidates,
      selectedCandidate: selectedCandidate ?? this.selectedCandidate,
      isLoading: isLoading ?? this.isLoading,
      voteSubmitted: voteSubmitted ?? this.voteSubmitted,
      transactionHash: transactionHash ?? this.transactionHash,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Voting notifier
class VotingNotifier extends StateNotifier<VotingState> {
  VotingNotifier() : super(VotingState()) {
    loadCandidates();
  }

  // Load candidates
  void loadCandidates() {
    state = state.copyWith(candidates: MockCandidates.getCandidates());
  }

  // Select a candidate
  void selectCandidate(Candidate candidate) {
    state = state.copyWith(selectedCandidate: candidate);
  }

  // Clear selection
  void clearSelection() {
    state = state.copyWith(selectedCandidate: null, errorMessage: null);
  }

  // Submit vote
  Future<bool> submitVote(String voterId) async {
    if (state.selectedCandidate == null) {
      state = state.copyWith(errorMessage: 'Please select a candidate');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await ApiService.castVote(
        voterId,
        state.selectedCandidate!.id,
      );

      if (result['success']) {
        state = VotingState(
          candidates: state.candidates,
          selectedCandidate: state.selectedCandidate,
          isLoading: false,
          voteSubmitted: true,
          transactionHash: result['transactionHash'],
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to submit vote. Please try again.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred. Please try again.',
      );
      return false;
    }
  }

  // Reset voting state
  void reset() {
    state = VotingState(candidates: MockCandidates.getCandidates());
  }
}

// Provider
final votingProvider = StateNotifierProvider<VotingNotifier, VotingState>((
  ref,
) {
  return VotingNotifier();
});
