import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String uid;
  final String username;
  final String profImage;
  final String country;
  final datePublished;
  final String global;
  final String title;
  final String body;
  final String videoUrl;
  final String postUrl;
  final int selected;
  final plus;
  final neutral;
  final minus;
  final int score;

  const Post({
    required this.postId,
    required this.uid,
    required this.username,
    required this.profImage,
    required this.country,
    required this.datePublished,
    required this.global,
    required this.title,
    required this.body,
    required this.videoUrl,
    required this.postUrl,
    required this.selected,
    required this.plus,
    required this.neutral,
    required this.minus,
    required this.score,
  });

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "uid": uid,
        "username": username,
        "profImage": profImage,
        "country": country,
        "datePublished": datePublished,
        "global": global,
        "title": title,
        "body": body,
        "videoUrl": videoUrl,
        "postUrl": postUrl,
        "selected": selected,
        "plus": plus,
        "neutral": neutral,
        "minus": minus,
        "score": score,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      postId: snapshot['postId'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      profImage: snapshot['profImage'],
      country: snapshot['country'],
      datePublished: snapshot['datePublished'],
      global: snapshot['global'],
      title: snapshot['title'],
      body: snapshot['body'],
      videoUrl: snapshot['videoUrl'],
      postUrl: snapshot['postUrl'],
      selected: snapshot['selected'],
      plus: snapshot['plus'],
      neutral: snapshot['neutral'],
      minus: snapshot['minus'],
      score: snapshot['score'],
    );
  }
}
