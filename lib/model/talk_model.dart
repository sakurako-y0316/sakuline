class Talk {
  final DateTime createdAt;
  final String talk;
  final String uid;
  final String fromUserName;
  final String toUserName;

  Talk(
      {this.createdAt,
      this.talk,
      this.uid,
      this.fromUserName,
      this.toUserName});
}
