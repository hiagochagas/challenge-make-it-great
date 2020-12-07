//
//  HomeView.swift
//  MakeItGreat
//
//  Created by Tales Conrado on 20/11/20.
//

import UIKit

protocol HomeViewDelegate: class {
    
    func changeCurrentListView(list: EnumLists, shouldShowProjects: Bool)
}


class HomeView: UIView, ViewCode {    
    
    let listName = ["Next", "Inbox", "Maybe", "Waiting", "Projects"]
    
    let tasksTableView: UITableView = {
        let tbv = UITableView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        return tbv
    }()
    
    weak var delegate: HomeViewDelegate?
    
    var collectionViewIndexPaths: [IndexPath] = []

    lazy var listsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .grayBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHomeView()
        setupViewCode()
        setupTableView()
        setupCollectionView()
    }
    
    private func setupHomeView() {
        
        self.backgroundColor = .grayBackground
        setupDismissKeyboard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupTableView() {
        
        tasksTableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
        tasksTableView.separatorStyle = .none
    }
    
    private func setupDismissKeyboard() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    private func setupCollectionView() {
        
        listsCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "listCollectionViewCell")
    }
    
    @objc func hideKeyboard() {
        self.endEditing(true)
    }
    
    func setViewHierarchy() {
    
        addSubview(listsCollectionView)
        addSubview(tasksTableView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            listsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            listsCollectionView.heightAnchor.constraint(equalToConstant: 70),
            listsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            listsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tasksTableView.topAnchor.constraint(equalTo: listsCollectionView.bottomAnchor, constant: -7),
            tasksTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tasksTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tasksTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
}

extension HomeView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCollectionViewCell", for: indexPath) as? ListCollectionViewCell else { return ListCollectionViewCell() }
        
        cell.setListNameLabel(listName[indexPath.item])
        collectionViewIndexPaths.append(indexPath)
        
        
        if indexPath.item == 1 {
            
            cell.selectCell()
            
        } else {
            
            cell.deselectCell()
        }
        
        
        return cell
    }
}

extension HomeView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var listOfIndexsToDeselected = [IndexPath]()
        
        for index in collectionViewIndexPaths {
            if index != indexPath {
                
                listOfIndexsToDeselected.append(index)
            }
        }
        
        switch indexPath.item {
        
        case 0:
            
            delegate?.changeCurrentListView(list: .Next, shouldShowProjects: false)
            selectCollectionViewCell(at: indexPath)
            deselectItemsCollectionViewCell(at: listOfIndexsToDeselected)

        case 1:
            
            delegate?.changeCurrentListView(list: .Inbox, shouldShowProjects: false)
            selectCollectionViewCell(at: indexPath)
            deselectItemsCollectionViewCell(at: listOfIndexsToDeselected)
            
        case 2:
            
            delegate?.changeCurrentListView(list: .Maybe, shouldShowProjects: false)
            selectCollectionViewCell(at: indexPath)
            deselectItemsCollectionViewCell(at: listOfIndexsToDeselected)
            
        case 3:
            delegate?.changeCurrentListView(list: .Waiting, shouldShowProjects: false)
            selectCollectionViewCell(at: indexPath)
            deselectItemsCollectionViewCell(at: listOfIndexsToDeselected)
            
        case 4:
            
            delegate?.changeCurrentListView(list: .Inbox, shouldShowProjects: true)
            selectCollectionViewCell(at: indexPath)
            deselectItemsCollectionViewCell(at: listOfIndexsToDeselected)
            
        default:
            tasksTableView.backgroundColor = .cyan
        }
    }
    
    func selectCollectionViewCell(at indexPath: IndexPath) {
        
        guard let cell = listsCollectionView.cellForItem(at: indexPath) as? ListCollectionViewCell else { return }
    
        cell.selectCell()
    }
    
    func deselectItemsCollectionViewCell(at indexPaths: [IndexPath]) {
        
        for index in indexPaths {
            
            guard let cell = listsCollectionView.cellForItem(at: index) as? ListCollectionViewCell else { return }
            
            cell.deselectCell()
        }
    }
}


extension HomeView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height)
    }
    
}
