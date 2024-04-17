class Todo {
  final String title;
  final String content;
  final String date;
  late String isCompleted;
  final int id;

  Todo({
    required this.title,
    required this.content,
    required this.date,
    required this.isCompleted,
    required this.id,
  });
}
