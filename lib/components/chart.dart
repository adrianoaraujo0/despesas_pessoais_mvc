
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../components/chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({required this.recentTransaction ,super.key});

  final List<Transaction> recentTransaction;

  List<Map<String, dynamic>> get groupedTransactions{
    return List.generate(
      7,(index){
        final weekDay = DateTime.now().subtract(Duration(days: index));

    double totalSum = 0.0;

    for(var i = 0; i< recentTransaction.length; i++){
      bool sameDay = recentTransaction[i].date.day == weekDay.day;
      bool sameMonth = recentTransaction[i].date.month == weekDay.month;
      bool sameYear = recentTransaction[i].date.year == weekDay.year;

      if(sameDay && sameMonth && sameYear){
        totalSum += recentTransaction[i].value;
      }
    }

    return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum
      };
     }
   ).reversed.toList();
  }

  double get weekTotalValue {
    return groupedTransactions.fold(
      0.0, (sum, tr) {
      return sum + tr['value'];
    });
  }


  @override
  Widget build(BuildContext context) { 
    print("CHART");
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map(((tr) {
              return Flexible(
                fit: FlexFit.loose,
                child: ChartBar(
                  label: tr['day'],
                  value: tr['value'],
                  percentage: weekTotalValue == 0 ? 0 : tr['value'] / weekTotalValue),
              );
          })).toList(),
        ),
      ),
    );
  }
}