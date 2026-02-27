import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:moneyapin/controllers/auth_controller.dart';
import 'package:moneyapin/controllers/transaction_controller.dart';
import 'package:moneyapin/theme/app_theme.dart';
import 'package:moneyapin/theme/navbar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final int _currentIndex = 0;
    final _fmt = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  AuthController get authController => Get.find<AuthController>();  
  final TransactionController txController = Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    
    final screenWidth = MediaQuery.of(context).size.width * 0.92;
    final formattedSavings = NumberFormat.currency(locale: 'en_US', symbol: '\$')
        .format(5693.0);
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: screenWidth,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Obx(() {
                            final fullName = authController.user.value?.fullName ?? '';
                            final firstLetter =
                                fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

                            return CircleAvatar(
                              radius: 30,
                              backgroundColor: AppTheme.primary,
                              child: Text(
                                firstLetter,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Welcome back", style:AppTheme.bodyStyle),
                              Obx(() {
                                final fullName = authController.user.value?.fullName ?? 'User';
                                return Text(
                                  fullName,
                                  style: AppTheme.headingStyle,
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.search),
                          const SizedBox(width:12),
                          Icon(Icons.notifications_none)
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height:20),
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical:16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Balance",
                              style: AppTheme.linkStyle.copyWith(color: Colors.white),
                            ),
                            const Icon(Icons.more_horiz, color: Colors.white),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(() {
                            final balance = authController.user.value?.balance ?? 0;
                            return Text(
                              _fmt.format(balance),
                              style: AppTheme.headingStyle.copyWith(color:Colors.white),
                            );
                          })
                        ),
                        const SizedBox(height:40),
                            Obx(() {
                              final transactions = txController.transactions;

                              double totalIncome = 0;
                              double totalExpense = 0;

                              for (var tx in transactions) {
                                if (tx.type.toLowerCase() == "expense") {
                                  totalExpense += tx.amount;
                                } else {
                                  totalIncome += tx.amount;
                                }
                              }

                              final totalSavings = totalIncome - totalExpense;

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Summary(
                                    title: "Income",
                                    money: "+${_fmt.format(totalIncome)}",
                                    color: AppTheme.primary,
                                  ),
                                  Summary(
                                    title: "Expenses",
                                    money: "-${_fmt.format(totalExpense)}",
                                    color: const Color(0xFFCC3C3F),
                                  ),
                                  Summary(
                                    title: "Savings",
                                    money: _fmt.format(totalSavings),
                                    color: const Color(0xFF3575DC),
                                  ),
                                ],
                              );
                            }),
                          ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Recent Transactions", style:AppTheme.headingStyle),
                      Text("View All", style:AppTheme.bodyStyle.copyWith(color:AppTheme.primary))
                    ],
                  ),
                  const SizedBox(height:12),
                  Obx(() {
                    final recentExpenses = txController.transactions                        .take(3)
                        .toList();

                    if (recentExpenses.isEmpty) {
                      return const Text("No recent expenses");
                    }

                    return Column(
                      children: recentExpenses.map((tx) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            title: tx.title,
                            time: DateFormat('MMM dd, HH:mm').format(tx.date),
                            icon: tx.type == "expense" ? Icons.shopping_cart : Icons.account_balance,
                            money: tx.type == "expense"
                              ? "-${_fmt.format(tx.amount)}"
                              : "+${_fmt.format(tx.amount)}",
                            color: tx.type == 'expense' ? Colors.black : AppTheme.primary,
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Upcoming Bills", style:AppTheme.headingStyle),
                      Text("View All", style:AppTheme.bodyStyle.copyWith(color:AppTheme.primary))
                    ],
                  ),
                  const SizedBox(height:12),
                  Card(title:"Groceries",time:"Yesterday 09:00", icon: Icons.shopping_cart, money: formattedSavings, color:Color(0xFFCC3C3F))
                ],
              ),
            ),
          )
        )
      ),
      bottomNavigationBar: SafeArea(
        child:NavBar(
          currentIndex: _currentIndex, 
          onTap: (index){
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
        ) ,
      ),
    );
  }
}

class Card extends StatelessWidget {
  const Card({
    super.key,
    required this.money,
    required this.color,
    required this.icon,
    required this.title,
    required this.time
  });

  final String money;
  final Color color;
  final IconData icon;
  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 84,
      padding: EdgeInsets.symmetric(horizontal:20, vertical:4),
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical:16, horizontal: 12),
            decoration:BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.all(
                Radius.circular(90),
              )
            ),
            child: Icon(icon, color:color),
          ),
          const SizedBox(width:12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style:AppTheme.labelStyle),
              Text(time, style:AppTheme.bodyStyle)
            ],
          ),
          const Spacer(),
          Text(money, style:AppTheme.labelStyle.copyWith(color:color))
        ]
      )
    );
  }
}

class Summary extends StatelessWidget {
  const Summary({
    super.key,
    required this.money,
    required this.color,
    required this.title
  });

  final String money;
  final String title;
  final dynamic color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style:AppTheme.bodyStyle.copyWith(color:Colors.white)),
        Align(
          alignment: Alignment.center,
          child: Text(
            money,
            style: AppTheme.labelStyle.copyWith(color: color),
          ),
        ),
      ]
    );
  }
}