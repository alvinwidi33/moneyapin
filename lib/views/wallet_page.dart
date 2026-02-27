import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:moneyapin/controllers/auth_controller.dart';
import 'package:moneyapin/controllers/transaction_controller.dart';
import 'package:moneyapin/theme/app_theme.dart';
import 'package:moneyapin/theme/navbar.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final int _currentIndex = 2;
  AuthController get authController => Get.find<AuthController>();
  final TransactionController txController = Get.find<TransactionController>();
  String formatCurrency(double value) {
      final hasDecimal = value % 1 != 0;

      final formatter = NumberFormat.currency(
        locale: 'en_US',
        symbol: '\$',
        decimalDigits: hasDecimal ? 2 : 0,
      );

      return formatter.format(value);
    }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.92;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('My Wallet', style: AppTheme.headingStyle),
                      Icon(Icons.add, color: AppTheme.primary),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    final balance = authController.user.value?.balance ?? 0;
                    return _BalanceCard(
                      balance: formatCurrency(balance),
                    );
                  }),
                  const SizedBox(height: 24),

                  Text('My Accounts', style: AppTheme.headingStyle),
                  const SizedBox(height: 12),

                  _AccountCard(
                    icon: Icons.account_balance,
                    iconColor: const Color(0xFF3575DC),
                    title: 'Checking Account',
                    subtitle: '**** 1234',
                    balance: formatCurrency(5830.10),
                  ),
                  const SizedBox(height: 10),
                  _AccountCard(
                    icon: Icons.savings,
                    iconColor: AppTheme.primary,
                    title: 'Savings Account',
                    subtitle: '**** 5678',
                    balance: formatCurrency(6500.40),
                  ),
                  const SizedBox(height: 10),
                  _AccountCard(
                    icon: Icons.credit_card,
                    iconColor: const Color(0xFFCC3C3F),
                    title: 'Credit Card',
                    subtitle: '**** 9012',
                    balance: formatCurrency(150.00),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Transactions', style: AppTheme.headingStyle),
                      Text(
                        'View All',
                        style: AppTheme.bodyStyle.copyWith(color: AppTheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final recentTransactions =
                        txController.transactions.take(3).toList();

                    if (recentTransactions.isEmpty) {
                      return const Text("No recent transactions");
                    }

                    return Column(
                      children: recentTransactions.map((tx) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _TransactionCard(
                            icon: Icons.receipt_long,
                            iconColor: tx.type == 'income' ? AppTheme.primary : Color(0xFFCC3C3F),
                            title: tx.title,
                            time: DateFormat('MMM dd, HH:mm').format(tx.date),
                            amount: formatCurrency(tx.amount),
                            isExpense: false, 
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: NavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == _currentIndex) return;
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/reports');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/wallets');
            } else if (index == 3) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
          },
          onAddTap: () {
            Navigator.pushNamed(context, '/add');
          },
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});
  final String balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: AppTheme.bodyStyle.copyWith(color: Colors.white70),
              ),
              const Icon(Icons.more_horiz, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            balance,
            style: AppTheme.headingStyle.copyWith(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.balance,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTheme.labelStyle),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTheme.bodyStyle),
                  ],
                ),
              ),
              // Balance
              Text(balance, style: AppTheme.labelStyle),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: Text(
              'View Details',
              style: AppTheme.bodyStyle.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.time,
    required this.amount,
    required this.isExpense,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String time;
  final String amount;
  final bool isExpense;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.labelStyle),
                const SizedBox(height: 2),
                Text(time, style: AppTheme.bodyStyle),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTheme.labelStyle
          ),
          
        ],
      ),
    );
  }
}