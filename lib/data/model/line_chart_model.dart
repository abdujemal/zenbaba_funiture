// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LineChartModel extends Equatable {
  final String title;
  final double leftVal;
  final double rightVal;
  const LineChartModel({
    required this.title,
    required this.leftVal,
    required this.rightVal,
  });

  @override
  List<Object?> get props => [title, leftVal, rightVal];
}
