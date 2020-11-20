//
//  BottomSheetViewController.swift
//  MakeItGreat
//


import UIKit

class BottomSheetViewController: UIViewController {
    
    var contentView: UIView = UIView() // trocar pela view especifica depois
    var viewModel: BottomSheetViewModel?
    weak var homeCoordinator: HomeCoordinator?
    

    init(viewModel: BottomSheetViewModel, homeCoordinator: HomeCoordinator) {
        self.viewModel = viewModel
        self.homeCoordinator = homeCoordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        
    }
    
    override func viewDidLoad() {
        
    }
}

