import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../util/url_util.dart';
import '../../datetime/timer_util.dart';
import '../base/mixin_state.dart';

/// 启动图封装
class LaunchPage extends StatefulWidget {
  /// 首次显示图片集合
  final List<String> firstImgUrl;

  /// 是否是首次显示
  final bool showFirst;

  /// 启动图片
  final String launchBackgroundPath;

  /// 结束后回调
  final ValueChanged<BuildContext> endCallback;

  /// 进入按钮名称
  final String inLabel;

  /// 动画时间，秒
  final int splashTimes;

  const LaunchPage({
    Key key,
    this.firstImgUrl,
    this.showFirst = true,
    this.launchBackgroundPath,
    this.endCallback,
    this.inLabel = '立即使用',
    this.splashTimes = 3,
  })  : assert(showFirst != null),
        assert(launchBackgroundPath != null),
        super(key: key);

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> with StateMixin<LaunchPage> {
  TimerUtil _timerUtil;
  int _status = 0;
  int _index = 0;
  int _mTotalTime = 1000;

  @override
  void initState() {
    _initSplash();
    super.initState();
  }

  @override
  void afterBuild(Duration timestamp) {
    if (widget.firstImgUrl != null && widget.firstImgUrl.length > 0) {
      widget.firstImgUrl.forEach((url) {
        precacheImage(
            UrlUtil.isUrl(url) ? NetworkImage(url) : AssetImage(url), context);
      });
    }
  }

  void _initSplash() {
    _status = 1;
    _mTotalTime = widget.splashTimes * 1000;
    _timerUtil = TimerUtil(mTotalTime: _mTotalTime, mInterval: _mTotalTime);
    _timerUtil.setOnTimerTickCallback((int tick) {
//      double _tick = tick / 1000.0;
      if (tick <= 0) {
        _endSplash();
      }
    });
    _timerUtil.startCountDown();
  }

  void _endSplash() {
    if (widget.showFirst &&
        widget.firstImgUrl != null &&
        widget.firstImgUrl.length > 0) {
      _status = 0;
      setState(() {});
    } else {
      _endFirst();
    }
  }

  void _endFirst() {
    if (widget.endCallback != null) {
      widget.endCallback(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Color color = Theme.of(context).primaryColor;

    return Material(
      child: _status == 1
          ? AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: _mTotalTime),
              child: UrlUtil.isUrl(widget.launchBackgroundPath)
                  ? Image.network(widget.launchBackgroundPath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: double.infinity)
                  : Image.asset(widget.launchBackgroundPath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: double.infinity),
            )
          : Stack(
              children: <Widget>[
                Swiper(
                  itemCount: widget.firstImgUrl.length,
                  loop: false,
                  index: _index,
                  itemBuilder: (_, index) {
                    String url = widget.firstImgUrl[index];
                    return UrlUtil.isUrl(url)
                        ? Image.network(url,
                            width: double.infinity,
                            fit: BoxFit.fill,
                            height: double.infinity)
                        : Image.asset(url,
                            width: double.infinity,
                            fit: BoxFit.fill,
                            height: double.infinity);
                  },
                  onIndexChanged: (index) {
                    _index = index;
                    setState(() {});
                  },
                  pagination: _index == widget.firstImgUrl.length - 1
                      ? null
                      : SwiperPagination(),
                ),
                Positioned(
                  bottom: 5,
                  child: Container(
                    width: width,
                    alignment: Alignment.bottomCenter,
                    color: Colors.transparent,
                    child: _index == widget.firstImgUrl.length - 1
                        ? MaterialButton(
                            textColor: color,
                            child: Text(widget.inLabel),
                            onPressed: _endFirst,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: color, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(19)),
                            ),
                          )
                        : Container(),
                  ),
                )
              ],
            ),
    );
  }
}
