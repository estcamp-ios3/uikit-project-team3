//
//  SpotView.swift
//  TimeTravel
//
//  Created by chohoseo on 7/30/25.
//

import UIKit

enum Section {
    case heritage
    case mountain
    case leisure
}

struct SpotData {
    let name: String
    let detail: String
    let image: String
}

let arrHeritage: [SpotData] = [
    SpotData(name: "미륵사지", detail: "백제때 만들어진 탑", image: "mir"),
    SpotData(name: "왕궁리유적", detail: "", image: "wong"),
    SpotData(name: "", detail: "", image: ""),
]

let arrMountain: [SpotData] = [
    SpotData(name: "미륵산", detail: "", image: "mirmountain")
]

let arrLeisure: [SpotData] = [
    SpotData(name: "보석박물관", detail: "보석이 많다", image: "gemmuseum"),
    SpotData(name: "교도소 세트장", detail: "", image: "prison"),
    SpotData(name: "고스락", detail: "", image: "gosrack"),
]

var collectionViewSectionMap: [UICollectionView: Section] = [:]

class SpotView: UIViewController {
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = UIColor.systemGray6
        return scroll
    }()
    
    //섹션 라벨
    let heritageSectionLavel = UILabel()
    let mountainSectionLabel = UILabel()
    let leisureSectionLabel = UILabel()
    
    let contentStackView = UIStackView()
    
    // 횡스크롤 컬렉션 뷰
    func setupHorizontalScrollView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 160, height: 100)
        layout.minimumLineSpacing = 12
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    func setupUI() {
        // Scroll View
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Content Stack View
        scrollView.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
        
        //섹션 라벨 스타일
        [heritageSectionLavel, mountainSectionLabel, leisureSectionLabel].forEach {
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        
        // 관광명소 컬렉션 뷰 - 유적지
        heritageSectionLavel.text = "유적지"
        contentStackView.addArrangedSubview(heritageSectionLavel)
        heritageSectionLavel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        heritageSectionLavel.backgroundColor = .clear
        
        let heritageCollectionView = setupHorizontalScrollView()
        heritageCollectionView.register(SpotViewCell.self, forCellWithReuseIdentifier: "Cell")
        heritageCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        heritageCollectionView.dataSource = self
        heritageCollectionView.delegate = self
        collectionViewSectionMap[heritageCollectionView] = .heritage
        contentStackView.addArrangedSubview(heritageCollectionView)
        
        // 관광명소 컬렉션 뷰 - 산
        mountainSectionLabel.text = "산"
        contentStackView.addArrangedSubview(mountainSectionLabel)
        mountainSectionLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        mountainSectionLabel.backgroundColor = .clear
        
        let mountainCollectionView = setupHorizontalScrollView()
        mountainCollectionView.register(SpotViewCell.self, forCellWithReuseIdentifier: "Cell")
        mountainCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        mountainCollectionView.dataSource = self
        mountainCollectionView.delegate = self
        collectionViewSectionMap[mountainCollectionView] = .mountain
        contentStackView.addArrangedSubview(mountainCollectionView)
        
        // 관광명소 컬렉션 뷰 - 레져
        leisureSectionLabel.text = "레져"
        contentStackView.addArrangedSubview(leisureSectionLabel)
        leisureSectionLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        leisureSectionLabel.backgroundColor = .clear
        
        let leisureCollectionView = setupHorizontalScrollView()
        leisureCollectionView.register(SpotViewCell.self, forCellWithReuseIdentifier: "Cell")
        leisureCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        leisureCollectionView.dataSource = self
        leisureCollectionView.delegate = self
        collectionViewSectionMap[leisureCollectionView] = .leisure
        contentStackView.addArrangedSubview(leisureCollectionView)
    }
}

// MARK: - UICollectionView DataSource
extension SpotView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = collectionViewSectionMap[collectionView] else { return 0 }
        switch sectionType {
        case .heritage:
            return arrHeritage.count
        case .mountain:
            return arrMountain.count
        case .leisure:
            return arrLeisure.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SpotViewCell
        guard let sectionType = collectionViewSectionMap[collectionView] else { return cell }
        cell.configure(with: sectionType, index: indexPath.item)
        return cell
    }
}

extension SpotView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = collectionViewSectionMap[collectionView] else { return }
        let selectedData: SpotData
        switch section {
        case .heritage: selectedData = arrHeritage[indexPath.item]
        case .mountain: selectedData = arrMountain[indexPath.item]
        case .leisure: selectedData = arrLeisure[indexPath.item]
        }

        //let detailVC = SpotDetailView(spot: selectedData)
        //navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Channel Cell
class SpotViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let subLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let textStack = UIStackView(arrangedSubviews: [nameLabel, subLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        
        let horizontalStack = UIStackView(arrangedSubviews: [imageView, textStack])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.spacing = 12
        
        contentView.addSubview(horizontalStack)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with section: Section, index: Int) {
        switch section {
        case .heritage:
            nameLabel.text = arrHeritage[index].name
            subLabel.text = arrHeritage[index].detail
            imageView.image = UIImage(named: arrHeritage[index].image)
        case .mountain:
            nameLabel.text = arrMountain[index].name
            subLabel.text = arrMountain[index].detail
            imageView.image = UIImage(named: arrMountain[index].image)
        case .leisure:
            nameLabel.text = arrLeisure[index].name
            subLabel.text = arrLeisure[index].detail
            imageView.image = UIImage(named: arrLeisure[index].image)
        }
    }
}

#Preview {
    SpotView()
}
