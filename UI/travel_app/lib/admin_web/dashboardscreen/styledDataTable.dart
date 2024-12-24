import 'package:flutter/material.dart';

class StyledDataTable extends StatefulWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final int rowsPerPage;

  const StyledDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.rowsPerPage = 30,
  });

  @override
  State<StyledDataTable> createState() => _StyledDataTableState();
}

class _StyledDataTableState extends State<StyledDataTable> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final totalPages = (widget.rows.length / widget.rowsPerPage).ceil();
    final startIndex = _currentPage * widget.rowsPerPage;
    final endIndex = startIndex + widget.rowsPerPage;

    final displayedRows = widget.rows.sublist(
      startIndex,
      endIndex > widget.rows.length ? widget.rows.length : endIndex,
    );

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            child: DataTable(
              columnSpacing: 16,
              headingRowColor: MaterialStateProperty.resolveWith(
                (states) => Colors.blue.shade300,
              ),
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              columns: widget.columns,
              rows: displayedRows,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (totalPages > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _currentPage > 0
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                      }
                    : null,
                icon: Image.asset(
                  'assets/icon/panah_kiri.png',
                  width: 24,
                  height: 24,
                ),
              ),
              Text(
                'Page ${_currentPage + 1} of $totalPages',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: _currentPage < totalPages - 1
                    ? () {
                        setState(() {
                          _currentPage++;
                        });
                      }
                    : null,
                icon: Image.asset(
                  'assets/icon/panah_kanan.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
