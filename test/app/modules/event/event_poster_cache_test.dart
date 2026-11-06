import 'dart:io' as io;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/modules/event/views/event_poster_viewer.dart';
import 'package:file/file.dart' as file;
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class _PosterFileSystem implements FileSystem {
  _PosterFileSystem(this.directory);
  final io.Directory directory;

  @override
  Future<file.File> createFile(String name) async =>
      const LocalFileSystem().file(directory.uri.resolve(name));
}

Future<void> _pumpUntil(WidgetTester tester, Finder finder) async {
  // Local file I/O and image decoding run outside the fake frame clock.
  final deadline = Stopwatch()..start();
  while (!tester.any(finder) && deadline.elapsed < const Duration(seconds: 5)) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump(const Duration(milliseconds: 10));
  }
  expect(finder, findsOneWidget);
}

void main() {
  testWidgets('retry replaces a corrupt poster in its configured disk cache', (
    tester,
  ) async {
    const url = 'https://example.invalid/poster.png';
    const key = 'event-poster';
    late io.Directory directory;
    late CacheManager cache;
    var downloads = 0;

    await tester.runAsync(() async {
      directory = await io.Directory.systemTemp.createTemp('duit-poster-');
      final png = await rootBundle.load('assets/icons/paper.png');
      cache = CacheManager(
        Config(
          'posters',
          repo: JsonCacheInfoRepository(path: '${directory.path}/cache.json'),
          fileSystem: _PosterFileSystem(directory),
          fileService: HttpFileService(
            httpClient: MockClient((request) async {
              expect(request.url.toString(), url);
              downloads++;
              return http.Response.bytes(
                png.buffer.asUint8List(png.offsetInBytes, png.lengthInBytes),
                200,
                headers: {'content-type': 'image/png'},
              );
            }),
          ),
        ),
      );
      await cache.putFile(url, Uint8List.fromList([0, 1, 2]), key: key);
    });
    try {
      await tester.pumpWidget(
        MaterialApp(
          home: EventPosterViewer(
            image: CachedNetworkImageProvider(
              url,
              cacheKey: key,
              cacheManager: cache,
            ),
            title: '행사',
            host: '',
          ),
        ),
      );
      await _pumpUntil(tester, find.text('다시 시도'));
      expect(downloads, 0);
      await tester.tap(find.text('다시 시도'));
      await _pumpUntil(tester, find.byType(InteractiveViewer));
      expect(downloads, 1);
    } finally {
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(() async {
        await cache.dispose();
        await directory.delete(recursive: true);
      });
    }
  });
}
