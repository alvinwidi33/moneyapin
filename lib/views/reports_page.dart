import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyapin/theme/app_theme.dart';
import 'package:moneyapin/theme/navbar.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
      double balance = 12840.5;
    final formattedBalance = NumberFormat.currency(locale: 'en_US', symbol: '\$')
        .format(balance);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width:MediaQuery.of(context).size.width * 0.92,
              child: Column(
                children: [
                  const SizedBox(height:8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back),
                      Text("Financial Report", style:AppTheme.headingStyle),
                      Icon(Icons.more_horiz)
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(vertical:8),
                    decoration: BoxDecoration(
                      color:Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Weekly", style:AppTheme.bodyStyle),
                        Text("Monthly", style:AppTheme.bodyStyle),
                        Text("Yearly", style:AppTheme.bodyStyle),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width:double.infinity,
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Executive Summary", style:AppTheme.headingStyle)
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color:Color(0xFFE5E7EB),
                                borderRadius: BorderRadius.circular(4)
                              ),
                              child: Text("This Month", style:AppTheme.bodyStyle),
                            ),
                          ],
                        ),
                        const SizedBox(height:12),
                        SummaryCard(formattedBalance: formattedBalance, title:"Total Income", icon: Icons.trending_up, color:Color(0xFF59976F)),
                        const SizedBox(height:12),
                        SummaryCard(formattedBalance: formattedBalance, title:"Total Expenses", icon: Icons.trending_down, color:Color(0xFF9D1A1A)),
                        const SizedBox(height:12),
                        SummaryCard(formattedBalance: formattedBalance, title:"New Savings", icon: Icons.account_balance, color:Color(0xFF2A4CB8)),
                        const SizedBox(height:20),
                        Row(
                          children: [
                            Text("Financial Healthy: ", style:AppTheme.labelStyle),
                            Text("Excellent", style:AppTheme.labelStyle.copyWith(color:AppTheme.primary))
                          ],
                        ),
                        Text("You've saved 25% more than the previous period. Keep up the great work!", style:AppTheme.bodyStyle),
                      ],
                    ),
                  ),
                  const SizedBox(height:24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width:double.infinity,
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
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Income vs Expense Trend", style:AppTheme.headingStyle)
                        ),
                      ],
                    )
                  ),
                  const SizedBox(height:20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Expense Breakdown", style: AppTheme.headingStyle),
                      Text("View All", style:AppTheme.bodyStyle.copyWith(color:AppTheme.primary))
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width:double.infinity,
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
                      children: [
                      ],
                    )
                  ),
                  const SizedBox(height:20),
                  Align(
                    alignment:Alignment.centerLeft,
                    child: Text("Period Comparison", style: AppTheme.headingStyle)
                  ),
                  const SizedBox(height:20),
                  ComparisonCard(title:"Income", formattedBalance: formattedBalance, color:Color(0xFF59976F), icon: Icons.arrow_upward, detail:"+15% vs last month"),
                  const SizedBox(height:12),
                  ComparisonCard(title:"Expenses", formattedBalance: formattedBalance, color:Color(0xFF9D1A1A), icon: Icons.arrow_downward, detail:"-5% vs last month"),
                  const SizedBox(height:20),
                ],
              ),
            ),
          ),
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

class ComparisonCard extends StatelessWidget {
  const ComparisonCard({
    super.key,
    required this.formattedBalance,
    required this.title,
    required this.icon,
    required this.color,
    required this.detail
  });

  final String formattedBalance;
  final String title;
  final IconData icon;
  final Color color;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width:double.infinity,
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
        children: [
          Align(
            alignment:Alignment.centerLeft,
            child: Text(title, style: AppTheme.labelStyle)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formattedBalance, style: AppTheme.headingStyle),
              Row(
                children: [
                  Icon(icon, color:color),
                  Text(detail, style:AppTheme.bodyStyle.copyWith(color: color)),
                ],
              )
            ],
          )
        ],
      )
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.formattedBalance,
    required this.title,
    required this.color,
    required this.icon
  });

  final String formattedBalance;
  final String title;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.20),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style:AppTheme.bodyStyle.copyWith(color:color)),
              Text(formattedBalance, style:AppTheme.headingStyle.copyWith(color:color))
            ],
          ),
          Icon(icon, color:color, size:40)
        ],
      )
    );
  }
}