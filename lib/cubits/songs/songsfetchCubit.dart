import 'package:firebase/cubits/songs/songsfetchStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SongsFetchCubit extends Cubit<SongsFetchState> {
  SongsFetchCubit() : super(LoadingState());

  
}
