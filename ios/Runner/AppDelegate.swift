import Flutter
import UIKit
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}

/// Exposes system layout geometry without replacing any Flutter UI.
@objc(DuitFlutterViewController)
class DuitFlutterViewController: FlutterViewController, FlutterStreamHandler {
  private var layoutChannel: FlutterEventChannel?
  private var layoutSink: FlutterEventSink?
  private var lastLayout: NSDictionary?
  private var layoutProbe: DuitLayoutProbe?

  override func viewDidLoad() {
    super.viewDidLoad()
    layoutChannel = FlutterEventChannel(
      name: "com.dutyit.app/layout", binaryMessenger: binaryMessenger)
    layoutChannel?.setStreamHandler(self)
    NotificationCenter.default.addObserver(
      self, selector: #selector(accessibilityAppearanceChanged),
      name: UIAccessibility.reduceTransparencyStatusDidChangeNotification, object: nil)
    if #available(iOS 27.1, *) {
      let probe = DuitLayoutProbe()
      probe.isUserInteractionEnabled = false
      probe.translatesAutoresizingMaskIntoConstraints = false
      probe.onGeometryChange = { [weak self] in self?.sendLayout() }
      view.addSubview(probe)
      NSLayoutConstraint.activate([
        probe.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        probe.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        probe.topAnchor.constraint(equalTo: view.topAnchor),
        probe.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
      layoutProbe = probe
      registerForTraitChanges(UITraitCollection.systemTraitsAffectingVerticalBarEdge) {
        (controller: DuitFlutterViewController, _: UITraitCollection) in
        controller.sendLayout()
      }
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    sendLayout()
  }

  override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()
    sendLayout()
  }

  override func viewLayoutMarginsDidChange() {
    super.viewLayoutMarginsDidChange()
    sendLayout()
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if #available(iOS 27.1, *), isDuo {
      return .allButUpsideDown
    }
    return super.supportedInterfaceOrientations
  }

  @available(iOS 27.1, *)
  private var isDuo: Bool {
    traitCollection.verticalBarEdge != .unspecified ||
      !view.reservedRegions(kind: .division, options: .includeInactive).isEmpty
  }

  private func sendLayout() {
    guard let sink = layoutSink, isViewLoaded else { return }
    var payload: [String: Any] = [
      "isDuo": false, "divisions": [],
      "reduceTransparency": UIAccessibility.isReduceTransparencyEnabled
    ]
    let margins = view.layoutMargins
    payload["layoutMargins"] = [
      "top": margins.top, "left": margins.left,
      "bottom": margins.bottom, "right": margins.right
    ]
    if #available(iOS 27.1, *) {
      let geometryView = layoutProbe ?? view!
      payload["isDuo"] = traitCollection.verticalBarEdge != .unspecified ||
        !geometryView.reservedRegions(kind: .division, options: .includeInactive).isEmpty
      // Hardware edge stays fixed in right-to-left locales too.
      switch traitCollection.verticalBarEdge {
      case .leading: payload["verticalBarEdge"] = "left"
      case .trailing: payload["verticalBarEdge"] = "right"
      default: break
      }
      payload["divisions"] = geometryView.reservedRegions(kind: .division)
        .filter { $0.isActive }
        .map { region in
          ["x": region.frame.minX, "y": region.frame.minY,
           "width": region.frame.width, "height": region.frame.height]
        }
      var obstructions = geometryView.reservedRegions(kind: .occlusion)
        .filter { $0.isActive }.map { $0.frame }
      if let scene = view.window?.windowScene,
         let statusBar = scene.statusBarManager?.statusBarFrame,
         !statusBar.isEmpty {
        let statusFrame = geometryView.convert(statusBar, from: scene.coordinateSpace)
        obstructions.append(statusFrame)
      }
      payload["obstructions"] = obstructions.map { frame in
        ["x": frame.minX, "y": frame.minY,
         "width": frame.width, "height": frame.height]
      }
    }
    let snapshot = payload as NSDictionary
    guard snapshot != lastLayout else { return }
    lastLayout = snapshot
    sink(payload)
  }

  @objc private func accessibilityAppearanceChanged() { sendLayout() }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    layoutSink = events
    lastLayout = nil
    layoutProbe?.setNeedsUpdateConstraints()
    sendLayout()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    layoutSink = nil
    lastLayout = nil
    return nil
  }
}

/// Querying in updateConstraints lets UIKit track fold-only geometry changes.
private class DuitLayoutProbe: UIView {
  var onGeometryChange: (() -> Void)?
  override func updateConstraints() {
    onGeometryChange?()
    super.updateConstraints()
  }
}
