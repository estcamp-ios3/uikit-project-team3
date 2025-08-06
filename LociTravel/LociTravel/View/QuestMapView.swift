import UIKit
import MapKit

class QuestMapView: UIView {

    let mapView = MKMapView()
    let closeButton = UIButton()
    let musicToggleButton = UIButton()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let progressView = UIProgressView(progressViewStyle: .default)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .systemBackground

        [mapView, closeButton, musicToggleButton, titleLabel, descriptionLabel, progressView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = .boldSystemFont(ofSize: 30)
        closeButton.setTitleColor(.black, for: .normal)

        musicToggleButton.setImage(UIImage(systemName: "headphones"), for: .normal)
        musicToggleButton.tintColor = .black

        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center

        descriptionLabel.font = .systemFont(ofSize: 18)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center

        progressView.progress = 0.0

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            musicToggleButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            musicToggleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            musicToggleButton.widthAnchor.constraint(equalToConstant: 30),
            musicToggleButton.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            progressView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            progressView.heightAnchor.constraint(equalToConstant: 8),

            mapView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
