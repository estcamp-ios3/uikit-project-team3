//
//  Untitled.swift
//  TimeTravel
//
//  Created by suji chae on 8/4/25.
//

import UIKit

// 전체 화면 이미지 갤러리 뷰 컨트롤러
class ImageGalleryViewController: UIViewController {

    let images: [String]
    var currentIndex: Int
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let leftArrow: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let rightArrow: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let pageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(images: [String], initialIndex: Int) {
        self.images = images
        self.currentIndex = initialIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupLayout()
        loadImages()
        
        DispatchQueue.main.async {
            self.scrollView.contentOffset.x = self.view.frame.width * CGFloat(self.currentIndex)
            self.updateUI()
        }
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        view.addSubview(leftArrow)
        view.addSubview(rightArrow)
        view.addSubview(pageLabel)
        
        scrollView.delegate = self
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        leftArrow.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            leftArrow.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            leftArrow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            leftArrow.widthAnchor.constraint(equalToConstant: 44),
            leftArrow.heightAnchor.constraint(equalToConstant: 44),
            
            rightArrow.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            rightArrow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            rightArrow.widthAnchor.constraint(equalToConstant: 44),
            rightArrow.heightAnchor.constraint(equalToConstant: 44),
            
            pageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func loadImages() {
        let containerWidth = self.view.frame.width
        for (index, imageName) in images.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: imageName)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            scrollView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(index) * containerWidth),
                imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
        }
        scrollView.contentSize = CGSize(width: containerWidth * CGFloat(images.count), height: view.frame.height)
    }
    
    private func updateUI() {
        pageLabel.text = "\(currentIndex + 1) / \(images.count)"
        leftArrow.isHidden = (currentIndex == 0)
        rightArrow.isHidden = (currentIndex == images.count - 1)
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func leftArrowTapped() {
        let newIndex = max(0, currentIndex - 1)
        scrollToPage(index: newIndex)
    }
    
    @objc private func rightArrowTapped() {
        let newIndex = min(images.count - 1, currentIndex + 1)
        scrollToPage(index: newIndex)
    }
    
    private func scrollToPage(index: Int) {
        let xOffset = self.view.frame.width * CGFloat(index)
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
}

extension ImageGalleryViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        currentIndex = page
        updateUI()
    }
}
