import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/provider/expense_provider.dart';
import 'package:expense_tracker/static/expenseList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ExpanseProvider provider =
        Provider.of<ExpanseProvider>(context, listen: false);



    return Scaffold(
      backgroundColor: const Color(0xff1bcf9a),
      appBar: AppBar(
        backgroundColor: const Color(0xff1bcf9a),
        title: const Text(
          "Expense Tracker",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Consumer<ExpanseProvider>(builder: (context, value, child) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "My Monthly Budget",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹ ${NumberFormat.decimalPattern().format(value.budget)}",
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    addBudgetButton(context, value, provider)
                  ],
                ),
              ),
             Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                       value.todayMonthAllCheck? "This Month Total Expense ₹${value.total} \navailable Balance ₹${(NumberFormat.decimalPattern().format(value.budget! - value.total))}": " Total Expense ₹${value.total.toString()}",
                        style:  TextStyle(
                          fontSize: value.todayMonthAllCheck? 18:24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                 
              const SizedBox(
                height: 28,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24),
                          topLeft: Radius.circular(24)),
                      color: Colors.white),
                  child: Column(
                    children: [
                      expanseCategoryButton(provider),
                      const SizedBox(
                        height: 24,
                      ),
                      totalExpanse(value,),
                      expanseList(value)
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
      floatingActionButton:
          Consumer<ExpanseProvider>(builder: (context, value, child) {
        return FloatingActionButton(
          onPressed: () {
            bottomSheet(context, value);
          },
          child: const Icon(Icons.add),
        );
      }),
    );
  }

  Future<dynamic> bottomSheet(
    BuildContext context,
    ExpanseProvider value,
  ) {
    ExpanseProvider provider =
        Provider.of<ExpanseProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.height;

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0)
                .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Container(
                height: height / 1.5,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24)),
                    color: Colors.white),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close)),
                        const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Add Transaction",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                    TextField(
                      controller: value.expenseController,
                      decoration: const InputDecoration(
                          icon: Icon(
                        Icons.money_off,
                        color: Color(0xff1bcf9a),
                      )),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ListTile(
                      leading: const Icon(Icons.food_bank),
                      title: StatefulBuilder(
                        builder: (context, setState) => DropdownButton<String>(
                          value: value.dropdownValue,
                          alignment: Alignment.center,
                          elevation: 16,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          underline: Container(
                            height: 2,
                            color: const Color.fromARGB(255, 200, 200, 201),
                          ),
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? valueChnaged) {
                            setState(() {
                              provider.dropDownMenuList(valueChnaged);
                            });
                          },
                        ),
                      ),
                      trailing: const Icon(null),
                    ),
                    ListTile(
                      leading: IconButton(
                          onPressed: () {
                            provider.selectDate(context);
                          },
                          icon: const Icon(Icons.calendar_month)),
                      title: TextField(
                        controller: value.datePickerController,
                        onTap: () {
                          provider.selectDate(context);
                        },
                        readOnly: true,
                        decoration: const InputDecoration(hintText: "Add Date"),
                      ),
                      trailing: const Icon(null),
                    ),
                    ListTile(
                      leading: IconButton(
                          onPressed: () {}, icon: const Icon(Icons.notes)),
                      title: TextField(
                        controller: value.noteController,
                        decoration:
                            const InputDecoration(hintText: "Add Notes"),
                      ),
                      trailing: const Icon(null),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1bcf9a),
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            provider.addExpanse(context);
                            Navigator.pop(context);
                          },
                          child: const Text("Add Transaction")),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Expanded expanseList(ExpanseProvider value) {
    return Expanded(
      child: value.expanse.isEmpty
          ? const Center(
              child: Text(
                "Expanse Not Found",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
            padding: const EdgeInsets.only(bottom: 32),
              itemCount: value.expanse.length,
              itemBuilder: (context, index) {
                ExpenseModel expense = value.expanse[index];

                return ListTile(
                  leading: Image.asset(
                    "assets/${expense.expenseCategory}.png",
                    width: 35,
                    height: 35,
                  ),
                  title: Text(
                     expense.expenseCategory,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(value.todayMonthAllCheck?"${expense.note} \n ${expense.date}": expense.note),
                  trailing: Text(
                   "₹${expense.expense.toString()}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFfa8955)),
                  ),
                );
              }),
    );
  }

  Row totalExpanse(
      ExpanseProvider value, ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         const Text(
          "Expense Category",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          "₹ ${value.total}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Row expanseCategoryButton(ExpanseProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () {
              provider.getTodayExpanse();
            },
            child: const Text("Today")),
        ElevatedButton(
            onPressed: () {
              provider.getMonthExpanse();
            },
            child: const Text("month")),
        ElevatedButton(
            onPressed: () {
              provider.getAllExpanse();
            },
            child: const Text("All")),
      ],
    );
  }

  ElevatedButton addBudgetButton(
      BuildContext context, ExpanseProvider value, ExpanseProvider provider) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Add Bdget"),
                  content: TextField(
                    controller: value.addBudgetController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(hintText: "Add Budget"),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () {
                          provider.addBudget(context);
                          provider.getBudget();
                          Navigator.pop(context);
                        },
                        child: const Text("Add"))
                  ],
                );
              });
        },
        child: const Text("ADD BUDGET"));
  }
}
