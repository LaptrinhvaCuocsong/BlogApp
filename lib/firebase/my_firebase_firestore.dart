import 'dart:async';
import 'dart:math';

import 'package:blog_app/model/MyBlog.dart';
import 'package:blog_app/model/MyUser.dart';
import 'package:blog_app/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyFirebaseFirestore {
  static final instance = MyFirebaseFirestore._();

  final _firestoreApp = FirebaseFirestore.instance;

  MyFirebaseFirestore._();

  /*
  User Collection
    - Users (key: users)
      - [User] (docId = {userId})
   */
  CollectionReference get _users => _firestoreApp.collection('users');

  void createUser(
      MyUser user, Function onSuccess, Function(String) onCreateUserFailed) {
    if (user == null || user.id == null) {
      return;
    }
    _users.doc(user.id).set(user.toMap()).then((value) {
      onSuccess();
    }).catchError((Object e) => onCreateUserFailed(Strings.createUserIsFailed));
  }

  void getUser(String userId, Function(MyUser) onSuccess,
      Function(String) onGetUserFailed) {
    if (userId == null) {
      return;
    }
    _users.doc(userId).get().then((DocumentSnapshot snapshot) {
      Map<String, dynamic> map = snapshot.data();
      if (map != null) {
        MyUser user = MyUser.fromMap(map);
        onSuccess(user);
      }
    }).catchError((Object e) => onGetUserFailed(Strings.getUserIsFailed));
  }

  /*
  Blog collection
    - Blogs (key: blogs)
      - [Blog] (docId = generate auto)
   */
  CollectionReference get _blogs => _firestoreApp.collection('blogs');

  void createBlog(
      MyBlog blog, Function onSuccess, Function(String) onCreateBlogFailed) {
    if (blog == null) {
      return;
    }
    _blogs.add(blog.toMap()).then((value) {
      onSuccess();
    }).catchError((Object e) => onCreateBlogFailed(Strings.uploadBlogIsFailed));
  }

  Future getBlogs(
      DocumentSnapshot lastDocument,
      int limit,
      Function(List<MyBlog>, DocumentSnapshot) onSuccess,
      Function(String) onGetBlogsFailed) {
    Query newQuery;
    if (lastDocument == null) {
      newQuery = _blogs.orderBy('timestamp', descending: true);
    } else {
      newQuery = _blogs
          .orderBy('timestamp', descending: true)
          .startAfterDocument(lastDocument);
    }

    return newQuery.limit(limit).get().then((snapshot) {
      if (snapshot.docs == null) {
        return;
      }
      DocumentSnapshot lastDocument;
      List<MyBlog> blogs = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        if (data != null) {
          lastDocument = doc;
          blogs.add(MyBlog.fromMap(data));
        }
      }
      onSuccess(blogs, lastDocument);
    }).catchError((Object e) => onGetBlogsFailed(Strings.getBlogsIsFailed));
  }

  StreamSubscription listenBlogChanges(Function(List<MyBlog>) onSuccess, Function(String) onListenerFailed) {
    return _blogs.snapshots().listen((snapshot) {
      List<DocumentChange> docChanges = snapshot.docChanges;
      List<MyBlog> blogs = [];
      for (DocumentChange docChange in docChanges) {
        DocumentSnapshot doc = docChange.doc;
        if (doc == null) { return; }
        Map<String, dynamic> map = doc.data();
        if (map != null) {
          MyBlog blog = MyBlog.fromMap(map);
          blogs.add(blog);
        }
      }
      onSuccess(blogs);
    }, onError: (Object e) {
      onListenerFailed(Strings.listenBlogChangesFailed);
    });
  }
}
