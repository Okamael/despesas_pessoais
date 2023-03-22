import 'dart:math';

import 'package:despesas_pessoais/components/chart_widget.dart';
import 'package:despesas_pessoais/components/transaction_form.dart';
import 'package:despesas_pessoais/components/transaction_list.dart';
import 'package:despesas_pessoais/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main(List<String> args) {
  runApp(ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final ThemeData tema = ThemeData();
    return MaterialApp(
        home: MyHomePage(),
        theme: tema.copyWith(
            colorScheme: tema.colorScheme
                .copyWith(primary: Colors.purple, secondary: Colors.amber),
            textTheme: tema.textTheme.copyWith(
                headline6: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold))));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;
  final List<Transaction> _transactions = [
    Transaction(
        id: 't0',
        title: 'Conta Antiga',
        value: 400,
        date: DateTime.now().subtract(Duration(days: 33))),
    Transaction(
        id: 't1',
        title: 'Novo Tenis',
        value: 310.76,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(
        id: 't2',
        title: 'Conta Luz',
        value: 389.76,
        date: DateTime.now().subtract(Duration(days: 4))),
    Transaction(
        id: 't3',
        title: 'Cartão de Crédito',
        value: 100211.30,
        date: DateTime.now().subtract(Duration(days: 4))),
    Transaction(
        id: 't4',
        title: 'Lanche',
        value: 11.30,
        date: DateTime.now().subtract(Duration(days: 4))),
    Transaction(
        id: 't6',
        title: 'Lanche bauduco',
        value: 11.30,
        date: DateTime.now().subtract(Duration(days: 4))),
    Transaction(
        id: 't7',
        title: 'lary',
        value: 11.30,
        date: DateTime.now().subtract(Duration(days: 4)))
  ];
  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(
      {required String title, required double value, required DateTime date}) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );
    setState(() {
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop();
  }

  _opentransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionFormWidget(onSubmit: (title, value, date) {
            _addTransaction(title: title, value: value, date: date);
          });
        });
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandScape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: const Text(
        'Despesas Pessoais',
      ),
      actions: [
        IconButton(
            onPressed: () => _opentransactionFormModal(context),
            icon: Icon(Icons.add))
      ],
    );
    final avaliableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Despesas Pessoais',
        ),
        actions: [
          if (isLandScape)
            IconButton(
                onPressed: () {
                  setState(() {
                    _showChart = !_showChart;
                  });
                },
                icon: Icon(_showChart ? Icons.list : Icons.show_chart)),
          IconButton(
              onPressed: () => _opentransactionFormModal(context),
              icon: Icon(Icons.add)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (isLandScape)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text('Exibir Grafico'),
            //       Switch(
            //         value: _showChart,
            //         onChanged: (value) {
            //           setState(() {
            //             print(_showChart);
            //             print(value);
            //             _showChart = value;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            if (_showChart || !isLandScape)
              Container(
                  height: avaliableHeight * (isLandScape ? 0.8 : 0.3),
                  child: ChartWidget(recentTransaction: _recentTransactions)),
            if (!_showChart || !isLandScape)
              Container(
                height: avaliableHeight * (isLandScape ? 1 : 0.7),
                child: TransactionListWidget(
                    transactions: _transactions, onRemove: _removeTransaction),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _opentransactionFormModal(context),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
