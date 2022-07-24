import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/models/entry_list_model.dart';

import '../models/jobs.dart';
import '../models/entry.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem({
    required this.entry,
    required this.job,
    required this.onTap,

  });

  final Entry entry;
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
   EntryListModel _model = EntryListModel(job: job, entry: entry, context: context);
  // final  dayOfWeek = Format.dayOfWeek(entry.start);
  //    final  startDate = Format.date(entry.start);
  //    final startTime = TimeOfDay.fromDateTime(entry.start).format(context);
  //     final endTime = TimeOfDay.fromDateTime(entry.end).format(context);
  //     final durationFormatted = Format.hours(entry.durationInHours);
  //
  //   final  pay = job.ratePerHour! * entry.durationInHours;
  //   final  payFormatted = Format.currency(pay.toDouble());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(_model.dayOfWeek,
              style: const TextStyle(fontSize: 18.0, color: Colors.grey)),
          const SizedBox(width: 15.0),
          Text(_model.startDate, style: const TextStyle(fontSize: 18.0)),
          if (job.ratePerHour! > 0.0) ...<Widget>[
            Expanded(child: Container()),
            Text(
              _model.payFormatted,
              style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
            ),
          ],
        ]),
        Row(children: <Widget>[
          Text('${_model.startTime} - ${_model.endTime}', style: const TextStyle(fontSize: 16.0)),
          Expanded(child: Container()),
          Text(_model.durationFormatted, style: const TextStyle(fontSize: 16.0)),
        ]),
        if (entry.comment.isNotEmpty)
          Text(
            entry.comment,
            style: const TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    required this.key,
    required this.entry,
    required this.job,
    required this.onDismissed,
    required this.onTap,
  });

  final Key key;
  final Entry entry;
  final Job job;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      child: EntryListItem(
        entry: entry,
        job: job,
        onTap: onTap,
      ),
    );
  }
}
