//
//  BottomSheetViewController.swift
//  MakeItGreat
//


import UIKit


class BottomSheetViewController: UIViewController {
    let lists = ["Next", "Inbox", "Waiting", "Projects", "Maybe"]
    var task: Task?
    var contentView: UIView = UIView() // trocar pela view especifica depois
    var viewModel: BottomSheetViewModel?
    weak var homeCoordinator: HomeCoordinator?
    
    
    //    init(viewModel: BottomSheetViewModel, homeCoordinator: HomeCoordinator, view: BottomSheetView) {
    //        self.viewModel = viewModel
    //        self.homeCoordinator = homeCoordinator
    //        super.init(nibName: nil, bundle: nil)
    //        self.view = view
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        super.init(coder: coder)
    //    }
    
    override func loadView() {
        let bottomView = BottomSheetView()
        bottomView.viewController = BottomSheetViewController()
        bottomView.saveButton.target(forAction: #selector(saveButton), withSender: self)
        //        bottomView.listPicker.dataSource = self
        //        bottomView.listPicker.delegate = self
        self.view = bottomView
        
    }
    
    override func viewDidLoad() {
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared(notification:)), name: .expandModal, object: nil)
    }
//    @objc func keyboardAppeared(notification: NSNotification){
//        // expand view
//    }
    
    @objc func saveButton() {
        // save task
        // dismiss modal
        self.dismiss(animated: true) {
        }
    }
    
    @objc func cancelButton() {
        // dismiss modal
    }
    
}

extension BottomSheetViewController: UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        lists.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10.0)
        label.textColor = UIColor.purple
        label.text =  lists[row]
        label.textAlignment = .left
        return NSAttributedString(string: label.text ?? "a")
    }
    
}

extension Notification.Name {
    static let expandModal = Notification.Name("expandModal")
    
}

