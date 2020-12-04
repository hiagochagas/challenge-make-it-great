//
//  OnboardingView.swift
//  MakeItGreat
//
//  Created by Jéssica Araujo on 04/12/20.
//

import Foundation
import UIKit


class OnboardingView: UIView, ViewCode {
    
    let scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    let pageControl: UIPageControl = {
        
        let pageControl = UIPageControl()
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = 6
        pageControl.currentPageIndicatorTintColor = .blueActionColor
        pageControl.pageIndicatorTintColor =  .blueSecondaryColor
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    let getStartedButton: UIButton = {
        
        let button =  UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(.blueActionColor, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blueActionColor.cgColor
        button.layer.cornerRadius = 10

        return button
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setViewHierarchy() {
        
        self.addSubview(scrollView)
        self.addSubview(pageControl)
        self.addSubview(getStartedButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -15),
            
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            
            getStartedButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            getStartedButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -45),
            getStartedButton.heightAnchor.constraint(equalToConstant: 35),
            getStartedButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
}
