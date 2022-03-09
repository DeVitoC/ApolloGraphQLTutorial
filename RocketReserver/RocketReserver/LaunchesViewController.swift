//
//  LaunchesViewController.swift
//  RocketReserver
//
//  Created by Christopher DeVito on 3/6/22.
//

import UIKit

class LaunchesViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadLaunches()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: Segues

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showProfile" {
            return true
        }

        guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else { return false }

        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfile" {
            return
        }

        guard let destination = segue.destination as? UINavigationController,
              let detail = destination.topViewController as? DetailViewController
        else {
            assertionFailure("Wrong kind of destination")
            return
        }

        self.detailViewController = detail
    }

    // MARK: IBActions

    @IBAction private func launchTypeSelectorTapped(_ sender: UISegmentedControl) {
        sender.selectedSegmentIndex = 0
    }

    @IBAction private func profileTapped() {
        self.performSegue(withIdentifier: "showProfile", sender: nil)
    }

    // MARK: Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = "Placeholder"

        return cell
    }

    private func loadLaunches() {
        // TODO: Load a list of launches
    }

}
