//
//  p8Button.swift
//  hws-p8
//
//  Created by Terry Kuo on 2021/7/29.
//

import UIKit

class p8Button: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.systemBlue, for: .normal)
        layer.cornerRadius = 20
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
}
