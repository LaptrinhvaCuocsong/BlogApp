import 'dart:async';
import 'package:blog_app/firebase/my_firebase_firestore.dart';
import 'package:blog_app/model/MyBlog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogBloc {
  StreamController _blogController = StreamController();
  bool _isLoading = false;
  List<MyBlog> _data = [];
  DocumentSnapshot _lastDocument;
  final _limit = 4;

  Stream get blogStream => _blogController.stream;
  bool hasMore = true;

  void dispose() {
    _blogController.close();
  }

  Future<void> refresh() {
    if (_isLoading) {
      return Future.value();
    }
    _lastDocument = null;
    hasMore = true;
    _data = [];
    return fetchBlogs();
  }

  Future<void> loadMore() {
    return fetchBlogs();
  }

  Future<void> fetchBlogs() {
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    return MyFirebaseFirestore.instance.getBlogs(_lastDocument, _limit,
        (blogs, lastDocument) {
      if (_lastDocument == null) {
        _data = blogs;
      } else {
        _data.addAll(blogs);
      }
      hasMore = blogs.length == _limit;
      _blogController.add(_data);
      _isLoading = false;
      _lastDocument = lastDocument;
    }, (msg) {
      print(msg);
      _blogController.addError(msg);
    });
  }

  StreamSubscription listenBlogChanges() {
    return MyFirebaseFirestore.instance.listenBlogChanges((blogs) {
      _data.insertAll(0, blogs);
      _blogController.add(_data);
    }, (msg) {
      print(msg);
    });
  }
}
