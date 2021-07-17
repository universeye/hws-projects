//
//  CreditsVC.swift
//  project7-json
//
//  Created by Terry Kuo on 2021/7/17.
//

import UIKit

class CreditsVC: UIViewController {
    
    private let containerView = UIView()
    private let stackView = UIStackView()
    
    private let label: UILabel = {
       let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "We The People API of the Whitehouse"
        label.numberOfLines = 2
        return label
    }()
    
    private let imageView: UIImageView = {
       let imagV = UIImageView()
        imagV.translatesAutoresizingMaskIntoConstraints = false
        imagV.image = UIImage(systemName: "info.circle")
        imagV.contentMode = .scaleAspectFit
        return imagV
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Ok", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        
        configureContainerView()
        configureOKButton()
        configureStackView()
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 200)
            
        ])
    }
    
    private func configureOKButton() {
        containerView.addSubview(okButton)
        
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            okButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            okButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            okButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            okButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
    
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
     
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
    }
    
    @objc private func okButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
