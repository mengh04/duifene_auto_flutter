import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/duifene_session.dart';

final duifeneSessionProvider = Provider<DuifeneSession>((ref) {
  final session = DuifeneSession();
  ref.onDispose(() => session.dispose());
  return session;
});