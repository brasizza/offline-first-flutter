import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';

abstract class BaseStateCubit<T extends StatefulWidget, B extends BlocBase> extends State<T> {
  late final B blocBase;

  B get bloc => blocBase;

  @override
  void initState() {
    super.initState();
    blocBase = context.get<B>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) onReady();
    });
  }

  /// Método chamado após o frame inicial ser construído
  void onReady() {}

  @override
  void dispose() {
    super.dispose();
  }
}
