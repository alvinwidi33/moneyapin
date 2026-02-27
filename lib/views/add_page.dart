import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyapin/theme/app_theme.dart';
import 'package:moneyapin/controllers/transaction_controller.dart';
import 'package:moneyapin/models/transactions.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TransactionController _txController = Get.find<TransactionController>();

  String _type = 'Income';

  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _notesController;
  late TextEditingController _tagsController;

  String? _selectedCategory;
  DateTime? _selectedDate;

  static const _incomeCategories  = ['Salary', 'Freelance', 'Investment', 'Gift', 'Other'];
  static const _expenseCategories = ['Food', 'Transport', 'Shopping', 'Bills', 'Health', 'Other'];

  List<String> get _categories =>
      _type == 'Income' ? _incomeCategories : _expenseCategories;

  Color get _accentColor =>
      _type == 'Income' ? AppTheme.primary : const Color(0xFFCC3C3F);

  @override
  void initState() {
    super.initState();
    _titleController  = TextEditingController();
    _amountController = TextEditingController();
    _dateController   = TextEditingController();
    _notesController  = TextEditingController();
    _tagsController   = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _switchType(String type) {
    if (_type == type) return;
    setState(() {
      _type = type;
      _selectedCategory = null;
    });
  }

  Future<void> _handleSave() async {
    if (_selectedCategory == null) {
      _showSnack('Please select a category.');
      return;
    }
    if (_titleController.text.trim().isEmpty) {
      _showSnack('Please enter a title.');
      return;
    }
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      _showSnack('Please enter a valid amount.');
      return;
    }
    if (_selectedDate == null) {
      _showSnack('Please select a date.');
      return;
    }

    final transaction = Transactions(
      id: '',                                      
      type: _type == 'Income' ? 'income' : 'expense',
      category: _selectedCategory!,
      title: _titleController.text.trim(),
      amount: amount,
      date: _selectedDate!,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      tags: _tagsController.text.trim().isEmpty
          ? []
          : _tagsController.text
              .trim()
              .split(',')
              .map((t) => t.trim())
              .where((t) => t.isNotEmpty)
              .toList(),
    );

    try {
      await _txController.addTransaction(transaction);
      Get.back();                                    
      Get.snackbar(
        'Success',
        '$_type saved successfully!',
        backgroundColor: _accentColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _showSnack('Failed to save transaction: $e');
    }
  }

  void _showSnack(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = _txController.isLoading.value;

      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.92,
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Get.back(),
                              ),
                            ),
                            Text('Add Transaction', style: AppTheme.headingStyle),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEFF1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              _ToggleTab(
                                label: 'Income',
                                isActive: _type == 'Income',
                                activeColor: AppTheme.primary,
                                onTap: () => _switchType('Income'),
                              ),
                              _ToggleTab(
                                label: 'Expense',
                                isActive: _type == 'Expense',
                                activeColor: const Color(0xFFCC3C3F),
                                onTap: () => _switchType('Expense'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        _SectionCard(
                          children: [
                            Text(
                              _type == 'Income' ? 'Income Details' : 'Expense Details',
                              style: AppTheme.buttonStyle.copyWith(color: Colors.black),
                            ),
                            const SizedBox(height: 16),

                            _FieldLabel('Category'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE4E6EA), width: 2),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCategory,
                                  isExpanded: true,
                                  hint: Text(
                                    'Select a Category',
                                    style: AppTheme.bodyStyle.copyWith(color: Colors.black54),
                                  ),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: _categories
                                      .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                                      .toList(),
                                  onChanged: (value) => setState(() => _selectedCategory = value),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            _FieldLabel('Title'),
                            const SizedBox(height: 8),
                            _InputField(
                              key: const ValueKey('title'),
                              controller: _titleController,
                              hint: _type == 'Income' ? 'e.g. Monthly Salary' : 'e.g. Groceries, Rent',
                            ),
                            const SizedBox(height: 16),

                            _FieldLabel('Amount'),
                            const SizedBox(height: 8),
                            _AmountField(
                              key: const ValueKey('amount'),
                              controller: _amountController,
                            ),
                            const SizedBox(height: 16),

                            _FieldLabel('Date'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE4E6EA), width: 2),
                              ),
                              child: TextField(
                                controller: _dateController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  hintText: 'Select Date',
                                  border: InputBorder.none,
                                  suffixIcon: Icon(Icons.calendar_today_rounded),
                                ),
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _selectedDate = picked;
                                      _dateController.text =
                                          '${picked.day}/${picked.month}/${picked.year}';
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        _SectionCard(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Additional Details ',
                                  style: AppTheme.buttonStyle.copyWith(color: Colors.black),
                                ),
                                Text('(Optional)', style: AppTheme.bodyStyle),
                              ],
                            ),
                            const SizedBox(height: 16),

                            _FieldLabel('Notes'),
                            const SizedBox(height: 8),
                            _InputField(
                              key: const ValueKey('notes'),
                              controller: _notesController,
                              hint: 'Add any specific details about this transaction...',
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),

                            _FieldLabel('Tags'),
                            const SizedBox(height: 8),
                            _InputField(
                              key: const ValueKey('tags'),
                              controller: _tagsController,
                              hint: 'e.g. urgent, monthly (pisahkan dengan koma)',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: isLoading ? null : _handleSave,
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'Save ${_type == "Income" ? "Income" : "Expense"}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),

              if (isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.15),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? activeColor : Colors.grey.shade500,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;

  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTheme.bodyStyle.copyWith(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  final TextEditingController controller;

  const _AmountField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E6EA), width: 2),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? prefixText;
  final Color? prefixColor;

  const _InputField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.prefixText,
    this.prefixColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E6EA), width: 2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          border: InputBorder.none,
          prefixText: prefixText,
          prefixStyle: TextStyle(
            color: prefixColor ?? Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}