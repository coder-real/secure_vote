// ...existing code...
class Voter {
  final String id;
  final String name;
  final bool isVerified;
  final bool hasVoted;

  Voter({
    required this.id,
    required this.name,
    required this.isVerified,
    this.hasVoted = false,
  });

  // Compatibility alias for older code that expects `voterId`
  String get voterId => id;

  Voter copyWith({String? id, String? name, bool? isVerified, bool? hasVoted}) {
    return Voter(
      id: id ?? this.id,
      name: name ?? this.name,
      isVerified: isVerified ?? this.isVerified,
      hasVoted: hasVoted ?? this.hasVoted,
    );
  }

  factory Voter.fromJson(Map<String, dynamic> json) {
    return Voter(
      id: json['voterId'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      isVerified: json['isVerified'] ?? false,
      hasVoted: json['hasVoted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voterId': id,
      'name': name,
      'isVerified': isVerified,
      'hasVoted': hasVoted,
    };
  }
}
// ...existing code...