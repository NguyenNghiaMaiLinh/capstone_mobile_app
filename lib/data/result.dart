class ResultItem {
  final bool success;
  final String message;
  final String expression;
  final String latex;
  final int id;
  final int user;
  final int status;
  final String url;
  final String datetime;
  final List<String> roots;

  ResultItem(this.success, this.message, this.latex, this.expression,
      this.roots, this.id, this.url, this.user, this.datetime, this.status);

  // factory ResultItem.fromJson(Map<String, dynamic> json) => ResultItem(
  //       expression: json["expression"],
  //       expression: json["message"],
  //       expression: json["expression"],
  //       expression: json["expression"],
  //       roots: List<double>.from(json["roots"].map((x) => x)),
  //     );
}
