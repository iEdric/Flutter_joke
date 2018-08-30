

class JokeGet {
  final String hashId;
  final int unixtime;
  final String content;
  final String updatetime;

  JokeGet({this.hashId, this.unixtime, this.content, this.updatetime});

  factory JokeGet.fromJson(Map<String, dynamic> json) {
    return new JokeGet(
      hashId: json['hashId'],
      content: json['content'],
      unixtime: json['unixtime'],
      updatetime: json['updatetime'],
    );
  }
}