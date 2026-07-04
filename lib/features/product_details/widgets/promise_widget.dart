import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';

class _PromiseEntry {
  final String label;
  final String? networkImageUrl;

  const _PromiseEntry({
    required this.label,
    this.networkImageUrl,
  });
}

class PromiseWidget extends StatelessWidget {
  const PromiseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final splashController = Provider.of<SplashController>(context, listen: false);
    final List<CompanyReliability>? reliabilityData = splashController.configModel?.companyReliability;
    List<_PromiseEntry> entries = [];

    if (reliabilityData != null && reliabilityData.isNotEmpty) {
      entries = reliabilityData.where((item) => item.status == 1).map((item) => _PromiseEntry(label: item.title ?? '', networkImageUrl: item.imageFullUrl?.path),
      ).toList();
    }

    if (entries.isEmpty) {
      return const SizedBox();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final count = entries.length;

    double itemWidth;

    if (count == 1) {
      itemWidth = screenWidth;
    } else if (count == 2) {
      itemWidth = screenWidth / 2;
    } else {
      itemWidth = (screenWidth - Dimensions.paddingSizeDefault * 2) / 3.3;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(entries.length * 2 - 1, (i) {
            if (i.isOdd) {
              return const SizedBox(width: Dimensions.paddingSizeDefault);
            }
            final index = i ~/ 2;

            return SizedBox(width: itemWidth, child: PromiseItem(entry: entries[index]));
          }),
        ),
      ),
    );
  }
}

class PromiseItem extends StatelessWidget {
  final _PromiseEntry entry;

  const PromiseItem({super.key, required this.entry});

  static const double iconSize = 30;

  @override
  Widget build(BuildContext context) {
    final imageWidget = entry.networkImageUrl != null &&
        entry.networkImageUrl!.isNotEmpty
        ? Image.network(
      entry.networkImageUrl!,
      width: iconSize,
      height: iconSize,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _placeholder(),
    ) : _placeholder();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: iconSize,
          height: iconSize,
          child: imageWidget,
        ),
        Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          child: Text(
            entry.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Image.asset(
      Images.placeholder,
      width: iconSize,
      height: iconSize,
      fit: BoxFit.contain,
    );
  }
}