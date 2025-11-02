import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ApiService {
  // Simulate network delay
  static Future<void> _simulateDelay() async {
    await Future.delayed(Duration(milliseconds: 1500 + Random().nextInt(1000)));
  }

  // Mock registered voter UIDs - THESE ARE THE ONLY VALID CARDS
  static final List<String> _registeredVoters = [
    'CARD001',
    'CARD002',
    'CARD003',
    'CARD123',
    'VOTER001',
    'VOTER002',
    'TEST001',
    'RFID12345',
  ];

  // Track voters who have already voted
  static final Set<String> _votedVoters = {};

  /// Authenticate voter by RFID card UID
  /// Returns a map with authentication result
  static Future<Map<String, dynamic>> authenticateVoter(String uid) async {
    await _simulateDelay();

    // Normalize the UID (uppercase and trim)
    final normalizedUid = uid.trim().toUpperCase();

    // Check if UID is empty
    if (normalizedUid.isEmpty) {
      return {'success': false, 'message': 'Please enter a valid card UID'};
    }

    // CHECK IF VOTER IS REGISTERED - THIS IS THE KEY CHECK!
    if (!_registeredVoters.contains(normalizedUid)) {
      return {
        'success': false,
        'message': 'Card not registered. Please contact election officials.',
      };
    }

    // Check if voter has already voted
    if (_votedVoters.contains(normalizedUid)) {
      return {
        'success': false,
        'message': 'This card has already been used to vote.',
      };
    }

    // Authentication successful - card is valid and hasn't voted yet
    return {
      'success': true,
      'message': 'Authentication successful',
      'voterId': normalizedUid,
      'data': {
        'voterId': normalizedUid,
        'name': 'Voter ${normalizedUid.substring(0, 7)}',
        'isVerified': true,
      },
    };
  }

  /// Cast a vote for a candidate
  /// Returns blockchain transaction hash
  static Future<Map<String, dynamic>> castVote(
    String voterId,
    String candidateId,
  ) async {
    await _simulateDelay();

    // Mark voter as having voted
    _votedVoters.add(voterId.toUpperCase());

    // Generate mock blockchain hash
    final txHash = _generateBlockchainHash(voterId, candidateId);

    return {
      'success': true,
      'transactionHash': txHash,
      'timestamp': DateTime.now().toIso8601String(),
      'blockNumber': Random().nextInt(1000000) + 500000,
    };
  }

  /// Generate a realistic blockchain transaction hash
  static String _generateBlockchainHash(String voterId, String candidateId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(999999);
    final data = '$voterId-$candidateId-$timestamp-$random';

    final bytes = utf8.encode(data);
    final hash = sha256.convert(bytes);

    return '0x${hash.toString().substring(0, 64)}';
  }

  /// Get election results (mock data)
  static Future<Map<String, dynamic>> getResults() async {
    await _simulateDelay();

    return {
      'success': true,
      'totalVotes': 1247,
      'totalRegistered': 2500,
      'turnout': 49.88,
      'candidates': [
        {
          'id': 'CAND001',
          'name': 'Alice Johnson',
          'party': 'Progressive Party',
          'votes': 456,
          'percentage': 36.6,
        },
        {
          'id': 'CAND002',
          'name': 'Bob Smith',
          'party': 'Democratic Alliance',
          'votes': 398,
          'percentage': 31.9,
        },
        {
          'id': 'CAND003',
          'name': 'Carol Williams',
          'party': 'Independent',
          'votes': 283,
          'percentage': 22.7,
        },
        {
          'id': 'CAND004',
          'name': 'David Brown',
          'party': 'Green Coalition',
          'votes': 110,
          'percentage': 8.8,
        },
      ],
    };
  }

  /// Admin login (mock authentication)
  static Future<Map<String, dynamic>> adminLogin(
    String email,
    String password,
  ) async {
    await _simulateDelay();

    // Mock admin credentials
    if (email == 'admin@voting.com' && password == 'admin123') {
      return {
        'success': true,
        'message': 'Login successful',
        'token': _generateBlockchainHash('admin', email),
      };
    }

    return {'success': false, 'message': 'Invalid email or password'};
  }

  /// Get list of registered voters (for testing)
  static List<String> getRegisteredVoters() {
    return List.from(_registeredVoters);
  }

  /// Reset voting state (for testing)
  static void resetVotingState() {
    _votedVoters.clear();
  }
}
