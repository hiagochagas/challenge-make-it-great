//
//  HomeView.swift
//  MakeItGreat
//
//  Created by Tales Conrado on 20/11/20.
//

import UIKit

class HomeView: UIView, ViewCode {    
    
    let tasksTableView: UITableView = {
        let tbv = UITableView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        return tbv
    }()

    
    lazy var listsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupTableView() {
        
        tasksTableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
        tasksTableView.separatorStyle = .none
    }
    
    private func setupCollectionView() {
        
        listsCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "listCollectionViewCell")
    }
    
    func setViewHierarchy() {
        
        addSubview(tasksTableView)
        addSubview(listsCollectionView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            listsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            listsCollectionView.heightAnchor.constraint(equalToConstant: 50),
            listsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            listsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tasksTableView.topAnchor.constraint(equalTo: listsCollectionView.bottomAnchor, constant: 0),
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCollectionViewCell", for: indexPath)
        
        return cell
    }
}

extension HomeView: UICollectionViewDelegate {
    
    
}


extension HomeView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height)
    }
    
}
