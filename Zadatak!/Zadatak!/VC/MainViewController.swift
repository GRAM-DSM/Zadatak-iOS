import UIKit

// MARK: MainViewController
final class MainViewController: UIViewController {
    
    var isLogin: Bool!
    private let ud = UserDefaults.standard
    private var data = [String]()
    private var totalTasks = 0
    private var doneTasks = 0
    
    @IBOutlet weak var chooseColorView: ChooseColorView!
    @IBOutlet weak var taskProgress: UIProgressView!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var hiddenBtn: UIButton!
    @IBOutlet weak var addTaskBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegate()
        setHidden(to: true)
        listTableView.tableFooterView = UIView.init(frame: .infinite)
        nickNameLbl.text = ud.string(forKey: "Name")
        let nibName = UINib(nibName: "TaskViewCell", bundle: nil)
        listTableView.register(nibName, forCellReuseIdentifier: "TaskViewCell")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisa(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        taskProgress.setProgress(0.0, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isLogin == true { return }
            if ud.string(forKey: "id") == nil {
                presentVC(identifier: "RegeisterVC")
        }
    }

    private func setDelegate() {
        listTableView.dataSource = self
        listTableView.delegate = self
        chooseColorView.delegate = self
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        data.append("")
        listTableView.reloadData()
        reloadTaskProgress()
        totalTasks += 1
    }
    
    @IBAction func showColorXib(_ sender: Any) {
        setHidden(to: false)
    }
    
    @IBAction func disMissNib(_ sender: UIButton) {
        setHidden(to: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ChooseColorViewDelegate {
    func setColor(color: UIColor) {
        taskProgress.tintColor = color
        settingBtn.tintColor = color
        addTaskBtn.tintColor = color
    }
    
    func logOut(value: Bool) {
        setHidden(to: value)
        ud.removeObject(forKey: "id")
        ud.removeObject(forKey: "pwd")
        presentVC(identifier: "RegeisterVC")
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            data.remove(at: indexPath.row)
            doneTasks += 1
            listTableView.deleteRows(at: [indexPath], with: .automatic)
            reloadTaskProgress()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "TaskViewCell", for: indexPath) as! TaskViewCell
        return cell
    }
    
    func reloadTaskProgress() {
        if totalTasks == 0 {
            taskProgress.progress = 0.0
        } else {
            taskProgress.progress = Float(doneTasks)/Float(totalTasks)
        }
    }
    
    func setHidden(to value: Bool) {
        chooseColorView.isHidden = value
        hiddenBtn.isHidden = value
    }
    
    func presentVC(identifier: String) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: identifier) else {return}
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150
    }
    
    @objc func keyboardWillDisa(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}
