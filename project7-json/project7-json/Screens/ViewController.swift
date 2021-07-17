//
//  ViewController.swift
//  project7-json
//
//  Created by Terry Kuo on 2021/7/12.
//

import UIKit

class ViewController: UITableViewController {
    
    enum Section {
        case main
    }
    
    private var isSearching = false
    private var dataSource:  UITableViewDiffableDataSource<Section, Petition>!
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    lazy var creditButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(creditButtonTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = creditButton
        configureDataSource()
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                updateData(on: petitions)
                return
            }
        }
        
        showError()
    }
    
    @objc private func creditButtonTapped() {
        let creditsVC = CreditsVC()
        creditsVC.modalPresentationStyle = .overFullScreen
        creditsVC.modalTransitionStyle = .crossDissolve
        present(creditsVC, animated: true, completion: nil)
    }
    
    private func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    private func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(ac, animated: true, completion: nil)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Petition>(tableView: self.tableView, cellProvider: { tableView, indexPath, petition in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            cell.textLabel?.text = self.petitions[indexPath.row].title
            cell.detailTextLabel?.text = self.petitions[indexPath.row].body
            
            return cell
        })
        
    }
    
    private func updateData(on petitions: [Petition]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Petition>()
        snapshot.appendSections([.main])
        snapshot.appendItems(petitions)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//
//        cell.textLabel?.text = petitions[indexPath.row].title
//        cell.detailTextLabel?.text = petitions[indexPath.row].body
//
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        detailVC.detailItem = petitions[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

