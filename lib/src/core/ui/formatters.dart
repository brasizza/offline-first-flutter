/// Tempo relativo curto em português ("agora", "há 3 min", "há 2 h", "há 4 dias").
String relativeTime(DateTime date, {DateTime? now}) {
  final diff = (now ?? DateTime.now()).difference(date);
  if (diff.inSeconds < 45) return 'agora';
  if (diff.inMinutes < 60) return 'há ${diff.inMinutes.clamp(1, 59)} min';
  if (diff.inHours < 24) return 'há ${diff.inHours} h';
  if (diff.inDays == 1) return 'ontem';
  return 'há ${diff.inDays} dias';
}

/// Plural simples: `plural(1, 'item', 'itens')` → "1 item".
String plural(int count, String singular, String pluralForm) => '$count ${count == 1 ? singular : pluralForm}';
