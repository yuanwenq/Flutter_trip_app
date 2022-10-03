import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/util/navigator_util.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/webview.dart';

const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

const URL =
    'https://m.ctrip.com/restapi/h5api/globalsearch/search?source=mobileweb&action=mobileweb&keyword=';

class SearchPage extends StatefulWidget {
  final bool? hideLeft;
  final String searchUrl;
  final String? keyword;
  final String? hint;

  const SearchPage(
      {Key? key, this.hideLeft, this.searchUrl = URL, this.keyword, this.hint})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel? searchModel;
  String? keyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _appBar(),
          if ((searchModel?.data?.length ?? 0) > 0)
            MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: Expanded(
                    flex: 1,
                    child: ListView.builder(
                        itemCount: searchModel?.data?.length ?? 0,
                        itemBuilder: (BuildContext context, int position) {
                          return _item(position);
                          // if (searchModel!.data!.length! > 0) {}
                        })))
          else
            Container(
              margin: EdgeInsets.only(top: 100),
              child: Text('暂无搜索数据'),
            )
        ],
      ),
    );
  }

  _onTextChange(String text) {
    keyword = text;
    if (text.isEmpty) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    String url = widget.searchUrl + text;
    SearchDao.fetch(url, text).then((SearchModel model) {
      if (model.keyword == keyword) {
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((e) {
      throw e;
    });
  }

  _appBar() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              speakClik: () {},
              onChanged: _onTextChange,
            ),
          ),
        )
      ],
    );
  }

  _item(int position) {
    if (searchModel == null || searchModel?.data == null) return null;
    SearchItem item = searchModel!.data![position];
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            HiWebView(
              url: item.url,
              title: '详情',
            ));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Image(
                height: 26,
                width: 26,
                image: AssetImage(_typeImage(item.type)),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 300,
                  // color: Colors.red,
                  child: _title(item),
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 5),
                  child: _subTitle(item),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _typeImage(String? type) {
    if (type == null) return 'images/type_travelgroup.png';
    String path = 'travelgroup';
    for (final val in TYPES) {
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'images/type_$path.png';
  }

  _title(SearchItem item) {
    if (item == null) {
      return null;
    }
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word, searchModel?.keyword ?? ''));
    spans.add(TextSpan(
        text: ' ${item.districtname ?? ''} ${item.zonnename ?? ''}',
        style: TextStyle(fontSize: 16, color: Colors.grey)));

    return RichText(text: TextSpan(children: spans));
  }

  _subTitle(SearchItem item) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: item.price ?? '',
          style: TextStyle(fontSize: 16, color: Colors.orange)),
      TextSpan(
          text: ' ' + (item.star ?? ''),
          style: TextStyle(fontSize: 12, color: Colors.grey)),
    ]));
  }

  _keywordTextSpans(String? word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.isEmpty) return spans;
    List<String> arr = word.split(keyword);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);

    for (int i = 0; i < arr.length; i++) {
      if ((i + 1) % 2 == 0) {
        spans.add(TextSpan(text: keyword, style: keywordStyle));
      }
      String val = arr[i];
      if (val != null && val.isNotEmpty) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }

    return spans;
  }
}
