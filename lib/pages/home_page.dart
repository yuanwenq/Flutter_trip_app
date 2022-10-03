import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';

import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/util/navigator_util.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/webview.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打开地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  double appBarAlpha = 0.0;
  List<CommonModel> localNavList = [];
  List<CommonModel> bannerList = [];
  List<CommonModel> subNavList = [];
  GridNavModel? gridNavModel;
  SalesBoxModel? salesBoxModel;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _handleRefresh();
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  Future<void> _handleRefresh() async {
    print('_handleRefresh');
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        bannerList = model.bannerList;
        subNavList = model.subNavList;
        gridNavModel = model.gridNav;
        salesBoxModel = model.salesBox;
        _loading = false;
      });
    } catch (e) {
      print('首页请求接口: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _loading,
        child: Stack(
          children: [
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: NotificationListener(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification &&
                        scrollNotification.depth == 0) {
                      // 滚动且是列表滚动的时候
                      _onScroll(scrollNotification.metrics.pixels);
                    }
                    //TODO: 为什么这里返回 true 会导致下拉刷新无效
                    return false;
                  },
                  child: _listView,
                ),
              ),
            ),
            _appBar
          ],
        ),
      ),
    );
  }

  Widget get _listView {
    return ListView(
      children: [
        _banner,
        Padding(
          padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(
            localNavList: localNavList,
          ),
        ),
        if (gridNavModel != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: GridNav(
              gridNavModel: gridNavModel!,
            ),
          ),
        if (subNavList != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SubNav(
              subNavList: subNavList,
            ),
          ),
        if (salesBoxModel != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SalesBox(
              salesBox: salesBoxModel!,
            ),
          ),
      ],
    );
  }

  Widget get _appBar {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80,
            decoration: BoxDecoration(
                color:
                    Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClik: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: const BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
        )
      ],
    );
  }

  Widget get _banner {
    return Container(
      height: 200,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        autoplayDelay: 2000,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              CommonModel model = bannerList[index];
              NavigatorUtil.push(
                  context,
                  HiWebView(
                    url: model.url,
                    title: model.title,
                    hideAppBar: model.hideAppBar,
                  ));
            },
            child: Image.network(
              bannerList[index].icon!,
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: const SwiperPagination(),
      ),
    );
  }

  void _jumpToSearch() {
    NavigatorUtil.push(
        context, const SearchPage(hint: SEARCH_BAR_DEFAULT_TEXT));
  }

  void _jumpToSpeak() {}
}
