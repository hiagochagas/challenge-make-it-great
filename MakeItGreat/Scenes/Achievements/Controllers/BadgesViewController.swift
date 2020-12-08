//
//  BadgesViewController.swift
//  MakeItGreat
//

import UIKit

class BadgesViewController: UIViewController {
    let contentView = BadgesCollectionView()
    let model = AchievementsViewModel(context: AppDelegate.viewContext)
    var badges: [Badge]?
    
    override func loadView() {
        view = contentView
        badges = model.badges
    }
    
    override func viewDidLoad() {
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
    }
    
    func reloadBadgesData() {
        model.badges?.forEach({
            _ = model.updateBadgeProgress(badge: $0, progress: $0.progress + 1, viewContext: AppDelegate.viewContext)
        })
        contentView.collectionView.reloadData()
    }
}

extension BadgesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let badge = badges?[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badgeCollectionViewCell", for: indexPath) as! BadgeCollectionViewCell
        if(badge?.progress ?? 0 >= badge?.unlockValue ?? 0) {
            //when reloaded, changes the image to done
            let value = badge!.unlockValue
            badge!.icon = UIImage(named: "\(value)TasksDone")?.pngData()
            model.save(context: AppDelegate.viewContext)
        }
        cell.badgeImageView.image = UIImage(data: badge?.icon ?? Data())
        cell.tasksDoneLabel.text = badge?.descriptionBadge
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.2, height: collectionView.frame.height/3)
    }
    
    
}
