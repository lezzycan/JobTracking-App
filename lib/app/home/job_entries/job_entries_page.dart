import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../jobs/job_form.dart';
import '../models/entry.dart';
import '../jobs/list_items_builder.dart';

import '../../../common_widgets/platform_exception_alert_dialog.dart';
import '../../../services/database.dart';
import '../models/jobs.dart';
import 'entry_list_item.dart';
import 'entry_page.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({required this.database, required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job?>(
        stream: database.jobStream(jobId: job.id),
        builder: (BuildContext context, snapshot) {
          final job = snapshot.data ;
          final jobName = job?.name;

          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(jobName!),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                    onPressed: () => EntryPage.show(
                          context: context,
                          database: database,
                          job: job as Job,
                        ),
                    icon: const Icon(Icons.add)),
                TextButton(
                  child: const Text(
                    'Edit',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  onPressed: () =>
                      JobFormPage.show(context, database: database, job: job),
                ),
              ],
            ),
            body: _buildContent(context, job!),
          );
        });
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
