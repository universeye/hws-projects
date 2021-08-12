//
//  p8Label.swift
//  hws-p8
//
//  Created by Terry Kuo on 2021/8/13.
//

import UIKit

class p8Label: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(numberOfLines: Int, textAlignment: NSTextAlignment = .left) {
        self.init(frame: .zero)
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 24)
    }
}
