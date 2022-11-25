//
//  TitlePreviewViewController.swift
//  NetflixClone
//
//  Created by Alex on 25/11/2022.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {

    private let webView: WKWebView = WKWebView()
    
    private let movie: Title
    private let videoElement: VideoElement
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "Harry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry PotterHarry Potter"
        label.numberOfLines = 0
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.03529411765, blue: 0.07843137255, alpha: 1)
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    init(movie: Title, videoElement: VideoElement) {
        self.movie = movie
        self.videoElement = videoElement
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        downloadButton.addTarget(self, action: #selector(didTapDownload), for: .touchUpInside)
        configure(with: TitlePreviewViewModel(title: movie.original_title ?? "", youtubeView: videoElement, titleOverview: movie.overview ?? ""))
        
        applyConstraints()
    }
    
    @objc private func didTapDownload() {
        DataPersistenceManager.shared.uploadTitle(with: movie) { result in
            switch result {
            case .success():
                print("success")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func applyConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
}
