import 'package:flutter/material.dart';

typedef Widget BuildCheckChild<T>(BuildContext context, T t);

typedef int Compare<T>(T o1, T o2);

typedef bool Contains<T>(T model, String key);

typedef String ToString<T>(T model);
