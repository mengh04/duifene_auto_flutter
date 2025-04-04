import 'package:duifene_auto/pages/models/sign_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'duifene_session_provider.dart';


final signInfoProvider = StateNotifierProvider<SignInfoNotifier, SignInfo>((ref) {
  return SignInfoNotifier(ref);
});

class SignInfoNotifier extends StateNotifier<SignInfo> {
  final Ref ref;
  SignInfoNotifier(this.ref) : super(SignInfo.empty());

  Future<void> getSignInfo(int index) async {
    final session = ref.read(duifeneSessionProvider);
    state = SignInfo.fromC(await session.getSignInfo(index));
  }
}