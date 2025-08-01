import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';

import '../../../core/ui/base_state_cubit.dart';
import 'cubit/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends BaseStateCubit<SplashPage, SplashCubit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        bloc: context.get(),
        listener: (context, state) {
          if (state is SplashSuccess) {
            Navigator.of(context).pushReplacementNamed('/home/initial/start');
          } else if (state is SplashError) {
            // Show an error message
          }
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
