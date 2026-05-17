import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../constants/app_colors.dart';
import 'services_content.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WebDashboardView extends StatefulWidget {
  WebDashboardView({Key? key}) : super(key: key);

  @override
  State<WebDashboardView> createState() => _WebDashboardViewState();
}

class _WebDashboardViewState extends State<WebDashboardView> {
  // Add RxInt to track selected index
  final RxInt selectedIndex = 0.obs;
  
  // Sidebar visibility state
  final RxBool isSidebarOpen = true.obs;
  
  // Scaffold key for drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Define missing colors as static constants
  static const Color statRequestsColor = Color(0xFF9FD33D);
  static const Color statPendingColor = Color(0xFFFFA113);
  static const Color statPaidColor = Color(0xFF00BFA5);
  static const Color statCanceledColor = Color(0xFFFF5722);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    // List of content widgets
    final List<Widget> contentViews = [
      _buildMainDashboard(),
      const ServicesContent(),
      const Center(child: Text('Prescriptions Coming Soon')),
      _buildNotificationsContent(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      // Drawer for mobile screens
      drawer: isMobile ? _buildDrawer(authController) : null,
      body: Row(
        children: [
          // Left Sidebar for desktop/tablet
          if (!isMobile)
            Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSidebarOpen.value 
                  ? (isTablet ? 200 : 250) 
                  : 70,
              color: AppColors.primary,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Padding(
                  padding: EdgeInsets.all(isSidebarOpen.value ? 24 : 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isSidebarOpen.value)
                        const Text(
                          'InstaClinic',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        )
                      else
                        const Icon(
                          Icons.medical_services,
                          color: Colors.white,
                          size: 32,
                        ),
                      if (isSidebarOpen.value) const SizedBox(height: 8),
                      if (isSidebarOpen.value)
                        Text(
                          'Hi, Admin',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                    ],
                  ),
                )),
                const SizedBox(height: 16),
                _buildSidebarButton(
                  'Administration',
                  Icons.admin_panel_settings,
                  index: 0,
                ),
                _buildSidebarButton(
                  'Services',
                  Icons.medical_services,
                  index: 1,
                ),
                _buildSidebarButton(
                  'Add Prescription',
                  Icons.description,
                  index: 2,
                ),
                _buildSidebarButton(
                  'Notifications',
                  Icons.notifications,
                  index: 3,
                ),
                const Spacer(),
                Obx(() => Padding(
                  padding: EdgeInsets.all(isSidebarOpen.value ? 24 : 12),
                  child: Column(
                    children: [
                      // Language Selector
                      if (isSidebarOpen.value)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Language',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'EN',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.language, color: Colors.white),
                          tooltip: 'Language',
                        ),
                      SizedBox(height: isSidebarOpen.value ? 16 : 8),
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: isSidebarOpen.value
                            ? ElevatedButton.icon(
                                onPressed: () => authController.signOut(),
                                icon: Icon(Icons.logout, color: AppColors.primary),
                                label: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                            : IconButton(
                                onPressed: () => authController.signOut(),
                                icon: Icon(Icons.logout, color: Colors.white),
                                tooltip: 'Logout',
                              ),
                      ),
                    ],
                  ),
                )),
              ],
            )),
          ),
          // Main Content - Changes based on selection
          Expanded(
            child: Column(
              children: [
                // Top App Bar with menu button
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Menu/Toggle button
                      IconButton(
                        icon: Icon(
                          isMobile ? Icons.menu : Icons.menu_open,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          if (isMobile) {
                            _scaffoldKey.currentState?.openDrawer();
                          } else {
                            isSidebarOpen.value = !isSidebarOpen.value;
                          }
                        },
                        tooltip: isMobile ? 'Open Menu' : 'Toggle Sidebar',
                      ),
                      const SizedBox(width: 16),
                      // Page title based on selected index
                      Obx(() => Text(
                        _getPageTitle(selectedIndex.value),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      )),
                      const Spacer(),
                      // Admin info for desktop
                      if (!isMobile)
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: Icon(Icons.person, color: AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Admin',
                              style: TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                // Page content
                Expanded(
                  child: Obx(() => contentViews[selectedIndex.value]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Get page title based on index
  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Administration';
      case 1:
        return 'Services';
      case 2:
        return 'Prescriptions';
      case 3:
        return 'Push Notifications';
      default:
        return 'Dashboard';
    }
  }

  // Build drawer for mobile
  Widget _buildDrawer(AuthController authController) {
    return Drawer(
      child: Container(
        color: AppColors.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'InstaClinic',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hi, Admin',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Menu items
            _buildSidebarButton(
              'Administration',
              Icons.admin_panel_settings,
              index: 0,
              isDrawer: true,
            ),
            _buildSidebarButton(
              'Services',
              Icons.medical_services,
              index: 1,
              isDrawer: true,
            ),
            _buildSidebarButton(
              'Add Prescription',
              Icons.description,
              index: 2,
              isDrawer: true,
            ),
            _buildSidebarButton(
              'Notifications',
              Icons.notifications,
              index: 3,
              isDrawer: true,
            ),
            const Spacer(),
            // Language and logout
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Language',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'EN',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => authController.signOut(),
                      icon: Icon(Icons.logout, color: AppColors.primary),
                      label: Text(
                        'Logout',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarButton(String title, IconData icon, {required int index, bool isDrawer = false}) {
    return Obx(() {
      final isSelected = selectedIndex.value == index;
      final isCollapsed = !isSidebarOpen.value && !isDrawer;
      
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: isCollapsed
            ? Tooltip(
                message: title,
                child: IconButton(
                  icon: Icon(icon, color: Colors.white, size: 24),
                  onPressed: () => selectedIndex.value = index,
                ),
              )
            : ListTile(
                leading: Icon(icon, color: Colors.white, size: 20),
                title: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                dense: true,
                onTap: () {
                  selectedIndex.value = index;
                  // Close drawer on mobile after selection
                  if (isDrawer) {
                    Navigator.of(context).pop();
                  }
                },
              ),
      );
    });
  }
  Widget _buildMainDashboard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 768;
        final isTablet = screenWidth >= 768 && screenWidth < 1024;
        
        return Container(
          color: AppColors.background,
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Cards
              FutureBuilder<Map<String, int>>(
                future: _fetchBookingStats(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return _buildStatsGrid(
                      isMobile: isMobile,
                      isTablet: isTablet,
                      stats: {'total': 0, 'pending': 0, 'done': 0, 'canceled': 0},
                      isLoading: true,
                    );
                  }
                  final stats = snapshot.data!;
                  return _buildStatsGrid(
                    isMobile: isMobile,
                    isTablet: isTablet,
                    stats: stats,
                  );
                },
              ),
              SizedBox(height: isMobile ? 16 : 24),
              // Table Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Requests',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: isMobile ? 16 : 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 12 : 16),
                      Expanded(
                        child: isMobile
                            ? _buildMobileBookingList()
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: _buildBookingTable(),
                                ),
                              ),
                      ),
                      SizedBox(height: isMobile ? 12 : 16),
                      Center(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.refresh, color: AppColors.primary),
                          label: Text(
                            'View All',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Build responsive stats grid
  Widget _buildStatsGrid({
    required bool isMobile,
    required bool isTablet,
    required Map<String, int> stats,
    bool isLoading = false,
  }) {
    final statItems = [
      {'title': 'Requests', 'value': stats['total'] ?? 0, 'color': statRequestsColor},
      {'title': 'Pending', 'value': stats['pending'] ?? 0, 'color': statPendingColor},
      {'title': 'Done', 'value': stats['done'] ?? 0, 'color': statPaidColor},
      {'title': 'Canceled', 'value': stats['canceled'] ?? 0, 'color': statCanceledColor},
    ];

    if (isMobile) {
      // Mobile: 2 columns grid
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: statItems.length,
        itemBuilder: (context, index) {
          final item = statItems[index];
          return _buildStatCard(
            item['title'] as String,
            isLoading ? '...' : item['value'].toString(),
            isLoading ? '...' : item['value'].toString(),
            item['color'] as Color,
            isCompact: true,
          );
        },
      );
    } else if (isTablet) {
      // Tablet: 2x2 grid
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: statItems.length,
        itemBuilder: (context, index) {
          final item = statItems[index];
          return _buildStatCard(
            item['title'] as String,
            isLoading ? '...' : item['value'].toString(),
            isLoading ? '...' : item['value'].toString(),
            item['color'] as Color,
          );
        },
      );
    } else {
      // Desktop: Single row
      return Row(
        children: statItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == statItems.length - 1;
          
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 16),
              child: _buildStatCard(
                item['title'] as String,
                isLoading ? '...' : item['value'].toString(),
                isLoading ? '...' : item['value'].toString(),
                item['color'] as Color,
              ),
            ),
          );
        }).toList(),
      );
    }
  }

  // Build mobile-friendly booking list
  Widget _buildMobileBookingList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchDashboardBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No bookings found.'));
        }
        final bookings = snapshot.data!;
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            final connectStatus = booking['connect_status'];
            Color? statusColor;
            if (connectStatus == true) {
              statusColor = Colors.green.withOpacity(0.1);
            } else if (connectStatus == false) {
              statusColor = Colors.red.withOpacity(0.1);
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: statusColor,
              child: InkWell(
                onTap: () => _showBookingDetailsDialog(context, booking, refresh: _refresh),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              booking['patient_name'] ?? 'N/A',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(connectStatus),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getStatusText(connectStatus),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildMobileInfoRow(Icons.medical_services, booking['services']?['name'] ?? 'N/A'),
                      _buildMobileInfoRow(Icons.phone, booking['contact_number'] ?? 'N/A'),
                      _buildMobileInfoRow(Icons.calendar_today, '${booking['booking_date'] ?? 'N/A'} - ${booking['booking_time'] ?? 'N/A'}'),
                      if (booking['patient_address'] != null && booking['patient_address'].toString().isNotEmpty)
                        _buildMobileInfoRow(Icons.location_on, booking['patient_address']),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMobileInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(dynamic status) {
    if (status == true) return Colors.green;
    if (status == false) return Colors.red;
    return Colors.orange;
  }

  String _getStatusText(dynamic status) {
    if (status == true) return 'Done';
    if (status == false) return 'Canceled';
    return 'Pending';
  }

  // Build desktop table
  Widget _buildBookingTable() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchDashboardBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No bookings found.'));
        }
        final bookings = snapshot.data!;
        return DataTable(
                              headingTextStyle:const  TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              dataTextStyle: const  TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                              border: TableBorder.all(color: Colors.grey, width: 1),
                              columns: const [
                                DataColumn(label: Text('User ID')),
                                DataColumn(label: Text('User Name')),
                                DataColumn(label: Text('Phone Number')),
                                DataColumn(label: Text('Service Name')),
                                DataColumn(label: Text('Address')),
                                DataColumn(label: Text('Reservation Date')),
                                DataColumn(label: Text('Reservation Time')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Created At')),
                                DataColumn(label: Text('Notes')),
                              ],
                              rows: bookings.map((booking) => DataRow(
                                color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                                  if (booking['connect_status'] == true) {
                                    return Colors.green.withOpacity(0.2);
                                  }
                                  if (booking['connect_status'] == false) {
                                    return Colors.red.withOpacity(0.2);
                                  }
                                  return null;
                                }),
                                cells: [
                                  DataCell(
                                    GestureDetector(
                                      onTap: () => _showBookingDetailsDialog(context, booking, refresh: _refresh),
                                      child: Text(
                                        booking['user_id'] != null && booking['user_id'].toString().isNotEmpty
                                          ? 'Show User'
                                          : (booking['user_id'] ?? 'show data'),
                                        style: booking['user_id'] != null && booking['user_id'].toString().isNotEmpty
                                          ? TextStyle(
                                              color: AppColors.primary,
                                              decoration: TextDecoration.underline,
                                              fontWeight: FontWeight.w600,
                                            )
                                          : null,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () => _showBookingDetailsDialog(context, booking, refresh: _refresh),
                                      child: Text(booking['patient_name'] ?? ''),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () => _showBookingDetailsDialog(context, booking, refresh: _refresh),
                                      child: Text(booking['contact_number'] ?? ''),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () => _showBookingDetailsDialog(context, booking, refresh: _refresh),
                                      child: Text(booking['services']?['name'] ?? ''),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () => _showBookingDetailsDialog(context, booking, refresh: _refresh),
                                      child: Text(
                                        _formatAddress(booking['addresses']).isNotEmpty
                                          ? _formatAddress(booking['addresses'])
                                          : (booking['patient_address'] ?? ''),
                                        style: TextStyle(
                                          color: AppColors.text,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () => _showBookingDetailsDialog(context, booking, refresh: _refresh),
                                      child: Text(booking['booking_date'] ?? ''),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () => _showBookingDetailsDialog(context, booking, refresh: _refresh),
                                      child: Text(booking['booking_time'] ?? ''),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () => _showBookingDetailsDialog(context, booking, refresh: _refresh),
                                      child: Text(booking['status'] ?? ''),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () => _showBookingDetailsDialog(context, booking, refresh: _refresh),
                                      child: Text(booking['created_at'] ?? ''),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () => _showBookingDetailsDialog(context, booking, refresh: _refresh),
                                      child: Text(booking['notes'] ?? ''),
                                    ),
                                  ),
                                ],
                              )).toList(),
                            );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchDashboardBookings() async {
    final response = await Supabase.instance.client
      .from('bookings')
      .select('*, users(*), services(*), addresses(*)')
      .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  String _formatAddress(Map<String, dynamic>? address) {
    if (address == null) return '';
    final city = address['city'] ?? '';
    final street = address['street'] ?? '';
    final building = address['building_no'] ?? '';
    final apartment = address['apartment_no'] ?? '';
    return [city, street, building, apartment].where((e) => e.isNotEmpty).join(', ');
  }

  Widget _buildStatCard(String title, String value, String count, Color color, {bool isCompact = false}) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 12 : 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isCompact ? 14 : 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 6 : 8,
                  vertical: isCompact ? 2 : 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isCompact ? 10 : 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isCompact ? 8 : 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isCompact ? 20 : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDetailsDialog(BuildContext context, Map<String, dynamic> booking, {VoidCallback? refresh}) {
    final user = booking['users'];
    final address = booking['addresses'];
    final service = booking['services'];
    // Fallbacks if user or address is missing
    final fallbackUserName = booking['patient_name'] ?? 'N/A';
    final fallbackUserPhone = booking['contact_number'] ?? 'N/A';
    final fallbackUserId = booking['user_id'] ?? 'N/A';
    final fallbackAddress = booking['patient_address'] ?? 'N/A';
    final fallbackAddressId = booking['address_id'] ?? 'N/A';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 600,
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.medical_services, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          Text(
                            'ID: ${booking['id']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Information
                      _buildInfoSection(
                        'User Information',
                        Icons.person,
                        [
                          _buildInfoRow('Full Name',
                            (user != null && ((user['first_name'] ?? '') + ' ' + (user['last_name'] ?? '')).trim().isNotEmpty)
                              ? ((user['first_name'] ?? '') + ' ' + (user['last_name'] ?? '')).trim()
                              : fallbackUserName
                          ),
                          _buildInfoRow('First Name', user?['first_name'] ?? fallbackUserName),
                          _buildInfoRow('Last Name', user?['last_name'] ?? ''),
                          _buildInfoRow('Email', user?['email'] ?? ''),
                          _buildInfoRow('Phone', user?['phone_number'] ?? fallbackUserPhone),
                          _buildInfoRow('User ID', fallbackUserId),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Service Information
                      _buildInfoSection(
                        'Service Information',
                        Icons.medical_services,
                        [
                          _buildInfoRow('Service Name', service?['name'] ?? 'N/A'),
                          _buildInfoRow('Category', service?['category'] ?? 'N/A'),
                          _buildInfoRow('Price', service?['price'] != null ? 'EGP ${service['price']}' : 'N/A'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Address Information
                      _buildInfoSection(
                        'Address Information',
                        Icons.location_on,
                        [
                          _buildInfoRow('Address ID', fallbackAddressId),
                          _buildInfoRow('City', address?['city'] ?? fallbackAddress),
                          _buildInfoRow('Street', address?['street'] ?? ''),
                          _buildInfoRow('Building', address?['building_no'] ?? ''),
                          _buildInfoRow('Apartment', address?['apartment_no'] ?? ''),
                          _buildInfoRow('Floor', address?['floor_no'] ?? ''),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Booking Information
                      _buildInfoSection(
                        'Booking Information',
                        Icons.calendar_today,
                        [
                          _buildInfoRow('Date', booking['booking_date'] ?? 'N/A'),
                          _buildInfoRow('Time', booking['booking_time'] ?? 'N/A'),
                          _buildInfoRow('Status', booking['status'] ?? 'N/A'),
                          _buildInfoRow('Created', booking['created_at'] ?? 'N/A'),
                          _buildInfoRow('Notes', booking['notes'] ?? 'No notes'),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              
              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close', style: TextStyle(color: Colors.black)),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _setConnectedStatus(booking['id']);
                            Navigator.of(context).pop();
                            if (refresh != null) refresh();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Connected', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await _setCanceledStatus(booking['id']);
                            Navigator.of(context).pop();
                            if (refresh != null) refresh();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setConnectedStatus(String bookingId) async {
    await Supabase.instance.client
        .from('bookings')
        .update({'connect_status': true})
        .eq('id', bookingId);
  }

  Future<void> _setCanceledStatus(String bookingId) async {
    await Supabase.instance.client
        .from('bookings')
        .update({'connect_status': 'false'})
        .eq('id', bookingId);
  }

  void _refresh() {
    setState(() {});
  }

  Future<Map<String, int>> _fetchBookingStats() async {
    final response = await Supabase.instance.client
        .from('bookings')
        .select('id, connect_status, status');
    final bookings = List<Map<String, dynamic>>.from(response);

    int total = bookings.length;
    int pending = bookings.where((b) => b['connect_status'] != true && b['connect_status'] != false).length;
    int done = bookings.where((b) => b['connect_status'] == true).length;
    int canceled = bookings.where((b) => b['connect_status'] == false).length;

    return {
      'total': total,
      'pending': pending,
      'done': done,
      'canceled': canceled,
    };
  }

  // Notifications Content Widget
  Widget _buildNotificationsContent() {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    String? selectedUserId;
    final RxBool isSending = false.obs;

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Push Notifications',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Notification Form
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Send Notification',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                
                // User Selection
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchUsersWithDevices(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final users = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select User',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return DropdownButton<String>(
                                value: selectedUserId,
                                isExpanded: true,
                                underline: const SizedBox(),
                                hint: const Text('Select a user or send to all'),
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: 'all',
                                    child: Text('All Users'),
                                  ),
                                  ...users.map((user) {
                                    final name = '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim();
                                    final email = user['email'] ?? '';
                                    return DropdownMenuItem<String>(
                                      value: user['id'].toString(),
                                      child: Text('$name ($email)'),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedUserId = value;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                
                // Title Input
                Text(
                  'Notification Title',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter notification title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Message Input
                Text(
                  'Notification Message',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter notification message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Send Button
                Obx(() => ElevatedButton.icon(
                  onPressed: isSending.value
                      ? null
                      : () async {
                          if (titleController.text.isEmpty || messageController.text.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please fill in all fields',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          if (selectedUserId == null) {
                            Get.snackbar(
                              'Error',
                              'Please select a user',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          
                          isSending.value = true;
                          try {
                            await _sendPushNotification(
                              selectedUserId!,
                              titleController.text,
                              messageController.text,
                            );
                            Get.snackbar(
                              'Success',
                              'Notification sent successfully',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                            titleController.clear();
                            messageController.clear();
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Failed to send notification: $e',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } finally {
                            isSending.value = false;
                          }
                        },
                  icon: Icon(
                    isSending.value ? Icons.hourglass_empty : Icons.send,
                    color: Colors.white,
                  ),
                  label: Text(
                    isSending.value ? 'Sending...' : 'Send Notification',
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Devices Table
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registered Devices',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchDevices(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No devices found.'));
                        }
                        final devices = snapshot.data!;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              headingTextStyle: TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              dataTextStyle: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                              border: TableBorder.all(color: Colors.grey, width: 1),
                              columns: const [
                                DataColumn(label: Text('User ID')),
                                DataColumn(label: Text('User Name')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('FCM Token')),
                                DataColumn(label: Text('Device Type')),
                                DataColumn(label: Text('Created At')),
                              ],
                              rows: devices.map((device) {
                                final user = device['users'];
                                final userName = user != null
                                    ? '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim()
                                    : 'N/A';
                                final email = user?['email'] ?? 'N/A';
                                return DataRow(
                                  cells: [
                                    DataCell(Text(device['user_id'] ?? 'N/A')),
                                    DataCell(Text(userName)),
                                    DataCell(Text(email)),
                                    DataCell(
                                      Tooltip(
                                        message: device['fcm_token'] ?? '',
                                        child: Text(
                                          device['fcm_token'] != null
                                              ? '${device['fcm_token'].toString().substring(0, 20)}...'
                                              : 'N/A',
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(device['device_type'] ?? 'N/A')),
                                    DataCell(Text(device['created_at'] ?? 'N/A')),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchDevices() async {
    final response = await Supabase.instance.client
        .from('device_tokens')
        .select('*, users:user_id(*)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> _fetchUsersWithDevices() async {
    final response = await Supabase.instance.client
        .from('users')
        .select('id, first_name, last_name, email')
        .order('first_name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> _sendPushNotification(String userId, String title, String message) async {
    // Fetch FCM tokens for the user(s)
    List<String> fcmTokens = [];
    
    if (userId == 'all') {
      // Fetch all FCM tokens
      final devices = await Supabase.instance.client
          .from('device_tokens')
          .select('fcm_token');
      fcmTokens = devices
          .map((d) => d['fcm_token'] as String?)
          .where((token) => token != null && token.isNotEmpty)
          .cast<String>()
          .toList();
    } else {
      // Fetch FCM tokens for specific user
      final devices = await Supabase.instance.client
          .from('device_tokens')
          .select('fcm_token')
          .eq('user_id', userId);
      fcmTokens = devices
          .map((d) => d['fcm_token'] as String?)
          .where((token) => token != null && token.isNotEmpty)
          .cast<String>()
          .toList();
    }

    if (fcmTokens.isEmpty) {
      throw Exception('No FCM tokens found for the selected user(s)');
    }

    // Call Firebase Cloud Function to send notifications
    // You can use either:
    // 1. Firebase Callable Function (recommended for Flutter apps with Firebase SDK)
    // 2. HTTP Function (via Supabase Edge Function or direct HTTP call)
    
    // Option 1: Using Firebase Callable Function (if you have firebase_core in pubspec.yaml)
    // final callable = FirebaseFunctions.instance.httpsCallable('sendNotification');
    // final result = await callable.call({
    //   'tokens': fcmTokens,
    //   'title': title,
    //   'message': message,
    // });
    
    // Option 2: Using Supabase Edge Function as a proxy to Firebase Cloud Function
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'sendNotification',
        body: {
          'tokens': fcmTokens,
          'title': title,
          'message': message,
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to send notification: ${response.data}');
      }
      
      // Log successful notification
      print('Notification sent to ${fcmTokens.length} device(s)');
    } catch (e) {
      print('Error sending notification: $e');
      rethrow;
    }
  }
}