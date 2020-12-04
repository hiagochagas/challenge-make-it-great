//
//  OnboardingViewController.swift
//  MakeItGreat
//
//  Created by Jéssica Araujo on 04/12/20.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {
    
    let onboardingView =  OnboardingView()
    
    var scrollWidth: CGFloat = 0.0
    var scrollHeight: CGFloat = 0.0
    
    let descriptionList = [
        
    "Atarefados",
    "Adicione na lista Inbox tudo o que vier á mente. Escreva tarefas, ideias, tudo que que estiver em sua cabeça.",
    "Adicione na lista Maybe tarefas que você poderá fazer um dia, quem sabe mas que não devem ser esquecidas.",
    "Mova para a lista Next tarefas que indicam os seus próximos passos. ",
    "Crie noves projetos e adicione tarefas á esses projetos usando a lista Projects.",
    "Tarefas que dependem de outras pessoas para serem conclúidas ficam na lista Waiting."
    ]
    
    override func viewDidLayoutSubviews() {
        
        scrollWidth = onboardingView.scrollView.frame.size.width
        scrollHeight = onboardingView.scrollView.frame.size.height
        
        setupViewController()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    private func setupViewController() {
        
        self.view = onboardingView
        
        setupScrollView()
        setupPageControl()
    }
    
    private func setupScrollView() {
        
        onboardingView.scrollView.delegate = self
        
        onboardingView.scrollView.contentSize = CGSize(width: scrollWidth*CGFloat(descriptionList.count), height: scrollHeight)
        onboardingView.scrollView.contentSize.height = 1.0
        
        setupSlider()
    }
    
    func setupSlider() {
        
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        for pageSlide in 0..<descriptionList.count {
            
            frame.origin.x =  scrollWidth * CGFloat(pageSlide)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)
            
            let slide = UIView(frame: frame)
            slide.backgroundColor = .clear
        
            let descriptionSlide = setupDescriptionLabel(at: pageSlide)
            
            slide.addSubview(descriptionSlide)
            
            onboardingView.scrollView.addSubview(slide)
        }
    }
    
    func setupDescriptionLabel(at index: Int) -> UILabel {
        
        let label = UILabel.init(frame: CGRect(x: 32, y: scrollHeight/2 - 150, width: scrollWidth-64, height: 90))
        
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.text = descriptionList[index]
        
        return label
    }
    
    func setupPageControl() {
    
        onboardingView.pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
    }
    
    @objc func pageChanged() {
        
        onboardingView.scrollView.scrollRectToVisible(CGRect(x: scrollWidth *  CGFloat(onboardingView.pageControl.currentPage), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        setIndicatorForCurrentPage()
    }
    
    func setIndicatorForCurrentPage() {
        
        let currentSlidePage = (onboardingView.scrollView.contentOffset.x)/scrollWidth
        onboardingView.pageControl.currentPage  = Int(currentSlidePage)
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    
    
}
