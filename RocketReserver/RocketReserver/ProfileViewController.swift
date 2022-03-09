//
//  ProfileViewController.swift
//  RocketReserver
//
//  Created by Christopher DeVito on 3/6/22.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var idLabel: UILabel!
    @IBOutlet private var selectedImageButton: UIButton!

    private func configureForImageURL(urlString: String?) {
        let personImage = UIImage(systemName: "person")
        guard let urlString = urlString,
            let url = URL(string: urlString)
        else {
            self.selectedImageButton.setTitle("Select Image", for: .normal)
            self.profileImageView.image = personImage
            return
        }

        self.selectedImageButton.setTitle("Update Image", for: .normal)
        self.profileImageView.sd_setImage(with: url, placeholderImage: personImage)
    }

    @IBAction private func closeTapped() {
        self.dismiss(animated: true)
    }

    @IBAction private func updateImageTapped() {
        // TODO: Update the image
    }
}
