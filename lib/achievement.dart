class Achievement {
  int id;
  String name;
  String description;
  bool isObtained;

  Achievement({required this.id, required this.name, required this.description, this.isObtained = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isObtained': isObtained,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      isObtained: map['isObtained'],
    );
  }

  Achievement copyWith({int? id, bool? isObtained})
  {
    return Achievement(
      id: id ?? this.id,
      name: name,
      description: description,
      isObtained: isObtained ?? this.isObtained
    );
  }

  void complete() {
    isObtained = true;
  }
}

final List<Achievement> achievementDescriptions = [
  Achievement(
    id: 0,
    name: 'First Steps',
    description: 'Complete your first sleep session. Keep it up!'
  ),
  Achievement(
    id: 1,
    name: 'Week of Sleep',
    description: 'Manage your sleep for a week straight.'
  ),
];