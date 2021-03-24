class History {
  final int id;
  final int user;
  final String url;
  final String latex;
  final List<String> roots;
  final String message;
  final String success;
  final DateTime dateTime;
  final String expression;

  History(this.id, this.user, this.url, this.latex, this.roots, this.message,
      this.success, this.dateTime, this.expression);
  factory History.fromJson(Map<String, dynamic> data) {
    List<dynamic> rootsJson = data['roots'];
    List<String> roots =
        rootsJson != null ? rootsJson.map((e) => e.toString()).toList() : [];
    return History(
      data['id'] as int,
      data['url'] as int,
      data['user'] as String,
      data['latex'] as String,
      roots,
      data['message'] as String,
      data['success'] as String,
      data['dateTime'] as DateTime,
      data['expression'] as String,
    );
  }
}
