import UIKit

class ChooseColorView: UIView { 
    
    var delegate: sendColorDelegate!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var colorInfoLabel: UILabel!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var redColorBtn: UIButton!
    @IBOutlet weak var blueColorBtn: UIButton!
    @IBOutlet weak var greenColorBtn: UIButton!
    @IBOutlet weak var blackColorBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commitInit()
    }
    
    
    
    func commitInit() {
        guard let xibName = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last else { return }
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        view.makeShadow()
        self.addSubview(view)
    }
    
    @IBAction func logOut() {
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "pw")
        // StartView로 이동
    }
    
    @IBAction func chooseColor(_ sender: UIButton) {
        let color = sender.currentTitleColor
        delegate?.pickColor(data: color)
    }
}

protocol sendColorDelegate { func pickColor(data: UIColor) }