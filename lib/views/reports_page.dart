import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moneyapin/theme/app_theme.dart';
import 'package:moneyapin/theme/navbar.dart';
import 'package:moneyapin/controllers/transaction_controller.dart';
import 'package:moneyapin/models/transactions.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final int _currentIndex = 1;
  final TransactionController _txController = Get.find<TransactionController>();

  String _period = 'Monthly';

  static final _currencyFmt =
      NumberFormat.currency(locale: 'en_US', symbol: '\$');

  String _fmt(double v) => _currencyFmt.format(v);

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

List<Transactions> get _filtered {
  final now = DateTime.now();
  final today = _dateOnly(now);
  final weekAgo = today.subtract(const Duration(days: 6));

  return _txController.transactions.where((t) {
    final txDate = _dateOnly(t.date);

    switch (_period) {
      case 'Weekly':
        return !txDate.isBefore(weekAgo) &&
               !txDate.isAfter(today);

      case 'Yearly':
        return txDate.year == now.year;

      case 'Monthly':
      default:
        return txDate.year == now.year &&
               txDate.month == now.month;
    }
  }).toList();
}

  List<Transactions> get _prevFiltered {
    final now = DateTime.now();
    return _txController.transactions.where((t) {
      switch (_period) {
        case 'Weekly':
          final twoWeeksAgo = now.subtract(const Duration(days: 14));
          final weekAgo = now.subtract(const Duration(days: 7));
          return t.date.isAfter(twoWeeksAgo) && t.date.isBefore(weekAgo);
        case 'Yearly':
          return t.date.year == now.year - 1;
        case 'Monthly':
        default:
          final prevMonth = now.month == 1 ? 12 : now.month - 1;
          final prevYear = now.month == 1 ? now.year - 1 : now.year;
          return t.date.year == prevYear && t.date.month == prevMonth;
      }
    }).toList();
  }

  double _totalIncome(List<Transactions> list) =>
      list.where((t) => t.type == 'income').fold(0, (s, t) => s + t.amount);

  double _totalExpense(List<Transactions> list) =>
      list.where((t) => t.type == 'expense').fold(0, (s, t) => s + t.amount);

  double _savings(List<Transactions> list) {
    final s = _totalIncome(list) - _totalExpense(list);
    return s < 0 ? 0 : s;
  }

  String _healthLabel(List<Transactions> list) {
    final income = _totalIncome(list);
    final expense = _totalExpense(list);
    if (income == 0) return 'No Data';
    final ratio = expense / income;
    if (ratio < 0.5) return 'Excellent';
    if (ratio < 0.75) return 'Good';
    if (ratio < 1.0) return 'Fair';
    return 'Critical';
  }

  Color _healthColor(String label) {
    switch (label) {
      case 'Excellent':
        return AppTheme.primary;
      case 'Good':
        return Colors.blue;
      case 'Fair':
        return Colors.orange;
      default:
        return const Color(0xFF9D1A1A);
    }
  }

  Map<String, double> get _expenseByCategory {
    final result = <String, double>{};
    for (final t in _filtered.where((t) => t.type == 'expense')) {
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return result;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<Map<String, dynamic>> get _trendData {
    final now = DateTime.now();
    final allTx = _txController.transactions;

    switch (_period) {
      case 'Weekly':
        return List.generate(7, (i) {
          final day = _dateOnly(now.subtract(Duration(days: 6 - i)));
          final dayTx = allTx.where((t) => _isSameDay(_dateOnly(t.date), day));
          return {
            'label': DateFormat('E').format(day),
            'income': dayTx.where((t) => t.type == 'income').fold(0.0, (s, t) => s + t.amount),
            'expense': dayTx.where((t) => t.type == 'expense').fold(0.0, (s, t) => s + t.amount),
          };
        });

      case 'Yearly':
        return List.generate(12, (i) {
          final month = i + 1;
          final monthTx = allTx.where(
            (t) => t.date.year == now.year && t.date.month == month,
          );
          return {
            'label': DateFormat('MMM').format(DateTime(now.year, month)),
            'income': monthTx.where((t) => t.type == 'income').fold(0.0, (s, t) => s + t.amount),
            'expense': monthTx.where((t) => t.type == 'expense').fold(0.0, (s, t) => s + t.amount),
          };
        });

      case 'Monthly':
      default:
        final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
        final buckets = <Map<String, dynamic>>[];
        for (var start = 1; start <= daysInMonth; start += 5) {
          final end = (start + 4).clamp(1, daysInMonth);
          final bucketTx = allTx.where(
            (t) =>
                t.date.year == now.year &&
                t.date.month == now.month &&
                t.date.day >= start &&
                t.date.day <= end,
          );
          buckets.add({
            'label': '$start',
            'income': bucketTx.where((t) => t.type == 'income').fold(0.0, (s, t) => s + t.amount),
            'expense': bucketTx.where((t) => t.type == 'expense').fold(0.0, (s, t) => s + t.amount),
          });
        }
        return buckets;
    }
  }

  static const _categoryColors = [
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFFF44336),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFFFFEB3B),
  ];

  String _pctChange(double current, double previous) {
    if (previous == 0) return current > 0 ? '+100%' : '0%';
    final pct = ((current - previous) / previous * 100).toStringAsFixed(0);
    return '${current >= previous ? '+' : ''}$pct%';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final filtered = _filtered;
          final prev = _prevFiltered;
          final income = _totalIncome(filtered);
          final expense = _totalExpense(filtered);
          final savings = _savings(filtered);
          final prevIncome = _totalIncome(prev);
          final prevExpense = _totalExpense(prev);
          final health = _healthLabel(filtered);
          final expByCat = _expenseByCategory;
          final trend = _trendData;

          return SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.92,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.arrow_back),
                        Text('Financial Report', style: AppTheme.headingStyle),
                        const Icon(Icons.more_horiz),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: ['Weekly', 'Monthly', 'Yearly'].map((p) {
                          final active = _period == p;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _period = p),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: active ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: active
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
                                  p,
                                  style: AppTheme.bodyStyle.copyWith(
                                    color: active ? Colors.black87 : Colors.grey,
                                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Executive Summary', style: AppTheme.headingStyle.copyWith(fontSize: 20)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE5E7EB),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('This ${_period == 'Yearly' ? 'Year' : _period == 'Weekly' ? 'Week' : 'Month'}',
                                    style: AppTheme.bodyStyle),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _SummaryCard(
                            title: 'Total Income',
                            icon: Icons.trending_up,
                            color: const Color(0xFF59976F),
                            value: _fmt(income),
                          ),
                          const SizedBox(height: 12),
                          _SummaryCard(
                            title: 'Total Expenses',
                            icon: Icons.trending_down,
                            color: const Color(0xFF9D1A1A),
                            value: _fmt(expense),
                          ),
                          const SizedBox(height: 12),
                          _SummaryCard(
                            title: 'Net Savings',
                            icon: Icons.account_balance,
                            color: const Color(0xFF2A4CB8),
                            value: _fmt(savings),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text('Financial Health: ', style: AppTheme.labelStyle),
                              Text(
                                health,
                                style: AppTheme.labelStyle.copyWith(
                                  color: _healthColor(health),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            income == 0
                                ? 'No transactions this period yet.'
                                : savings > 0
                                    ? "You've saved ${_fmt(savings)} this period. Keep it up!"
                                    : 'Expenses exceeded income this period. Review your spending.',
                            style: AppTheme.bodyStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Income vs Expense Trend', style: AppTheme.headingStyle),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 180,
                            child: trend.isEmpty
                                ? const Center(child: Text('No data'))
                                : _TrendLineChart(data: trend),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _LegendDot(color: const Color(0xFF59976F), label: 'Income'),
                              const SizedBox(width: 20),
                              _LegendDot(color: const Color(0xFF9D1A1A), label: 'Expense'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Expense Breakdown', style: AppTheme.headingStyle),
                        Text(
                          'View All',
                          style: AppTheme.bodyStyle.copyWith(color: AppTheme.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _Card(
                      child: expByCat.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text('No expenses this period', style: AppTheme.bodyStyle),
                              ),
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 180,
                                  child: _DonutChart(
                                    data: expByCat,
                                    colors: _categoryColors,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 8,
                                  children: expByCat.entries.toList().asMap().entries.map((entry) {
                                    final idx = entry.key;
                                    final cat = entry.value.key;
                                    final val = entry.value.value;
                                    return _LegendDot(
                                      color: _categoryColors[idx % _categoryColors.length],
                                      label: '$cat  ${_fmt(val)}',
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Period Comparison', style: AppTheme.headingStyle),
                    ),
                    const SizedBox(height: 12),
                    _ComparisonCard(
                      title: 'Income',
                      value: _fmt(income),
                      color: const Color(0xFF59976F),
                      icon: Icons.arrow_upward,
                      detail: _pctChange(income, prevIncome) + ' vs last period',
                      isPositive: income >= prevIncome,
                    ),
                    const SizedBox(height: 12),
                    _ComparisonCard(
                      title: 'Expenses',
                      value: _fmt(expense),
                      color: const Color(0xFF9D1A1A),
                      icon: Icons.arrow_downward,
                      detail: _pctChange(expense, prevExpense) + ' vs last period',
                      isPositive: expense <= prevExpense,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: SafeArea(
        child: NavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == _currentIndex) return;
            if (index == 0) Navigator.pushReplacementNamed(context, '/dashboard');
            if (index == 1) Navigator.pushReplacementNamed(context, '/reports');
            if (index == 2) Navigator.pushReplacementNamed(context, '/wallets');
            if (index == 3) Navigator.pushReplacementNamed(context, '/profile');
          },
          onAddTap: () => Navigator.pushNamed(context, '/add'),
        ),
      ),
    );
  }
}


class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: child,
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.bodyStyle.copyWith(color: color)),
              Text(value,
                  style: AppTheme.headingStyle.copyWith(color: color, fontSize: 20)),
            ],
          ),
          Icon(icon, color: color, size: 36),
        ],
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String detail;
  final bool isPositive;

  const _ComparisonCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    required this.detail,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Text(title, style: AppTheme.labelStyle),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: AppTheme.headingStyle),
              Row(
                children: [
                  Icon(icon, color: color, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    detail,
                    style: AppTheme.bodyStyle.copyWith(color: color),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTheme.bodyStyle.copyWith(fontSize: 12)),
      ],
    );
  }
}


