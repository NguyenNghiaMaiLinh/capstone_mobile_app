class ResultItem {
  final bool success;
  final String message;
  final String expression;
  final String latex;
  final List<double> roots;

  ResultItem(
      this.success, this.message, this.latex, this.expression, this.roots);

  // factory ResultItem.fromJson(Map<String, dynamic> json) => ResultItem(
  //       expression: json["expression"],
  //       roots: List<double>.from(json["roots"].map((x) => x)),
  //     );
}
