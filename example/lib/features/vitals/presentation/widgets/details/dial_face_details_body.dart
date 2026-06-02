import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/core/widgets/loading_overlay.dart';
import 'package:flutter_band_fit_app/core/widgets/vital_detail_scaffold.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/dial_face_details_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/dial/dial_face_catalog.dart';

class DialFaceDetailsBody extends GetView<DialFaceDetailsController> {
  const DialFaceDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        visible: controller.isInitializing.value,
        message: textDialFaces,
        subtitle: textDialFacesMsg,
        child: AccentTabDetailScaffold(
          title: textDialFaces,
          accentColor: Theme.of(context).colorScheme.primary,
          onBack: GlobalMethods.navigatePopBack,
          tabs: const [
            Tab(text: textRecommendDialFace),
            Tab(text: textSearchDialOnline),
          ],
          tabViews: [
            _DialGrid(
              items: recommendedDialFaces,
              onTap: (item) => _showDialDialog(context, item),
            ),
            Obx(
              () => _OnlineDialTab(
                items: controller.onlineDials.toList(),
                isLoading: controller.isLoadingOnline.value,
                hasLoadedOnce: controller.hasLoadedOnlineOnce.value,
                hasMore: controller.hasMoreOnline.value,
                onTap: (item) => _showDialDialog(context, item),
                onLoadMore: () => controller.loadOnlineDials(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialDialog(BuildContext context, BandDialModel item) async {
    controller.provider.updateDialSyncUI(false, false, false);
    if (!context.mounted) {
      return;
    }
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => GetBuilder<ActivityServiceProvider>(
        builder: (provider) {
          if (provider.isDialSyncDone) {
            Future<void>.delayed(Duration.zero, () {
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            });
          }
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
                  child: Text(
                    item.title,
                    style: Theme.of(dialogContext).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '${controller.formatCapacityKb(item.capacity)}   ${controller.formatDownloadCount(item.downloadNum)} $textDownloads',
                    style: Theme.of(dialogContext).textTheme.bodySmall,
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: item.preview,
                      width: 220,
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: provider.isDialSyncDone
                          ? Colors.lightGreen
                          : Theme.of(dialogContext).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (provider.isDialSyncDone) {
                        Navigator.of(dialogContext).pop();
                        return;
                      }
                      if (!provider.isDialDownloading &&
                          !provider.isDialSyncing) {
                        await controller.downloadAndSyncDial(item);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: _SyncButtonContent(provider: provider),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OnlineDialTab extends StatelessWidget {
  const _OnlineDialTab({
    required this.items,
    required this.isLoading,
    required this.hasLoadedOnce,
    required this.hasMore,
    required this.onTap,
    required this.onLoadMore,
  });

  final List<BandDialModel> items;
  final bool isLoading;
  final bool hasLoadedOnce;
  final bool hasMore;
  final void Function(BandDialModel item) onTap;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (!hasLoadedOnce || (isLoading && items.isEmpty)) {
      return const _DialLoadingState();
    }

    return Column(
      children: [
        Expanded(
          child: _DialGrid(
            items: items,
            onTap: onTap,
            emptyMessage: 'No online dial faces found for your device',
          ),
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(12),
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          )
        else if (hasMore)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextButton(
              onPressed: onLoadMore,
              child: const Text('Load more'),
            ),
          ),
      ],
    );
  }
}

class _DialLoadingState extends StatelessWidget {
  const _DialLoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            textDialFacesMsg,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}

class _SyncButtonContent extends StatelessWidget {
  const _SyncButtonContent({required this.provider});

  final ActivityServiceProvider provider;

  @override
  Widget build(BuildContext context) {
    if (provider.isDialDownloading ||
        provider.isDialSyncing ||
        provider.isDialSyncDone) {
      final label = provider.isDialDownloading
          ? '$textDownloadingFile...(${provider.getDialDownloadProgress})'
          : provider.isDialSyncDone
              ? textSyncDoneSuccess
              : '$textSynchronizing..(${provider.getSyncDialProgress})';
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (provider.isDialDownloading || provider.isDialSyncing)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          else
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
    return const Text(
      textSynchronousDial,
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}

class _DialGrid extends StatelessWidget {
  const _DialGrid({
    required this.items,
    required this.onTap,
    this.emptyMessage = 'No dial faces available',
  });

  final List<BandDialModel> items;
  final void Function(BandDialModel item) onTap;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.watch_outlined,
                size: 48,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 12),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.84,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _DialTile(
          item: item,
          onTap: () => onTap(item),
        );
      },
    );
  }
}

class _DialTile extends StatelessWidget {
  const _DialTile({
    required this.item,
    required this.onTap,
  });

  final BandDialModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.cardColor,
      elevation: 2,
      shadowColor: theme.shadowColor.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: item.preview,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => ColoredBox(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.35),
                    child: const Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => ColoredBox(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.35),
                    child: Icon(
                      Icons.watch_outlined,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
