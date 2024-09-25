class Achievement {
  int id;
  String name;
  String description;
  bool isObtained;

  Achievement({required this.id, required this.name, required this.description, this.isObtained = false});

  Map<String, dynamic> toMap({compact=false}) {
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

  void setIsObtained({bool state=true}) {
    isObtained = state;
  }
}

final List<Achievement> achievementDescriptions = [
  Achievement(
    id: 0,
    name: 'Sweet Dreams',
    description: 'Complete your first sleep session. Keep it up!'
  ),
  Achievement(
    id: 1,
    name: 'Noon Nap',
    description: 'Sleep a little after lunch. Don\'t stay late at evening though!'
  ),
  Achievement(
    id: 2,
    name: 'Week of Sleep',
    description: 'Manage your sleep for a week straight. Not so hard, right?'
  ),
  Achievement(
    id: 3,
    name: 'Month of Sleep',
    description: 'Manage your sleep for a month straight.'
  ),
  Achievement(
    id: 4,
    name: 'Creating Habits',
    description: 'Manage your sleep for a 2 months. They say habits form after 66 days on average. Do you feel like it?'
  ),
];