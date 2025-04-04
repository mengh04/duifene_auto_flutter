import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/models/duifene_session.dart';

final duifeneSessionProvider = Provider<DuifeneSession>((ref) {
  final session = DuifeneSession();
  ref.onDispose(() => session.dispose());
  return session;
});