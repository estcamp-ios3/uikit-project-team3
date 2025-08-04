//
//  RegionSelectionViewController.swift
//  TimeTravel
//
//  Created by dkkim on 7/31/25.
//
// 지역 선택 하는 뷰 컨트롤러
import UIKit

class RegionSelectionViewController: UIViewController {
  private let regions: [String]
  var didSelectRegion: ((Int) -> Void)?
    // 🔧 1) 내 근처 선택 시 호출할 콜백 추가
    var didSelectRegionForNearby: (() -> Void)?

  private let tableView = UITableView()

  init(regions: [String]) {
    self.regions = regions
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) { fatalError() }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "지역 선택"
    view.backgroundColor = .systemBackground
    navigationItem.rightBarButtonItem =
      UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
    setupTableView()
  }

  private func setupTableView() {
    tableView.frame = view.bounds
    tableView.dataSource = self
    tableView.delegate   = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    view.addSubview(tableView)
  }

  @objc private func didTapCancel() {
    dismiss(animated: true)
  }
}

extension RegionSelectionViewController: UITableViewDataSource {
  func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
      // 🔧 2) "내 근처" 셀 1개 추가
      regions.count + 1
  }
  func tableView(_ tv: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
    let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: ip)
      // 🔧 3) 첫 번째 행(0)에는 "내 근처" 표시
      if ip.row == 0 {
                  cell.textLabel?.text = "📍 내 근처"
              } else {
                  cell.textLabel?.text = regions[ip.row - 1]
              }
              return cell
  }
}

extension RegionSelectionViewController: UITableViewDelegate {
  func tableView(_ tv: UITableView, didSelectRowAt ip: IndexPath) {
    tv.deselectRow(at: ip, animated: true)
      // 🔧 4) 선택된 행에 따라 콜백 분기
              if ip.row == 0 {
      // "내 근처" 선택
                  didSelectRegionForNearby?()
              } else {
                  // 일반 지역 선택 (인덱스 보정)
                  didSelectRegion?(ip.row - 1)
              }

  }
}
