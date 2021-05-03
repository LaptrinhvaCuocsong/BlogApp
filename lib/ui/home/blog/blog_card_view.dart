import 'package:blog_app/model/MyBlog.dart';
import 'package:blog_app/utils/date_utils.dart' as date_utils;
import 'package:flutter/material.dart';
import 'package:blog_app/extensions/IntExtension.dart';

class BlogCardView extends StatelessWidget {
  final MyBlog _myBlog;
  BuildContext _context;

  BlogCardView(this._myBlog);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _context = context;
    return _buildCard();
  }

  Widget _buildCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildCardHeader(),
            SizedBox(height: 16),
            _buildCardImage(),
            SizedBox(height: 16),
            _buildCardFooter()
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Row(
      children: <Widget>[
        Text(
          date_utils.DateUtils.dateToString(
              _myBlog.createTime, false, date_utils.MyDateFormat.format4),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        Text(
          date_utils.DateUtils.dateToString(
              _myBlog.createTime, false, date_utils.MyDateFormat.format5),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget _buildCardImage() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        height: 260.scaleH(_context),
        decoration: BoxDecoration(color: Colors.red),
      ),
    );
  }

  Widget _buildCardFooter() {
    return Text(
      _myBlog.description,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      maxLines: 3,
    );
  }
}
