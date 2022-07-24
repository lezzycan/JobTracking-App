import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/jobs.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({required this.job, required this.onPressed, Key? key}) : super(key: key);
  final Job job;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name!),
      trailing: const Icon(Icons.chevron_right),
      onTap: onPressed,
    );
  }
}
