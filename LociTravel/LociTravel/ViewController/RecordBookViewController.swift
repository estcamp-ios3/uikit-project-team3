//
//  RecordBookViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/9/25.
//

import UIKit

class RecordBookViewController: UIViewController {

    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "레코드북"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        return tableView
    }()

    private let historicalSites = [
        ("미륵사지", "서동과 선화공주의 사랑 이야기가 깃든 백제 최대의 사찰 터"),
        ("왕궁리 5층 석탑", "백제 왕궁 후원의 정원 유적"),
        ("보석박물관", "다양한 희귀 보석과 광물을 전시하는 아름다운 박물관")
    ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(titleLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Table View Constraints
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension RecordBookViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historicalSites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let site = historicalSites[indexPath.row]
        
        // Customizing the cell to match the image layout
        cell.selectionStyle = .none
        
        let mainTextLabel = UILabel()
        mainTextLabel.text = site.0
        mainTextLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        let detailTextLabel = UILabel()
        detailTextLabel.text = site.1
        detailTextLabel.font = UIFont.systemFont(ofSize: 14)
        detailTextLabel.textColor = .systemGray
        detailTextLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [mainTextLabel, detailTextLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let statusLabel = UILabel()
        statusLabel.text = "진행 중"
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        statusLabel.textColor = .white
        statusLabel.backgroundColor = .systemYellow
        statusLabel.layer.cornerRadius = 10
        statusLabel.clipsToBounds = true
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textAlignment = .center
        
        let containerView = UIView()
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(stackView)
        containerView.addSubview(statusLabel)
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            statusLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statusLabel.widthAnchor.constraint(equalToConstant: 70),
            statusLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

#Preview {
    RecordBookViewController()
}
