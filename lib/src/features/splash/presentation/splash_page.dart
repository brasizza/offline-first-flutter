import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';

import '../../../core/ui/base_state_cubit.dart';
import '../../../core/ui/theme/app_theme.dart';
import 'cubit/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends BaseStateCubit<SplashPage, SplashCubit> {
  static const _minDuration = Duration(milliseconds: 1400);
  final _stopwatch = Stopwatch()..start();
  bool _navigated = false;

  @override
  void onReady() {
    super.onReady();
    // O load() é disparado no onInit do módulo e pode terminar antes do listener existir.
    if (bloc.state is SplashSuccess) _goHome();
  }

  Future<void> _goHome() async {
    if (_navigated) return;
    _navigated = true;
    final remaining = _minDuration - _stopwatch.elapsed;
    if (remaining > Duration.zero) await Future.delayed(remaining);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home/initial/start');
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppTheme.brandGradient),
          child: Stack(
            children: [
              const Positioned(top: -80, right: -60, child: _Glow(size: 260)),
              const Positioned(bottom: -100, left: -80, child: _Glow(size: 300)),
              SafeArea(
                child: BlocConsumer<SplashCubit, SplashState>(
                  bloc: context.get(),
                  listener: (context, state) {
                    if (state is SplashSuccess) _goHome();
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          const Spacer(flex: 3),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.6, end: 1),
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) => Transform.scale(scale: value, child: child),
                            child: Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.18),
                                    blurRadius: 32,
                                    offset: const Offset(0, 16),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.cloud_sync_rounded, size: 48, color: AppTheme.seed),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'Offline First',
                            style: text.headlineMedium?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Seus dados, com ou sem internet',
                            textAlign: TextAlign.center,
                            style: text.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                          ),
                          const Spacer(flex: 2),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: state is SplashError ? _SplashErrorPanel(onContinue: _goHome, onRetry: () => bloc.load()) : const _SplashLoading(),
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashLoading extends StatelessWidget {
  const _SplashLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('loading'),
      children: [
        SizedBox(
          width: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              minHeight: 4,
              color: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Preparando dados locais…',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.75)),
        ),
      ],
    );
  }
}

class _SplashErrorPanel extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onRetry;

  const _SplashErrorPanel({required this.onContinue, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Container(
      key: const ValueKey('error'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 28),
          const SizedBox(height: 10),
          Text('Não foi possível falar com a nuvem', style: text.titleSmall?.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text(
            'Sem problemas: você pode continuar usando os dados salvos no dispositivo.',
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onRetry,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Tentar de novo'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: onContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.seed,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Continuar offline'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  const _Glow({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Colors.white.withValues(alpha: 0.18), Colors.white.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
