import SwiftUI
import AppKit
import CoreServices
import CoreImage

@main
struct browseraApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {}
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    var statusItem: NSStatusItem?
    var menu: NSMenu!
    var appIcon: NSImage?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Get a generic browser icon and convert it to monochrome
        if let genericIcon = NSImage(named: NSImage.networkName) {
            appIcon = convertToMonochrome(genericIcon)
        }
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.image = appIcon?.resized(to: NSSize(width: 18, height: 18))
        
        menu = NSMenu()
        menu.delegate = self
        statusItem?.menu = menu
        
        updateBrowserList()
    }
    
    func updateBrowserList() {
        menu.removeAllItems()
        
        let browserBundleIDs = [
            "com.apple.Safari",
            "com.google.Chrome",
            "org.mozilla.firefox",
            "com.microsoft.edgemac",
            "com.operasoftware.Opera"
        ]
        
        for bundleID in browserBundleIDs {
            if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID),
               let bundle = Bundle(url: appURL),
               let name = bundle.infoDictionary?["CFBundleName"] as? String {
                let menuItem = NSMenuItem(title: name, action: #selector(setBrowserAsDefault(_:)), keyEquivalent: "")
                menuItem.representedObject = bundleID
                let icon = NSWorkspace.shared.icon(forFile: appURL.path)
                let monochromeIcon = convertToMonochrome(icon)
                monochromeIcon.size = NSSize(width: 16, height: 16)
                menuItem.image = monochromeIcon
                menu.addItem(menuItem)
            }
        }
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "About", action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }
    
    func convertToMonochrome(_ image: NSImage) -> NSImage {
        guard let tiffData = image.tiffRepresentation,
              let ciImage = CIImage(data: tiffData) else {
            return image // Return original image if conversion fails
        }
        
        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0, forKey: kCIInputSaturationKey) // Set saturation to 0 for monochrome
        
        guard let outputCIImage = filter.outputImage else {
            return image // Return original image if filter fails
        }
        
        let rep = NSCIImageRep(ciImage: outputCIImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        
        return nsImage
    }
    
    @objc func setBrowserAsDefault(_ sender: NSMenuItem) {
        guard let bundleID = sender.representedObject as? String else { return }
        
        let schemes = ["http", "https"]
        for scheme in schemes {
            LSSetDefaultHandlerForURLScheme(scheme as CFString, bundleID as CFString)
        }
        
        print("Attempted to set default browser to \(sender.title)")
    }
    
    @objc func showAbout() {
        let alert = NSAlert()
        alert.messageText = "Browser Selector"
        alert.informativeText = "Marat Galiev, 2024\nhttps://maratgaliev.com"
        alert.addButton(withTitle: "OK")
        
        // Set the app icon
        if let iconImage = appIcon {
            alert.icon = iconImage.resized(to: NSSize(width: 64, height: 64))
        }
        
        alert.runModal()
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        updateBrowserList()
    }
}

extension NSImage {
    func resized(to newSize: NSSize) -> NSImage {
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        self.draw(in: NSRect(origin: .zero, size: newSize),
                  from: NSRect(origin: .zero, size: size),
                  operation: .copy,
                  fraction: 1.0)
        newImage.unlockFocus()
        return newImage
    }
}
