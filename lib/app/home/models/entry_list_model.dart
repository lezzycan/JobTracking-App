import 'package:flutter/material.dart';

import '../job_entries/format.dart';
import 'jobs.dart';
import 'entry.dart';

class EntryListModel{
  EntryListModel({ required this.context,
    required this.job ,
    required this.entry});
  final Job job;
  final Entry entry;
  final BuildContext context;

  String get dayOfWeek => Format.dayOfWeek(entry.start);
  String get startDate => Format.date(entry.start);
  String  get startTime => TimeOfDay.fromDateTime(entry.start).format(context);
  String  get endTime => TimeOfDay.fromDateTime(entry.end).format(context);
  String get durationFormatted => Format.hours(entry.durationInHours);

 num get pay => job.ratePerHour! * entry.durationInHours;
  String get payFormatted => Format.currency(pay.toDouble());
}

