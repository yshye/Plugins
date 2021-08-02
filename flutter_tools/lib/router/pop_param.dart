class PopParam {
  /// 是否成功
  bool _success;

  bool get success => _success;

  /// 携带的数据
  dynamic _data;

  dynamic get data => _data;

  PopParam(this._success, this._data);
}
