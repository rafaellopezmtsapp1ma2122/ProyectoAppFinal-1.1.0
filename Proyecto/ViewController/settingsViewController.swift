

import UIKit

class settingsViewController: UIViewController {
    
    static var finalTheme = "dark"
    
    let userDefaults = UserDefaults.standard
    let OnOff = "OnOff"
    let themekey = "themekey"
    let dark = "dark"
    let light = "light"
   
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var themes: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userDefaults.string(forKey: themekey))
        updateTheme()

        
    }
    
    
    
    func updateTheme(){
        let tema = userDefaults.string(forKey: themekey)
        if tema == dark{
            themes.selectedSegmentIndex = 0
            view.backgroundColor = settingsViewController.getUIColor(hex: "#3A4043")
            settingsViewController.finalTheme = "dark"
        }
        else if tema == light {
            themes.selectedSegmentIndex = 1
            view.backgroundColor = settingsViewController.getUIColor(hex: "#71787C")
            settingsViewController.finalTheme = "light"
        }
    }
    
    
    @IBAction func themeSaved(_ sender: Any) {
        switch themes.selectedSegmentIndex{
        case 0: userDefaults.set(dark, forKey: themekey)
            updateTheme()
        case 1: userDefaults.set(light, forKey: themekey)
            updateTheme()
        default: userDefaults.set(dark, forKey: themekey)
        }
    }
    
    static func getUIColor(hex: String, alpha: Double = 1.0) -> UIColor? {
        var cleanString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cleanString.hasPrefix("#")) {
            cleanString.remove(at: cleanString.startIndex)
        }

        if ((cleanString.count) != 6) {
            return nil
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cleanString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
