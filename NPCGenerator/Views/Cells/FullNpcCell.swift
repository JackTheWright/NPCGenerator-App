//
//  FullNpcCell.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-22.
//

import Foundation
import UIKit

class FullNpcCell: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: FullNpcCell.self)
    }
    private var hasConstrained: Bool = false
    private var icon = UIImageView()
    private var nameLabel = UILabel()
    private var ageLabel = UILabel()
    private var raceLabel = UILabel()
    private var genderLabel = UILabel()
    private var descriptionLabel = UILabel()
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = CommonConstants.standardSpacing2
        return view
    }()

    private lazy var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupUI() {
        contentView.addSubview(background)
        background.addSubviews([labelStack, icon])
        labelStack.addArrangedSubviews([nameLabel, ageLabel, raceLabel, genderLabel, descriptionLabel])
        setupLabel(label: nameLabel)
        setupLabel(label: ageLabel)
        setupLabel(label: raceLabel)
        setupLabel(label: genderLabel)
        setupLabel(label: descriptionLabel)
        configureConstraints()
        largeContentTitle = "All NPCs"
    }

    func setupLabel(label: UILabel) {
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
    }

    func configureConstraints() {
        background.anchor(
            top: contentView.topAnchor,
            left: contentView.leftAnchor,
            bottom: contentView.bottomAnchor,
            right: contentView.rightAnchor,
            topConstant: CommonConstants.standardSpacing2,
            leftConstant: CommonConstants.standardSpacing2,
            bottomConstant: CommonConstants.standardSpacing2,
            rightConstant: CommonConstants.standardSpacing2
        )

        labelStack.anchor(
            top: background.topAnchor,
            left: background.leftAnchor,
            bottom: background.bottomAnchor,
            right: background.rightAnchor,
            topConstant: CommonConstants.standardSpacing2,
            leftConstant: CommonConstants.standardSpacing2,
            bottomConstant: CommonConstants.standardSpacing2,
            rightConstant: CommonConstants.standardSpacing2
        )

        icon.anchor(
            top: background.topAnchor,
            right: background.rightAnchor,
            topConstant: CommonConstants.standardSpacing4,
            rightConstant: CommonConstants.standardSpacing4
        )
    }

    func attributeString(mainString: String, rangeString: String) -> NSMutableAttributedString {
        let range = (mainString as NSString).range(of: rangeString)
        let attributedString = NSMutableAttributedString(string: mainString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
        return attributedString
    }

    func configureCell(npcDetail: NpcDetails) {
        nameLabel.attributedText = attributeString(mainString: "Name: \(npcDetail.name)", rangeString: "Name: ")
        raceLabel.attributedText = attributeString(mainString: "Race: \(npcDetail.race)", rangeString: "Race: ")
        ageLabel.attributedText = attributeString(mainString: "Age: \(npcDetail.age)", rangeString: "Age: ")
        genderLabel.attributedText = attributeString(mainString: "Gender: \(npcDetail.gender)", rangeString: "Gender: ")

        let hair = npcDetail.hairstyle.lowercased()
        let feature = npcDetail.standoutFeature.lowercased()
        let accent = npcDetail.accent.lowercased()
        descriptionLabel.attributedText = attributeString(mainString: "Description: They have \(hair), \(feature), and \(accent).", rangeString: "Description: ")

        icon.image = UIImage(systemName: Race.raceCheck(stringToCheck: npcDetail.race.lowercased()).imageName)
        icon.tintColor = .black
    }

}


// Name
// Race                  icon
// Age
// Gender
// Description Text which will be longer
