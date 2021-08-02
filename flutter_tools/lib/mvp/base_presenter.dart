import 'mvps.dart';

abstract class BaseListPresenter<V extends IMvpListView, M>
    extends BasePresenter<V> implements IMvpListPresenter {
  V view;
  int pageIndex = 1;
  M jsonToModel(dynamic data);
}

class BasePresenter<V extends IMvpView> implements IMvpPresenter {
  V view;

  @override
  void deactivate() {}

  @override
  void didChangeDependencies() {}

  @override
  void didUpdateWidgets<V>(V oldWidget) {}

  @override
  void dispose() {}

  @override
  void initState() {}

  @override
  void afterBuild(Duration timestamp) {}
}
