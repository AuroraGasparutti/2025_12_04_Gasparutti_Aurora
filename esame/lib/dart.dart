class Exercise {
  Exercise({
    required this.name,
    required this.score,
    required this.submittedAt,
  });

  final String name;
  final int score;
  final DateTime submittedAt;

  bool get isPassed => score >= 60;
}

List<Exercise> passedOnly(List<Exercise> exercises) {
  List<Exercise> passed = [];
  for (var ex in exercises) {
    if (ex.isPassed) {
      passed.add(ex);
    }
  }
  return passed;
}

double averageScore(List<Exercise> exercises) {
  if (exercises.isEmpty) return 0;
  int sum = 0;
  for (var e in exercises) {
    sum += e.score;
  }
  return sum / exercises.length;
}

String bestStudent(List<Exercise> exercises) {
  if (exercises.isEmpty) return "";

  Exercise best = exercises[0];

  for (var ex in exercises) {
    if (ex.score > best.score) {
      best = ex;
    }
  }

  return best.name;
}