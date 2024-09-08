abstract class WalletSelectEvent {}

class SelectedWalletEvent extends WalletSelectEvent {
  final int walletId;

  SelectedWalletEvent(this.walletId);
}