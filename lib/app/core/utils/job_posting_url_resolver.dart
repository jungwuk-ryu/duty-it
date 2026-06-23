import 'package:duty_it/app/core/enums/job_source_type.dart';
import 'package:duty_it/app/core/models/job_posting.dart';

const _work24MobileHost = 'm.work24.go.kr';
const _work24MobileDetailPath = '/wk/a/b/1500/empDetailAuthView.do';
const _work24DefaultInfoTypeCd = 'VALIDATION';
const _work24DefaultInfoTypeGroup = 'tb_workinfoworknet';

Uri? resolveJobPostingUri(JobPosting job) {
  final work24Uri = _resolveWork24MobileUri(job);
  if (work24Uri != null) return work24Uri;

  final rawUrl = job.postingUrl.trim();
  if (rawUrl.isEmpty) return null;

  final uri = Uri.tryParse(rawUrl);
  if (uri == null || !_hasWebScheme(uri) || uri.host.isEmpty) return null;

  return uri;
}

Uri? _resolveWork24MobileUri(JobPosting job) {
  final wantedAuthNo = job.wantedAuthNo.trim();
  if (wantedAuthNo.isEmpty) return null;

  if (job.sourceType != JobSourceType.work24) return null;

  final postingUri = Uri.tryParse(job.postingUrl.trim());

  return Uri.https(_work24MobileHost, _work24MobileDetailPath, {
    'wantedAuthNo': wantedAuthNo,
    'infoTypeCd':
        _firstNonEmpty(postingUri?.queryParameters['infoTypeCd']) ??
        _work24DefaultInfoTypeCd,
    'infoTypeGroup':
        _firstNonEmpty(postingUri?.queryParameters['infoTypeGroup']) ??
        _work24DefaultInfoTypeGroup,
  });
}

bool _hasWebScheme(Uri uri) {
  final scheme = uri.scheme.toLowerCase();
  return scheme == 'http' || scheme == 'https';
}

String? _firstNonEmpty(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
