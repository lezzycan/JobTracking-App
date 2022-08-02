import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker/app/home/models/jobs.dart';
import 'package:time_tracker/app/home/jobs/job_form.dart';
import 'package:time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import '../../../services/database.dart';

class JobsPage extends StatelessWidget {
  static const id = 'home_page';

  const JobsPage({Key? key}) : super(key: key);


  Future<void> _deleteContent(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Operation Failed', exception: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        backgroundColor: Colors.green[900],
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => JobFormPage.show(context,
              database: Provider.of<Database>(context, listen: false),),
              icon: const Icon(Icons.add)),

        ],
      ),
      body: _buildContent(context),

    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Job>(
            snapshot: snapshot,
            itemBuilder: (context, job) => Dismissible(
                  key: Key('job${job.id}'),
                  background: Container(
                    color: Colors.red,
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _deleteContent(context, job),
                  child: JobListTile(
                      job: job,
                      onPressed: () => JobEntriesPage.show(context, job)),
                ));
      },
    );
  }
}
