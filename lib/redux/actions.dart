import '../models/details.dart';

class UpdatedDetailsAction {
  final Details updatedDetails;

  UpdatedDetailsAction(this.updatedDetails);
}

class AddDetailsAction {
  final Details addDetails;

  AddDetailsAction(this.addDetails);
}