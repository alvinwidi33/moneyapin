import 'package:flutter/material.dart';
import 'package:moneyapin/theme/app_theme.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              child: Column(
                children: [
                  const SizedBox(height:12),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Text(
                        "Add Transaction",
                        style: AppTheme.headingStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(vertical:8),
                    decoration: BoxDecoration(
                      color:Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Income", style:AppTheme.bodyStyle),
                        Text("Expenses", style:AppTheme.bodyStyle),
                      ],
                    ),
                  ),
                  const SizedBox(height:20),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Transaction Details", style:AppTheme.buttonStyle.copyWith(color:Colors.black)),
                        const SizedBox(height: 16),
                        Text("Category", style: AppTheme.bodyStyle.copyWith(color:Colors.black)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE4E6EA),
                              width: 2,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              // value: selectedCategory,
                              isExpanded: true,
                              hint: Text("Select a Category", style:AppTheme.bodyStyle.copyWith(color:Colors.black)),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: ["Income", "Expense"]
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  // selectedCategory = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text("Title", style: AppTheme.bodyStyle.copyWith(color:Colors.black)),
                        const SizedBox(height: 8),
                        Form(controller: titleController, hint: "e.g.. Groceries, Rent"),
                        const SizedBox(height: 16),
                        Text("Amount", style: AppTheme.bodyStyle.copyWith(color:Colors.black)),
                        const SizedBox(height: 8),
                        Form(controller: amountController, hint: "0.00"),
                        const SizedBox(height: 16),
                        Text("Date", style: AppTheme.bodyStyle.copyWith(color:Colors.black)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE4E6EA),
                              width: 2,
                            ),
                          ),
                          child: TextField(
                            controller: dateController,
                            readOnly: true, 
                            decoration: InputDecoration(
                              hintText: "Select Date",
                              border: InputBorder.none,
                              suffixIcon: const Icon(Icons.calendar_today_rounded),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                dateController.text =
                                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height:20),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Transaction Details ", style:AppTheme.buttonStyle.copyWith(color:Colors.black)),
                            Text("(Opsional)", style: AppTheme.bodyStyle)
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text("Notes", style: AppTheme.bodyStyle.copyWith(color:Colors.black)),
                        const SizedBox(height: 8),
                        Form(controller: notesController, hint: "Add any specific details about this transaction..."),
                        const SizedBox(height: 16),
                        Text("Tags", style: AppTheme.bodyStyle.copyWith(color:Colors.black)),
                        const SizedBox(height: 8),
                        Form(controller: tagsController, hint: "e.g. #urgent, #monthly"),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height:20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    ),
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: (){},
                      child: Text("Save Transaction", style:TextStyle(color:Colors.black, fontWeight: FontWeight.bold))
                    ),
                  ),
                  const SizedBox(height:24),
                ],
              ),
            ),
          )
        )
      ),
    );
  }
}

class Form extends StatelessWidget {
  const Form({
    super.key,
    required this.controller,
    required this.hint
  });

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE4E6EA),
          width: 2,
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
          border: InputBorder.none, 
        ),
      )
    );
  }
}