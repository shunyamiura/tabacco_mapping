import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:tabacco_mapping/models/smoking_spot_model.dart';

import '../helpers/map_dialogs_helper.dart';
import '../helpers/map_location_helper.dart';
import '../providers/app_providers.dart';
import '../widgets/cookie_consent_banner.dart';
import '../widgets/map_error_card.dart';
import '../widgets/map_filter_chips.dart';
import '../widgets/map_header_bar.dart';
import '../widgets/map_loading_indicator.dart';
import '../widgets/placing_mode_controls.dart';
import '../widgets/placing_mode_crosshair.dart';
import '../widgets/smoking_spot_marker.dart';

/// マップメイン画面
/// flutter_map + OpenStreetMapで喫煙所を表示・追加・検索するアプリのメイン画面
class MapView extends ConsumerStatefulWidget {
  /// マップ画面を生成する
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  /// flutter_mapのコントローラー
  final _mapController = MapController();

  /// 現在の地図中心座標（初期値: 東京）
  LatLng _center = const LatLng(35.6812, 139.7671);

  /// 現在のズームレベル
  double _currentZoom = 14.0;

  /// 屋内のみ表示フィルター
  bool _filterIndoor = false;

  /// 屋外のみ表示フィルター
  bool _filterOutdoor = false;

  /// ピン設置モード中かどうか
  bool _isPlacingMode = false;

  @override
  void initState() {
    super.initState();
    // ウィジェット構築後に現在地へ移動してからデータを読み込む
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _moveToCurrentLocation();
      _loadSpots();
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// 現在地に地図を移動する
  /// 許可拒否や取得失敗の場合はデフォルト位置（東京）のまま継続する
  Future<void> _moveToCurrentLocation() async {
    final location = await MapLocationHelper.getCurrentLocation();
    if (location != null && mounted) {
      // 地図を現在地に移動
      setState(() => _center = location);
      _mapController.move(location, _currentZoom);
    }
  }

  /// 現在の地図位置周辺の喫煙所を読み込む
  void _loadSpots() {
    final radius = MapLocationHelper.calculateRadius(_currentZoom);
    ref
        .read(mapViewModelProvider.notifier)
        .loadSpotsNearby(
          latitude: _center.latitude,
          longitude: _center.longitude,
          radiusInKm: radius,
        );
  }

  /// 喫煙所マーカーのタップ処理
  ///
  /// [spot] タップされた喫煙所
  void _onMarkerTapped(SmokingSpotModel spot) {
    ref.read(mapViewModelProvider.notifier).selectSpot(spot);
    MapDialogsHelper.showSpotDetail(context, ref, spot);
  }

  /// ピン設置モードを開始する（ログイン確認付き）
  void _enterPlacingMode() {
    final user = ref.read(firebaseAuthProvider).valueOrNull;
    if (user == null) {
      MapDialogsHelper.showLoginRequiredDialog(context);
      return;
    }
    setState(() => _isPlacingMode = true);
  }

  /// ピン設置モードをキャンセルする
  void _cancelPlacingMode() {
    setState(() => _isPlacingMode = false);
  }

  /// 現在の中央座標で喫煙所追加ダイアログを表示する
  void _confirmPlacingPosition() {
    setState(() => _isPlacingMode = false);
    MapDialogsHelper.showAddSpotDialog(context, ref, _center);
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapViewModelProvider);
    final cookieConsent = ref.watch(cookieConsentNotifierProvider);

    return Scaffold(
      body: Stack(
        children: [
          // flutter_map（OpenStreetMap）
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: _currentZoom,
              // 長押しで喫煙所追加
              onLongPress:
                  (tapPosition, point) =>
                      MapDialogsHelper.showAddSpotDialog(context, ref, point),
              // カメラ移動完了時にデータ再取得
              onMapEvent: (event) {
                if (event is MapEventMoveEnd ||
                    event is MapEventFlingAnimationEnd ||
                    event is MapEventScrollWheelZoom) {
                  _center = event.camera.center;
                  _currentZoom = event.camera.zoom;
                  _loadSpots();
                }
              },
            ),
            children: [
              // OpenStreetMapタイルレイヤー（無料）
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.tabacco_mapping',
                // タイル読み込み失敗時の最大リトライ回数
                maxNativeZoom: 19,
              ),
              // 喫煙所マーカーレイヤー
              MarkerLayer(
                markers: SmokingSpotMarker.buildMarkers(
                  mapState.spots,
                  filterIndoor: _filterIndoor,
                  filterOutdoor: _filterOutdoor,
                  onMarkerTapped: _onMarkerTapped,
                ),
              ),
            ],
          ),

          // データ読み込み中インジケーター
          if (mapState.isLoading) const MapLoadingIndicator(),

          // 上部コントロールパネル（タイトル + 認証ボタン）
          MapHeaderBar(
            onLoginPressed: () => MapDialogsHelper.showAuthView(context),
          ),

          // フィルターチップ（右上）
          MapFilterChips(
            filterIndoor: _filterIndoor,
            filterOutdoor: _filterOutdoor,
            onIndoorChanged:
                (v) => setState(() {
                  _filterIndoor = v;
                  if (v) _filterOutdoor = false;
                }),
            onOutdoorChanged:
                (v) => setState(() {
                  _filterOutdoor = v;
                  if (v) _filterIndoor = false;
                }),
          ),

          // 現在地ボタン（右下）
          Positioned(
            bottom: cookieConsent ? 96 : 184,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: 'my_location',
              onPressed: () async {
                await _moveToCurrentLocation();
                _loadSpots();
              },
              tooltip: '現在地を表示',
              child: const Icon(Icons.my_location),
            ),
          ),

          // ピン設置モード: 画面中央に固定ピンを表示
          if (_isPlacingMode) const PlacingModeCrosshair(),

          // ピン設置モード: 確定・キャンセルボタン
          if (_isPlacingMode)
            PlacingModeControls(
              onCancel: _cancelPlacingMode,
              onConfirm: _confirmPlacingPosition,
            ),

          // Cookie同意バナー（未同意時に画面下部に表示）
          if (!cookieConsent)
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CookieConsentBanner(),
            ),

          // エラーメッセージバー
          if (mapState.errorMessage != null)
            MapErrorCard(
              message: mapState.errorMessage!,
              cookieConsent: cookieConsent,
              onDismiss: () {
                ref.read(mapViewModelProvider.notifier).clearError();
              },
            ),
        ],
      ),

      // 喫煙所追加FAB（設置モード中は非表示）
      floatingActionButton:
          _isPlacingMode
              ? null
              : FloatingActionButton.extended(
                heroTag: 'add_spot',
                onPressed: _enterPlacingMode,
                icon: const Icon(Icons.add_location_alt),
                label: const Text('追加'),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
    );
  }
}
