//
//  ViewController.swift
//  SeeMoreTextView
//
//  Created by Salman Biljeek on 12/27/22.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(self.textView)
        self.textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        self.textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        self.view.addSubview(self.seeMoreButton)
        self.seeMoreButton.trailingAnchor.constraint(equalTo: self.textView.trailingAnchor).isActive = true
        self.seeMoreButton.bottomAnchor.constraint(equalTo: self.textView.bottomAnchor).isActive = true
        
        self.view.addSubview(self.separatorView)
        self.separatorView.leadingAnchor.constraint(equalTo: self.textView.leadingAnchor).isActive = true
        self.separatorView.trailingAnchor.constraint(equalTo: self.textView.trailingAnchor).isActive = true
        self.separatorView.bottomAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: 10).isActive = true
        
        let resetButton: UIButton = {
            var configuration = UIButton.Configuration.filled()
            var container = AttributeContainer()
            container.font = .boldSystemFont(ofSize: 18)
            container.foregroundColor = .systemBackground
            configuration.attributedTitle = AttributedString("Reset", attributes: container)
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25)
            configuration.baseBackgroundColor = .label
            configuration.cornerStyle = .capsule
            
            let button = UIButton(configuration: configuration, primaryAction: nil)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(self.handleReset), for: .touchUpInside)
            return button
        }()
        
        self.view.addSubview(resetButton)
        resetButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        resetButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.seeMoreButtonGradientLayer.frame = self.seeMoreButton.bounds
        let seeMoreButtonGradientColor = [UIColor.systemBackground.withAlphaComponent(0).cgColor, UIColor.systemBackground.cgColor]
        self.seeMoreButtonGradientLayer.colors = seeMoreButtonGradientColor
        
        let isTextTruncated = self.textView.isTextTruncated
        self.seeMoreButton.isHidden = !isTextTruncated
    }
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "This is a text view that spans multiple lines. In this guide you'll learn how to show the first 2 lines initially with a more button attached to the end. Upon tapping the more button, the text view height should expand with animation to the correct height to show the rest of the text."
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .label
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isSelectable = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byTruncatingTail
        self.textViewHeightConstraint = textView.heightAnchor.constraint(lessThanOrEqualToConstant: 39)
        self.textViewHeightConstraint.isActive = true
        return textView
    }()
    var textViewHeightConstraint: NSLayoutConstraint!
    let seeMoreButtonGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0.0, 0.4]
        let angle = (CGFloat.pi / 2) * 3
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        return gradientLayer
    }()
    lazy var seeMoreButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = .boldSystemFont(ofSize: 16)
        container.foregroundColor = .link
        configuration.contentInsets = .init(top: 1, leading: 35, bottom: 1, trailing: 0.01)
        configuration.attributedTitle = AttributedString("more", attributes: container)
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(self.handleSeeMore), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.insertSublayer(self.seeMoreButtonGradientLayer, below: button.imageView?.layer)
        return button
    }()
    
    @objc fileprivate func handleSeeMore() {
        let contentSize = self.textView.sizeThatFits(self.textView.bounds.size)
        self.textViewHeightConstraint.constant = contentSize.height
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            
            // if the textView is in a collectionView cell, here you need to call layoutIfNeeded() on the cell and then:
            
            // - if using regular collectionView:
            // collectionViewController.collectionView.collectionViewLayout.invalidateLayout()
            
            // - or if using compositional layout and diffable data source:
            // let snapshot = collectionViewController.diffableDataSource.snapshot()
            // collectionViewController.diffableDataSource.apply(snapshot, animatingDifferences: true)
        }
        seeMoreButton.isHidden = true
    }
    
    @objc fileprivate func handleReset() {
        self.textViewHeightConstraint.constant = 39
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            let isTextTruncated = self.textView.isTextTruncated
            self.seeMoreButton.isHidden = !isTextTruncated
        }
    }
}

extension UITextView {
    var isTextTruncated: Bool {
        var isTruncating = false
        
        // The `truncatedGlyphRange(...) method will tell us if text has been truncated
        // based on the line break mode of the text container
        layoutManager.enumerateLineFragments(forGlyphRange: NSRange(location: 0, length: Int.max)) { _, _, _, glyphRange, stop in
            let truncatedRange = self.layoutManager.truncatedGlyphRange(inLineFragmentForGlyphAt: glyphRange.lowerBound)
            if truncatedRange.location != NSNotFound {
                isTruncating = true
                stop.pointee = true
            }
        }
        
        // It's possible that the text is truncated not because of the line break mode,
        // but because the text is outside the drawable bounds
        if isTruncating == false {
            let glyphRange = layoutManager.glyphRange(for: textContainer)
            let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
            
            let totalTextCount = text.utf16.count
            isTruncating = characterRange.upperBound < totalTextCount
        }
        
        return isTruncating
    }
}
