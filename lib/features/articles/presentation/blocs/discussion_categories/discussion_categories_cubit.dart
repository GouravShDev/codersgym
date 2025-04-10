import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'discussion_categories_state.dart';

class DiscussionCategoriesCubit extends Cubit<DiscussionCategoriesState> {
  DiscussionCategoriesCubit() : super(DiscussionCategoriesInitial());
}
