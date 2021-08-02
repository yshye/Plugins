import 'base_view_model.dart';

class BaseListProvider<M> extends BaseModel {
  final List<M> _list = [];

  List<M> get list => _list;

  bool _showEmptyWidget = false;

  bool get showEmptyWidget => _showEmptyWidget;

  bool isEnd(int index) => _list.length == index + 1;

  void add(M data) {
    _list.add(data);
    notifyListeners();
  }

  void addAll(List<M> data) {
    _list.addAll(data);
    notifyListeners();
  }

  void insert(int i, M data) {
    _list.insert(i, data);
    notifyListeners();
  }

  void insertAll(int i, List<M> data) {
    _list.insertAll(i, data);
    notifyListeners();
  }

  void remove(M data) {
    _list.remove(data);
    notifyListeners();
  }

  void removeAt(int i) {
    _list.removeAt(i);
    notifyListeners();
  }

  void clear() {
    _list.clear();
    notifyListeners();
  }

  @override
  void notifyListeners() {
    _showEmptyWidget = _list.length == 0;
    super.notifyListeners();
  }

  void refresh() => notifyListeners();
}
