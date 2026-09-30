import 'package:flutter/material.dart';

/// Cores semânticas usadas para indicar o estado de sincronização.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  final Color synced;
  final Color syncedContainer;
  final Color pending;
  final Color pendingContainer;
  final Color offline;
  final Color offlineContainer;
  final Color danger;
  final Color dangerContainer;

  const StatusColors({
    required this.synced,
    required this.syncedContainer,
    required this.pending,
    required this.pendingContainer,
    required this.offline,
    required this.offlineContainer,
    required this.danger,
    required this.dangerContainer,
  });

  static const light = StatusColors(
    synced: Color(0xFF059669),
    syncedContainer: Color(0xFFD1FAE5),
    pending: Color(0xFFD97706),
    pendingContainer: Color(0xFFFEF3C7),
    offline: Color(0xFF64748B),
    offlineContainer: Color(0xFFE2E8F0),
    danger: Color(0xFFDC2626),
    dangerContainer: Color(0xFFFEE2E2),
  );

  static const dark = StatusColors(
    synced: Color(0xFF34D399),
    syncedContainer: Color(0xFF0F2F25),
    pending: Color(0xFFFBBF24),
    pendingContainer: Color(0xFF33260B),
    offline: Color(0xFF94A3B8),
    offlineContainer: Color(0xFF1E2430),
    danger: Color(0xFFF87171),
    dangerContainer: Color(0xFF3A1414),
  );

  @override
  StatusColors copyWith({
    Color? synced,
    Color? syncedContainer,
    Color? pending,
    Color? pendingContainer,
    Color? offline,
    Color? offlineContainer,
    Color? danger,
    Color? dangerContainer,
  }) {
    return StatusColors(
      synced: synced ?? this.synced,
      syncedContainer: syncedContainer ?? this.syncedContainer,
      pending: pending ?? this.pending,
      pendingContainer: pendingContainer ?? this.pendingContainer,
      offline: offline ?? this.offline,
      offlineContainer: offlineContainer ?? this.offlineContainer,
      danger: danger ?? this.danger,
      dangerContainer: dangerContainer ?? this.dangerContainer,
    );
  }

  @override
  StatusColors lerp(ThemeExtension<StatusColors>? other, double t) {
    if (other is! StatusColors) return this;
    return StatusColors(
      synced: Color.lerp(synced, other.synced, t)!,
      syncedContainer: Color.lerp(syncedContainer, other.syncedContainer, t)!,
      pending: Color.lerp(pending, other.pending, t)!,
      pendingContainer: Color.lerp(pendingContainer, other.pendingContainer, t)!,
      offline: Color.lerp(offline, other.offline, t)!,
      offlineContainer: Color.lerp(offlineContainer, other.offlineContainer, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerContainer: Color.lerp(dangerContainer, other.dangerContainer, t)!,
    );
  }
}

extension StatusColorsContext on BuildContext {
  StatusColors get statusColors => Theme.of(this).extension<StatusColors>()!;
}
