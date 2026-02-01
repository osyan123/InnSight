import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailySalesDialog extends StatefulWidget {
  const DailySalesDialog({
    super.key,
    this.editableTotalLodgingSales = true,
    this.initialTotalLodgingSales = 0.0,
    this.initialAdditionalCharges = 0.0,
    this.initialDeductionsDiscounts = 0.0,
    this.initialCashOnHand = 0.0,
    required this.onCloseSalesForToday,
  });

  final bool editableTotalLodgingSales;

  final double initialTotalLodgingSales;
  final double initialAdditionalCharges;
  final double initialDeductionsDiscounts;
  final double initialCashOnHand;

  final Future<void> Function({
    required double totalLodgingSales,
    required double additionalCharges,
    required double deductionsDiscounts,
    required double netTotalSales,
    required double cashOnHand,
  })
  onCloseSalesForToday;

  @override
  State<DailySalesDialog> createState() => _DailySalesDialogState();
}

class _DailySalesDialogState extends State<DailySalesDialog> {
  late final TextEditingController _lodgingCtrl;
  late final TextEditingController _addCtrl;
  late final TextEditingController _dedCtrl;
  late final TextEditingController _cashCtrl;

  // final _peso0 = NumberFormat.currency(locale: 'en_PH', symbol: '₱', decimalDigits: 0);
  final _peso2 = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱',
    decimalDigits: 2,
  );

  @override
  void initState() {
    super.initState();
    _lodgingCtrl = TextEditingController(
      text: widget.initialTotalLodgingSales.toStringAsFixed(0),
    );
    _addCtrl = TextEditingController(
      text: widget.initialAdditionalCharges.toStringAsFixed(0),
    );
    _dedCtrl = TextEditingController(
      text: widget.initialDeductionsDiscounts.toStringAsFixed(0),
    );
    _cashCtrl = TextEditingController(
      text: widget.initialCashOnHand.toStringAsFixed(0),
    );

    // Recalculate live when user types
    _lodgingCtrl.addListener(_rebuild);
    _addCtrl.addListener(_rebuild);
    _dedCtrl.addListener(_rebuild);
    _cashCtrl.addListener(_rebuild);
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _lodgingCtrl.removeListener(_rebuild);
    _addCtrl.removeListener(_rebuild);
    _dedCtrl.removeListener(_rebuild);
    _cashCtrl.removeListener(_rebuild);

    _lodgingCtrl.dispose();
    _addCtrl.dispose();
    _dedCtrl.dispose();
    _cashCtrl.dispose();
    super.dispose();
  }

  double _parseNum(String s) {
    final cleaned = s.replaceAll(',', '').replaceAll('₱', '').trim();
    return double.tryParse(cleaned) ?? 0.0;
  }

  double get _totalLodgingSales => _parseNum(_lodgingCtrl.text);
  double get _additionalCharges => _parseNum(_addCtrl.text);
  double get _deductionsDiscounts => _parseNum(_dedCtrl.text);
  double get _cashOnHand => _parseNum(_cashCtrl.text);

  double get _netTotalSales =>
      _totalLodgingSales + _additionalCharges - _deductionsDiscounts;

  Future<void> _confirmCloseSales() async {
    final net = _netTotalSales;

    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          title: const Text("Confirm Close Sales"),
          content: Text(
            "Finalize today's sales?\n\nNet Total: ${_peso2.format(net)}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );

    if (ok != true) return;

    await widget.onCloseSalesForToday(
      totalLodgingSales: _totalLodgingSales,
      additionalCharges: _additionalCharges,
      deductionsDiscounts: _deductionsDiscounts,
      netTotalSales: net,
      cashOnHand: _cashOnHand,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  const Text(
                    "₱",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Daily Sales Summary",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.black54),
                    tooltip: "Close",
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Total Lodging Sales"),
                      TextField(
                        controller: _lodgingCtrl,
                        readOnly: !widget.editableTotalLodgingSales,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: _fieldDeco(prefix: _pesoPrefix()),
                      ),

                      const SizedBox(height: 16),

                      _label("Additional Charges"),
                      TextField(
                        controller: _addCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: _fieldDeco(
                          prefix: _pesoPrefix(),
                          hint: "0",
                        ),
                      ),

                      const SizedBox(height: 16),

                      _label("Deductions / Discounts"),
                      TextField(
                        controller: _dedCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: _fieldDeco(
                          prefix: _pesoPrefix(),
                          hint: "0",
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Divider(height: 20),

                      // Net total highlight
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Net Total Sales",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E3A8A),
                                ),
                              ),
                            ),
                            Text(
                              _peso2.format(_netTotalSales),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF1E3A8A),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      _label("Cash on Hand"),
                      TextField(
                        controller: _cashCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: _fieldDeco(
                          prefix: _pesoPrefix(),
                          hint: "0",
                        ),
                      ),

                      const SizedBox(height: 6),
                      Text(
                        "Tip: Net Total = Lodging + Charges − Deductions",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _confirmCloseSales,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Close Sales for Today",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _pesoPrefix() => const Padding(
    padding: EdgeInsets.only(left: 12, right: 8),
    child: Text(
      "₱",
      style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black54),
    ),
  );

  InputDecoration _fieldDeco({Widget? prefix, String? hint}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefix,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
