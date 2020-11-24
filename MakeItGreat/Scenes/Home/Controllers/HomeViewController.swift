//
//  HomeViewController.swift
//  MakeItGreat
//


import UIKit

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel
    weak var homeCoordinator: HomeCoordinator?
    let contentView = HomeView()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    func setupTableView() {
        contentView.tasksTableView.delegate = self
        contentView.tasksTableView.dataSource = self
    }
}

// MARK: TableView Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}


// MARK: TableView DataSource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier) as? TaskCell else {
            return TaskCell()
        }
        
        return cell
    }
    
    func checkboxAction(_ cell: TaskCell) {
        
    }
}