class _TrendLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const _TrendLineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    double maxY = 0;
    for (final d in data) {
      if ((d['income'] as double) > maxY) maxY = d['income'] as double;
      if ((d['expense'] as double) > maxY) maxY = d['expense'] as double;
    }
    maxY = maxY == 0 ? 10 : maxY * 1.25;
    final minY = -maxY * 0.05; 

    LineChartBarData _line(List<FlSpot> spots, Color color) => LineChartBarData(
          spots: spots,
          isCurved: true,
          color: color,
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: color.withValues(alpha: 0.1),
          ),
        );

    final incomeSpots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value['income'] as double))
        .toList();
    final expenseSpots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value['expense'] as double))
        .toList();

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (v) => FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              getTitlesWidget: (value, meta) {
                if (value == 0 || value == maxY) return const SizedBox();
                return Text(
                  '\$${value >= 1000 ? '${(value / 1000).toStringAsFixed(0)}k' : value.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= data.length) return const SizedBox();
                return Text(
                  data[idx]['label'] as String,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          _line(incomeSpots, const Color(0xFF59976F)),
          _line(expenseSpots, const Color(0xFF9D1A1A)),
        ],
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  final Map<String, double> data;
  final List<Color> colors;

  const _DonutChart({required this.data, required this.colors});

  @override
  Widget build(BuildContext context) {
    final sections = data.entries.toList().asMap().entries.map((entry) {
      final idx = entry.key;
      final val = entry.value.value;
      final color = colors[idx % colors.length];
      return PieChartSectionData(
        value: val,
        color: color,
        radius: 55,
        title: '',
        showTitle: false,
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 45,
        sectionsSpace: 2,
        startDegreeOffset: -90,
      ),
    );
  }
}