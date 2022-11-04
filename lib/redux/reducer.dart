import 'package:flutter_application/models/details.dart';
import 'actions.dart';
import 'app_state.dart';

AppState updateDetailsReducer(AppState state, dynamic action){
  if(action is UpdatedDetailsAction) {
    // action.updatedDrink.selected = !action.updatedDrink.selected;
    state.details.map((details) => print(details));
    return AppState(
      details: state.details.map((details) => details.id == action.updatedDetails.id 
              ? action.updatedDetails 
              : details).toList()
    );
  } 
  else if(action is AddDetailsAction) {
    // action.updatedDrink.selected = !action.updatedDrink.selected;
    // state.details.map((details) => print(details));
    return AppState(
      details: [action.addDetails]
    );
  } else {
    return AppState();
  }
}