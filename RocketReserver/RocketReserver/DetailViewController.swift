//
//  DetailViewController.swift
//  RocketReserver
//
//  Created by Christopher DeVito on 3/6/22.
//

import UIKit
import Apollo

class DetailViewController: UIViewController {

    @IBOutlet private var missionPatchImageView: UIImageView!
    @IBOutlet private var missionNameLabel: UILabel!
    @IBOutlet private var rocketNameLabel: UILabel!
    @IBOutlet private var launchSiteLabel: UILabel!
    @IBOutlet private var bookCancelButton: UIBarButtonItem!

    var launchID: GraphQLID? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        guard self.missionNameLabel != nil else { return }

        self.missionNameLabel.text = "Placeholder"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
    }

    private func loadLaunchDetails() {
        // TODO: load launch details
    }

    @IBAction private func bookOrCancelTapped() {
        // TODO: figureo ut if a trip should be booked or cancelled
    }

    private func bookTrip(with id: GraphQLID) {
        // TODO: add code to book trip
    }

    private func cancelTrip(with id: GraphQLID) {
        // TODO: add code to cancel trip
    }

    private func isLoggedIn() -> Bool {
        return false
    }
}
