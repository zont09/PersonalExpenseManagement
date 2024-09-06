abstract class WalletEvent {}

class SelectWalletEvent extends WalletEvent {
  final int walletId;

  SelectWalletEvent(this.walletId);
}
