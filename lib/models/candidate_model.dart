class Candidate {
  final String id;
  final String name;
  final String party;
  final String imageUrl;
  final String description;
  final List<String> policies;

  Candidate({
    required this.id,
    required this.name,
    required this.party,
    required this.imageUrl,
    required this.description,
    required this.policies,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      party: json['party'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      policies: List<String>.from(json['policies'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'party': party,
      'imageUrl': imageUrl,
      'description': description,
      'policies': policies,
    };
  }
}

// Mock candidate data
class MockCandidates {
  static List<Candidate> getCandidates() {
    return [
      Candidate(
        id: 'CAND001',
        name: 'Alice Johnson',
        party: 'Progressive Party',
        imageUrl: 'https://i.pravatar.cc/300?img=1',
        description:
            'Experienced leader focused on education and healthcare reform',
        policies: [
          'Free healthcare for all citizens',
          'Increased education funding',
          'Climate action initiatives',
        ],
      ),
      Candidate(
        id: 'CAND002',
        name: 'Bob Smith',
        party: 'Democratic Alliance',
        imageUrl: 'https://i.pravatar.cc/300?img=12',
        description: 'Former senator with 20 years of public service',
        policies: [
          'Job creation programs',
          'Infrastructure development',
          'Tax reform',
        ],
      ),
      Candidate(
        id: 'CAND003',
        name: 'Carol Williams',
        party: 'Independent',
        imageUrl: 'https://i.pravatar.cc/300?img=5',
        description: 'Business leader and community advocate',
        policies: [
          'Small business support',
          'Technology innovation',
          'Youth empowerment',
        ],
      ),
      Candidate(
        id: 'CAND004',
        name: 'David Brown',
        party: 'Green Coalition',
        imageUrl: 'https://i.pravatar.cc/300?img=13',
        description: 'Environmental activist and former mayor',
        policies: [
          'Renewable energy transition',
          'Conservation programs',
          'Sustainable agriculture',
        ],
      ),
    ];
  }
}
