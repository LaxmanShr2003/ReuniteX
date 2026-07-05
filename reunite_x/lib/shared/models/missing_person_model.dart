/// The three urgency tiers shown as badges on the feed, plus a resolved
/// state for people who have been found. Derived from `age` + `status`
/// since the dataset itself doesn't carry an explicit alert level yet —
/// swap `alertLevel` for a real backend field once one exists.
enum AlertLevel { amber, critical, standard, found }

class MissingPersonModel {
  final int id;
  final int userId;
  final String fullName;
  final int age;
  final String gender;
  final String description;
  final String clothingDescription;
  final String lastSeenLocation;
  final DateTime lastSeenDate;
  final String imageUrl;
  final String status; // "Missing" | "Found"

  const MissingPersonModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.description,
    required this.clothingDescription,
    required this.lastSeenLocation,
    required this.lastSeenDate,
    required this.imageUrl,
    required this.status,
  });

  factory MissingPersonModel.fromJson(Map<String, dynamic> json) {
    return MissingPersonModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      fullName: json['fullName'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      description: json['description'] as String,
      clothingDescription: json['clothingDescription'] as String,
      lastSeenLocation: json['lastSeenLocation'] as String,
      lastSeenDate: DateTime.parse(json['lastSeenDate'] as String),
      imageUrl: json['imageUrl'] as String,
      status: json['status'] as String,
    );
  }

  bool get isFound => status.toLowerCase() == 'found';

  /// AMBER for missing minors, CRITICAL for missing seniors (higher
  /// vulnerability), STANDARD otherwise, FOUND overrides all of it.
  AlertLevel get alertLevel {
    if (isFound) return AlertLevel.found;
    if (age < 18) return AlertLevel.amber;
    if (age >= 60) return AlertLevel.critical;
    return AlertLevel.standard;
  }

  String get timeAgoLabel {
    final diff = DateTime.now().difference(lastSeenDate);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}