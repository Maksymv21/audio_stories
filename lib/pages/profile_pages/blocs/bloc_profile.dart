import 'package:audio_stories/pages/profile_pages/blocs/bloc_profile_event.dart';
import 'package:audio_stories/pages/profile_pages/blocs/bloc_profile_state.dart';
import 'package:audio_stories/pages/profile_pages/repository/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(ProfileInitial()) {
    on<ProfileOpenImagePicker> ((event, emit) async {
      emit(ProfileLoading());
      await _profileRepository.uploadImage(event.image);
    });
  }
}
