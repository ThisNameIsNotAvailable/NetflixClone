//
//  HeroHeaderView.swift
//  NetflixClone
//
//  Created by Alex on 24/11/2022.
//

import UIKit

protocol HeroHeaderViewDelegate: AnyObject {
    func heroHeaderViewDidTapPlay(_ title: Title)
}

class HeroHeaderView: UIView {
    
    private var title: Title!
    
    weak var delegate: HeroHeaderViewDelegate?
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.03529411765, blue: 0.07843137255, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.03529411765, blue: 0.07843137255, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "stubImage")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
        downloadButton.addTarget(self, action: #selector(didTapDownload), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPlay() {
        guard let title = title else {
            return
        }
        
        delegate?.heroHeaderViewDidTapPlay(title)
    }
    
    @objc private func didTapDownload() {
        guard let title = title else {
            return
        }
        DataPersistenceManager.shared.uploadTitle(with: title) { result in
            switch result {
            case .success():
                print("uploaded")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            playButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            playButton.widthAnchor.constraint(equalToConstant: 100),
            
            downloadButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    public func configure(with model: Title) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + (model.poster_path ?? "")) else {
            return
        }
        title = model
        imageView.sd_setImage(with: url)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
}
