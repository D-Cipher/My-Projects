//
//  ChatCell.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let messageLabel = UILabel()
    let dateLabel = UILabel()
    let cellImage = UIImageView()
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        let scale = CGFloat(max(size.width/image.size.width,
            size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRectMake( 0, 0, width, height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.drawInRect(rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let col_tungsten = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        
        //Setup Chat Cell Design Specs
        nameLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightBold)
        messageLabel.font = UIFont.systemFontOfSize(14)
        dateLabel.font = UIFont.systemFontOfSize(14)
        
        nameLabel.textColor = col_tungsten
        messageLabel.textColor = UIColor.grayColor()
        dateLabel.textColor = UIColor.grayColor()
        
        let avatar = UIImage(named: "placeholder-camera-green.png")
        let avatar_sized = resizeImage(avatar!, toTheSize: CGSizeMake(70, 70))
        let cellImageLayer: CALayer?  = cellImage.layer
        cellImageLayer!.cornerRadius = 10
        cellImageLayer!.masksToBounds = true
        
        cellImage.image = avatar_sized
        
        let object_ls = [nameLabel, messageLabel, dateLabel, cellImage]
        
        for object in object_ls {
            object.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(object)
        }
        
        let constraints: [NSLayoutConstraint] = [
            cellImage.centerYAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.centerYAnchor),
            cellImage.leadingAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.leadingAnchor),
            nameLabel.topAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.topAnchor),
            nameLabel.leadingAnchor.constraintEqualToAnchor(cellImage.layoutMarginsGuide.trailingAnchor, constant: 20),
            messageLabel.topAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.centerYAnchor, constant: 5),
            messageLabel.leadingAnchor.constraintEqualToAnchor(cellImage.layoutMarginsGuide.trailingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.trailingAnchor),
            dateLabel.firstBaselineAnchor.constraintEqualToAnchor(nameLabel.firstBaselineAnchor)
        ]
        
        NSLayoutConstraint.activateConstraints(constraints)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
