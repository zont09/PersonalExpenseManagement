import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Saving.dart';
import 'package:personal_expense_management/Model/SavingDetail.dart';
import 'package:personal_expense_management/bloc/saving_detail_bloc/saving_detail_event.dart';
import 'package:personal_expense_management/bloc/saving_detail_bloc/saving_detail_state.dart';

class SavingDetailBloc extends Bloc<SavingDetailEvent, SavingDetailState> {
  final List<SavingDetail> savingDets;

  SavingDetailBloc(this.savingDets) : super(SavingDetailUpdateState(savingDets)) {
    on<AddSavingDetailEvent>((event, emit) async {
      int id = await DatabaseHelper().insertSavingDetail(event.newSavDet);
      SavingDetail newSavDe = SavingDetail(id: id, id_saving: event.newSavDet.id_saving, amount: event.newSavDet.amount, wallet: event.newSavDet.wallet, note: event.newSavDet.note);
      savingDets.add(newSavDe);
      emit(SavingDetailUpdateState(List.from(savingDets)));
    });

    on<UpdateSavingDetailEvent>((event, emit) async {
      final index =
      savingDets.indexWhere((wallet) => wallet.id == event.updSavDet.id);
      if (index != -1) {
        savingDets[index] = event.updSavDet;
        await DatabaseHelper().updateSavingDetail(event.updSavDet);
        emit(SavingDetailUpdateState(List.from(savingDets)));
      } else {
        throw Exception('Saving not found');
      }
    });

    on<RemoveSavingDetailEvent>((event, emit) async {
      savingDets.removeWhere((wallet) => wallet.id == event.remSavDet.id);
      await DatabaseHelper().deleteSavingDetail(event.remSavDet.id!);
      emit(SavingDetailUpdateState(List.from(savingDets)));
    });
  }
}
