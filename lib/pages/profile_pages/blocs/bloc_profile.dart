import 'package:audio_stories/pages/profile_pages/blocs/bloc_profile_event.dart';
import 'package:audio_stories/pages/profile_pages/blocs/bloc_profile_state.dart';
import 'package:audio_stories/pages/profile_pages/models/profile_model.dart';
import 'package:audio_stories/pages/profile_pages/repository/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(ProfileInitial()) {
    on<ProfileOpenImagePicker>((event, emit) async {
      emit(ProfileLoading());
      final ProfileModel profileModel = await _profileRepository.pickImage();
      emit(
        ProfileChangeAvatar(avatar: profileModel.avatar!),
      );
    });
    on<ProfileSaveChanges>((event, emit) async {
      if (event.avatar != null) {
        _profileRepository.uploadImage(event.avatar!);
      }
      _profileRepository.saveName(event.name!);
      emit(
        ProfileInitial(),
      );
    });
  }
}
