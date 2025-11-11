import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_defaults.dart';
import '../../../core/constants/constants.dart';
import '../../../core/repositories/posts/offline_post_repository.dart';
import '../../offline/offline_posts_page.dart';

class OfflineSettings extends ConsumerWidget {
  const OfflineSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineRepo = ref.read(offlinePostRepoProvider);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Row(
              children: [
                Icon(
                  IconlyLight.bookmark,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: AppDefaults.padding),
                Text(
                  'offline_reading'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          // Saved Posts
          ListTile(
            leading: const Icon(IconlyLight.document),
            title: Text('Entradas Guardadas'.tr()),
            subtitle: FutureBuilder<int>(
              future: offlineRepo.getSavedPostsCount(),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return Text('$count ${'Entradas Guardadas sin Conexion'.tr()}');
              },
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OfflinePostsPage(),
                ),
              );
              // Refresh the providers when returning from offline posts page
              ref.invalidate(offlinePostRepoProvider);
            },
          ),

          // Clear All Offline Posts
          const Divider(height: 1),
          ListTile(
            leading: const Icon(IconlyLight.delete),
            title: Text('Eliminar todas las entradas sin Conexion'.tr()),
            subtitle: Text('Eliminar todas las entradas Guardadas'.tr()),
            onTap: () => _showClearAllDialog(context, ref),
          ),

          // Storage Information
          const Divider(height: 1),
          FutureBuilder<Map<String, dynamic>>(
            future: offlineRepo.getStorageInfo(),
            builder: (context, snapshot) {
              final storageInfo = snapshot.data ?? {};
              final totalSizeMB = storageInfo['totalSizeMB'] ?? '0.00';

              return ListTile(
                leading: const Icon(IconlyLight.chart),
                title: Text('Informacion de Almacenamiento'.tr()),
                subtitle:
                    Text('Almacenamiento Usado'.tr(namedArgs: {'size': totalSizeMB})),
                trailing: const Icon(Icons.info_outline),
                onTap: () => _showStorageInfoDialog(context, storageInfo),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,//
      builder: (context) => AlertDialog(
        title: Text('Eliminar todas las entradas sin conexion'.tr()),
        content: Text('Eliminar todas las entradas Guardadas'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'.tr()),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final offlineRepo = ref.read(offlinePostRepoProvider);
              final success = await offlineRepo.clearAllPosts();

              if (success) {
                // Refresh providers after clearing
                ref.invalidate(offlinePostRepoProvider);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(       
                    content: Text('Eliminar las entradas sin Conexion'.tr()),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(         //
                    content: Text('Fallo en eliminar las Entradas sin Conexion'.tr()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },            // 
            child: Text('Eliminar todo las entradas sin Conexion'.tr()),
          ),
        ],
      ),
    );
  }

  void _showStorageInfoDialog(
      BuildContext context, Map<String, dynamic> storageInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Informacion de Almacenamiento'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
                'Total de entradas'.tr(), '${storageInfo['postCount'] ?? 0}'),
            _buildInfoRow('storage_used'.tr(),
                '${storageInfo['totalSizeMB'] ?? '0.00'} MB'),
            _buildInfoRow('Almacenamiento Usado kb'.tr(),
                '${storageInfo['totalSizeKB'] ?? '0.00'} KB'),
            if (storageInfo['Ultima Actulizacion'] != null)
              _buildInfoRow(
                'lUltima Actulizacion'.tr(),
                _formatDate(storageInfo['lastUpdated']),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Guardar'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
