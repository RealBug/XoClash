import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    let minSize = NSSize(width: 400, height: 600)
    self.minSize = minSize
    
    if windowFrame.width < minSize.width || windowFrame.height < minSize.height {
      let newFrame = NSRect(
        x: windowFrame.origin.x,
        y: windowFrame.origin.y,
        width: max(windowFrame.width, minSize.width),
        height: max(windowFrame.height, minSize.height)
      )
      self.setFrame(newFrame, display: true)
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
