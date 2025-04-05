import 'package:duifene_auto/pages/models/sign_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'duifene_session_provider.dart';


final signInfoProvider = StateNotifierProvider<SignInfoNotifier, NativeSignInfo>((ref) {
  return SignInfoNotifier(ref);
});

class SignInfoNotifier extends StateNotifier<NativeSignInfo> {
  final Ref ref;
  SignInfoNotifier(this.ref) : super(NativeSignInfo.empty());

  Future<void> getSignInfo(int index) async {
    final session = ref.read(duifeneSessionProvider);
    state = NativeSignInfo.from(await session.getSignInfo(index));
  }
}