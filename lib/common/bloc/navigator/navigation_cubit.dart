import 'package:bloc/bloc.dart';

enum NavigationTab { home, categories, products, orders }

class NavigationCubit extends Cubit<NavigationTab> {
  NavigationCubit() : super(NavigationTab.home);

  void changeTab(NavigationTab tab) => emit(tab);
}
