import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/models/jobs.dart';
import 'package:time_tracker/common_widgets/platform_exception_alert_dialog.dart';

import '../../../common_widgets/platform_alert_dialog.dart';
import '../../../services/database.dart';

class JobFormPage extends StatefulWidget {
  const JobFormPage({required this.database, this.job, Key? key}) : super(key: key);

  final Database database;
 final Job? job;
  static Future<void> show(BuildContext context, { Database? database, Job? job}  ) async {
    //final database = Provider.of<Database>(context, listen: false);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JobFormPage(
                  database: database!,
                  job: job,
                ),
            fullscreenDialog: true));
  }

  @override
  State<JobFormPage> createState() => _JobFormPageState();
}

class _JobFormPageState extends State<JobFormPage> {
  String? _name;
  int? _ratePerHour;
  bool isLoading = false;

  final _nameController = TextEditingController();
  final _ratePerHourController = TextEditingController();
  String get __name => _nameController.text;
  String get __ratePerHour => _ratePerHourController.text;

  final _nameFocusNode = FocusNode();
  final _ratePerHourFocusNode = FocusNode();

  @override
  void initState(){
    super.initState();
    if(widget.job != null){
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  void _editingComplete() {
    final newFocus = __name.isNotEmpty ? _ratePerHourFocusNode : _nameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  final _formKey = GlobalKey<FormState>();
  bool validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  String documentIDCurrentDate() => DateTime.now().toIso8601String();
  Future<void> _submit() async {
    setState(() {
      isLoading = true;
    });
    if (validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if(widget.job !=null){
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(context,
              title: 'Name already used',
              content: 'Please choose a different name',
              defaultActionText: 'OK');
        } else {
          final id = widget.job?.id ?? documentIDCurrentDate();
          await widget.database
              .setJob(Job(name: _name, ratePerHour: _ratePerHour, id: id));
          Navigator.pop (context, true);
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: 'Operation failed', exception: e);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool submitEnabled =
        __name.isNotEmpty && __ratePerHour.isNotEmpty && !isLoading;
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.job != null ? 'Edit Job' : 'New Job'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          TextButton(
            onPressed: submitEnabled ? null : _submit,
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Card(
          child:
              Padding(padding: const EdgeInsets.all(25.0), child: _buildForm()),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ));
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name,
        enabled: !isLoading,
        onEditingComplete: _editingComplete,
        focusNode: _nameFocusNode,
       // controller: _nameController,
        onSaved: (value) => _name = value!,
        validator: (value) => value!.isNotEmpty ? null : 'name can\'t be empty',
        decoration: const InputDecoration(
          labelText: 'Job Name',
        ),
      ),
      TextFormField(
       initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        enabled: !isLoading,
        focusNode: _ratePerHourFocusNode,
        onSaved: (value) => _ratePerHour = (int.tryParse(value!) ?? 0),
        validator: (value) =>
            value!.isNotEmpty ? null : 'ratePerHour can\'t be empty',
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        decoration: const InputDecoration(labelText: 'RatePerHour'),
      ),
    ];
  }
}
