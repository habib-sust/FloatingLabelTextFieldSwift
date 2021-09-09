//
//  FloatingLabelTextField.swift
//  FloatingLabelTextFieldSwift
//
//  Created by Habibur Rahman on 9/9/21.
//

import UIKit

public class FloatingLabelTextField: UITextField {
    private var titleLabel: UILabel!
    private let floatingTextColor: UIColor = .lightGray

    private var labelTopConstraint: NSLayoutConstraint!
    private var labelLeadingConstraint: NSLayoutConstraint!
    
    let padding = UIEdgeInsets(top: 12, left: 14, bottom: 0, right: 4)
    
    @IBInspectable var floatingText: String? {
        didSet { titleLabel.text = floatingText }
    }
    
    public override var text: String? {
        didSet {
            if hasText {
                floatTitle()
            } else {
                unfloatTitle()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    deinit {
        removeTarget(self, action: #selector(floatTitleLabel), for: .editingDidBegin)
        removeTarget(self, action: #selector(unFloatTitleLabel), for: .editingDidEnd)
    }
}

extension FloatingLabelTextField {
    private func commonInit() {
        font = .systemFont(ofSize: 16, weight: .medium)
        createTitleLabel()
        
        addTarget(self, action: #selector(floatTitleLabel), for: .editingDidBegin)
        addTarget(self, action: #selector(unFloatTitleLabel), for: .editingDidEnd)
    }
    
    
    
    private func createTitleLabel() {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = floatingTextColor
        titleLabel.text = floatingText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        
        let topConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15)
        let leadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14)
        
        NSLayoutConstraint.activate([
            leadingConstraint,
            topConstraint
        ])
        
        self.titleLabel = titleLabel
        labelTopConstraint = topConstraint
        labelLeadingConstraint = leadingConstraint
    }
    
    // This is where we adjust constraint and the label will float to the top
    func floatTitle() {
        titleLabel.font = titleLabel.font?.withSize(12)
        titleLabel.textColor = .lightGray
        
        labelTopConstraint.constant = 6
    }
    
    func unfloatTitle() {
        placeholder = nil
        labelTopConstraint.constant = 15
        titleLabel.font = titleLabel.font?.withSize(16)
        titleLabel.textColor = floatingTextColor
    }
    
    func performAnimation(transform: CGAffineTransform) {
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.titleLabel.transform = transform
                self?.layoutIfNeeded()
        })
    }
    
    @objc private func floatTitleLabel() {
        floatTitle()
        performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1))
    }
    
    @objc private func unFloatTitleLabel() {
        // We need to check if the textfield is empty or not. If it's empty, we will unfloat the label meaning going back to the original position.
        if !hasText {
            unfloatTitle()
            performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1))
        }
    }
}
