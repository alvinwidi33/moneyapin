import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyapin/theme/app_theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.92;
    double balance = 12840.5;
    final formattedBalance = NumberFormat.currency(locale: 'en_US', symbol: '\$')
        .format(balance);
    final formattedIncome = NumberFormat.currency(locale: 'en_US', symbol: '\$')
        .format(50000.0);
    final formattedExpense = NumberFormat.currency(locale: 'en_US', symbol: '\$')
        .format(1990.0);
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
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppTheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Welcome back", style:AppTheme.bodyStyle),
                              Text("Alex M", style: AppTheme.headingStyle)
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
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
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
                          child: Text(
                            formattedBalance,
                            style: AppTheme.headingStyle.copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height:40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Summary(title: "Income", money: "+$formattedIncome", color:AppTheme.primary),
                            Summary(title: "Expenses", money: "-$formattedExpense", color:Color(0xFFCC3C3F)),
                            Summary(title: "Savings", money: "+$formattedSavings", color:Color(0xFF3575DC)),
                          ],
                        )
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
                  Card(title:"Groceries",time:"Yesterday 09:00", icon: Icons.shopping_cart, money: formattedSavings, color:Color(0xFFCC3C3F)),
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
      )
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
          Text(money, style:AppTheme.labelStyle,)
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