import 'dart:async';

import 'package:blog_app/blocs/home/blog/blog_bloc.dart';
import 'package:blog_app/model/MyBlog.dart';
import 'package:blog_app/ui/home/blog/blog_card_view.dart';
import 'package:blog_app/ui/home/blog/upload/upload_page.dart';
import 'package:blog_app/utils/strings.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  ScrollController _scrollController = ScrollController();
  BlogBloc _blogBloc = BlogBloc();
  StreamSubscription _blogListener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _blogBloc.fetchBlogs();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        _blogBloc.loadMore();
      }
    });

    _blogListener = _blogBloc.listenBlogChanges();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _blogListener.cancel();
    _scrollController.dispose();
    _blogBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.blogPageTitle),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.upload_rounded),
        onPressed: () => _onPressedCreateBlogBtn(),
      ),
      body: Center(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder(
      stream: _blogBloc.blogStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(Strings.getBlogsIsFailed);
        }
        else if (snapshot.hasData) {
          List<MyBlog> blogs = snapshot.data;
          int numberOfRow = blogs.length + 1;

          return Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: RefreshIndicator(
              onRefresh: _blogBloc.refresh,
              child: ListView.separated(
                  controller: _scrollController,
                  itemCount: numberOfRow,
                  separatorBuilder: (context, row) => SizedBox(height: 16),
                  itemBuilder: (context, row) {
                    if (row < numberOfRow - 1) {
                      return BlogCardView(blogs[row]);
                    } else if (_blogBloc.hasMore) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: CircularProgressIndicator(),
                          )
                        ],
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Center(
                          child: Text(Strings.loadMoreIsFinished),
                        ),
                      );
                    }
                  }),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _onPressedCreateBlogBtn() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UploadPage()));
  }
}
