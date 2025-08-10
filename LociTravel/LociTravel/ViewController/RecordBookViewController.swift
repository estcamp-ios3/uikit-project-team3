//
//  RecordBookViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/9/25.
//
import UIKit

class RecordBookViewController: UIViewController {
    
    // MARK: - Properties

    private let recordBookView = RecordBookView()
    private let spots = SpotModel.shared.arrSpot

    // MARK: - Lifecycle

    override func loadView() {
        view = recordBookView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        // --- 퀘스트리스트와 동일하게 내비게이션 바를 커스텀합니다. ---
        setupNavBarAppearance()
        setupNavBarTitle()
        setupCustomBackButton()
        // ---------------------------------------------------
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - UI Setup
    
    private func setupTableView() {
        recordBookView.tableView.dataSource = self
        recordBookView.tableView.delegate = self
        recordBookView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Navigation Bar Setup (QuestListViewController 방식)

    private func setupNavBarAppearance() {
        let ap = UINavigationBarAppearance()
        ap.configureWithTransparentBackground()
        ap.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance = ap
        navigationController?.navigationBar.scrollEdgeAppearance = ap
    }

    private func setupNavBarTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "레코드북"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        navigationItem.titleView = titleLabel
    }
    
    private func setupCustomBackButton() {
        // 'backbutton' 이미지가 없을 경우 SF Symbol로 대체
        let image = UIImage(named: "backbutton") ?? UIImage(systemName: "chevron.left")

        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        let barItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barItem
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 32),
            button.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension RecordBookViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spots.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let spot = spots[indexPath.row]

        let backgroundImage = UIImage(named: "questlistviewcell")
        let backgroundImageView = UIImageView(image: backgroundImage)
        cell.backgroundView = backgroundImageView
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 3
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()

        let spotNameLabel: UILabel = {
            let label = UILabel()
            label.text = spot.spotName
            label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
            label.textColor = .black
            return label
        }()

        let spotSummaryLabel: UILabel = {
            let label = UILabel()
            label.text = spot.spotSummary
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = .black
            label.numberOfLines = 2
            return label
        }()

        stackView.addArrangedSubview(spotNameLabel)
        stackView.addArrangedSubview(spotSummaryLabel)

        cell.contentView.addSubview(stackView)
        
        let insetTop: CGFloat = 14
        let insetLeft: CGFloat = 24
        let insetRight: CGFloat = 18
        let insetBottom: CGFloat = 12

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: insetTop),
            stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: insetLeft),
            stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -insetRight),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: cell.contentView.bottomAnchor, constant: -insetBottom)
        ])

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSpot = spots[indexPath.row]
        let spotDetailVC = SpotDetailViewController()

        spotDetailVC.currentSpot = selectedSpot
        navigationController?.pushViewController(spotDetailVC, animated: true)
    }
}

#Preview {
    RecordBookViewController()
}
