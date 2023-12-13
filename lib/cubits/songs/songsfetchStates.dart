abstract class SongsFetchState {}

class LoadingState extends SongsFetchState {}

class SuccessState extends SongsFetchState {}

class FailedState extends SongsFetchState {
// String errormessage;
}
