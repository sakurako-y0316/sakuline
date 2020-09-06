class Talk {
  final DateTime createdAt;
  final String talk;
  final String talkId;
  final String senderUserId;
  final String talkRoomId;
  final bool yourSend;

  Talk({
    this.createdAt,
    this.talk,
    this.talkId,
    this.senderUserId,
    this.talkRoomId,
    this.yourSend,
  });
}
