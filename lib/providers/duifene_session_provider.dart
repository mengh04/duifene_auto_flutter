import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/duifene_sign.dart';

final duifeneSessionProvider = Provider<DuifeneSession>((ref) {
  final session = DuifeneSession();
  ref.onDispose(() => session.dispose());
  return session;
});