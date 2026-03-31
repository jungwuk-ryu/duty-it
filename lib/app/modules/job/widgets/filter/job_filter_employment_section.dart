import 'package:duty_it/app/core/enums/job_employment_type.dart';
import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:duty_it/app/modules/search_filter/widgets/search_filter_section_title.dart';
import 'package:duty_it/app/widgets/app_radio_buttom.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class JobFilterEmploymentSection extends GetView<JobFilterViewController> {
  const JobFilterEmploymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SearchFilterSectionTitle('고용형태'),
        ...controller.employmentTypes.map(_buildEmploymentItem),
      ],
    );
  }

  Widget _buildEmploymentItem(JobEmploymentType type) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => controller.toggleEmploymentTypeSelection(type),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Obx(
              () => AppRadioButtom(
                checked: controller.isEmploymentTypeSelected(type),
                onTap: () {},
              ),
            ),
            const SizedBox(width: 8),
            Text(
              type.filterDisplayName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                height: 1.60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
