//
//  RecipeTableViewCell.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 10/24/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeRatingLabel: UILabel!
    @IBOutlet weak var dateAddedLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        recipeImageView.image = nil
    }

}
