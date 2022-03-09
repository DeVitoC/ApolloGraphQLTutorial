//
//  LaunchesViewController.swift
//  RocketReserver
//
//  Created by Ellen Shapiro on 11/13/19.
//  Copyright © 2019 Apollo GraphQL. All rights reserved.
//

import UIKit
import SDWebImage
import Apollo

class LaunchesViewController: UITableViewController {

    var launches = [LaunchesQuery.Data.Launch.Launch]()
    private var lastConnection: LaunchesQuery.Data.Launch?
    private var activeRequest: Cancellable?
    
    var detailViewController: DetailViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadMoreLaunchesIfTheyExist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: - Segues
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showProfile" {
            // This should always occur
            return true
        }
        
        guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else {
            return false
        }
        
        guard let listSection = ListSection(rawValue: selectedIndexPath.section) else {
            assertionFailure("Invalid Section")
            return false
        }

        switch listSection {
        case .launches:
            return true
        case .loading:
            self.tableView.deselectRow(at: selectedIndexPath, animated: true)

            if self.activeRequest == nil {
                self.loadMoreLaunchesIfTheyExist()
            }

            self.tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfile" {
            // No setup is required.
            return
        }
    
        guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else { return }

        guard let listSection = ListSection(rawValue: selectedIndexPath.section) else {
            assertionFailure()
            return
        }

        switch listSection {
        case .launches:
            guard
                let destination = segue.destination as? UINavigationController,
                let detail = destination.topViewController as? DetailViewController else {
                    assertionFailure("Wrong kind of destination")
                    return
                }

            let launch = self.launches[selectedIndexPath.row]
            detail.launchID = launch.id

            self.detailViewController = detail
        case .loading:
            assertionFailure("Shouldn't have gotten here")
        }
    }
    
    // MARK: - IBActions
    
    @IBAction private func launchTypeSelectorTapped(_ sender: UISegmentedControl) {
        // TODO: In the future, actually have this do something.
        sender.selectedSegmentIndex = 0
    }
    
    @IBAction private func profileTapped() {
        self.performSegue(withIdentifier: "showProfile", sender: nil)
    }

    private func loadMoreLaunches(from cursor: String?) {
        self.activeRequest = Network.shared.apollo.fetch(query: LaunchesQuery(cursor: cursor)) { [weak self] result in
            guard let self = self else { return }

            self.activeRequest = nil
            defer {
                self.tableView.reloadData()
            }

            switch result {
            case .success(let graphQLResult):
                if let launchConnection = graphQLResult.data?.launches {
                    self.lastConnection = launchConnection
                    self.launches.append(contentsOf: launchConnection.launches.compactMap { $0 })
                }

                if let errors = graphQLResult.errors {
                    let message = errors
                        .map { $0.localizedDescription }
                        .joined(separator: "\n")
                    self.showAlert(title: "GraphQL Error(s)", message: message)
                }
            case .failure(let error):
                // From 'UIViewController+Alert.swift'
                self.showAlert(title: "Network Error", message: error.localizedDescription)
            }
        }
    }

    private func loadMoreLaunchesIfTheyExist() {
        guard let connection = self.lastConnection else {
            self.loadMoreLaunches(from: nil)
            return
        }

        guard connection.hasMore else {
            return
        }

        self.loadMoreLaunches(from: connection.cursor)
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        ListSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listSection = ListSection(rawValue: section) else {
            assertionFailure("Invalid Section")
            return 0
        }

        switch listSection {
        case .launches:
            return self.launches.count
        case .loading:
            if self.lastConnection?.hasMore == false {
                return 0
            } else {
                return 1
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.imageView?.image = nil
        cell.textLabel?.text = nil
        cell.detailTextLabel?.text = nil
        
        guard let listSection = ListSection(rawValue: indexPath.section) else {
            assertionFailure("Invalid Section")
            return cell
        }

        switch listSection {
        case .launches:
            let launch = self.launches[indexPath.row]
            cell.textLabel?.text = launch.mission?.name
            cell.detailTextLabel?.text = launch.site

            let placeholder = UIImage(named: "placeholder")

            if let missionPatch = launch.mission?.missionPatch {
                cell.imageView?.sd_setImage(with: URL(string: missionPatch)!, placeholderImage: placeholder)
            } else {
                cell.imageView?.image = placeholder
            }
        case .loading:
            if self.activeRequest == nil {
                cell.textLabel?.text = "Tap to load more"
            } else {
                cell.textLabel?.text = "Loading..."
            }
        }

        return cell
    }
}

enum ListSection: Int, CaseIterable {
    case launches
    case loading
}