//
//  ViewController.swift
//  project7-json
//
//  Created by Terry Kuo on 2021/7/12.
//

import UIKit

class ViewController: UITableViewController {
    
    //MARK: - Properties
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var mySearchController: UISearchController?

    lazy var creditButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(creditButtonTapped))
    
    //MARK: - App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = creditButton
        
        configureSearchController()
        fetchJSON()
    }
    
    
    //MARK: - Functions
    @objc func fetchJSON() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                self.parse(json: data)
                return
                
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
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
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            
        }
    }
    
    
    
    @objc private func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(ac, animated: true, completion: nil)
        }
        
    }
    
    private func configureSearchController() {
        mySearchController = UISearchController(searchResultsController: nil)
        mySearchController?.searchResultsUpdater = self
        self.navigationItem.searchController = mySearchController
        mySearchController?.obscuresBackgroundDuringPresentation = false
    }
    
    
    //MARK: - Tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return petitions.count
        
        if (mySearchController?.isActive)! {
            return filteredPetitions.count
        } else {
            return petitions.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = (mySearchController?.isActive)! ? filteredPetitions[indexPath.row].title : petitions[indexPath.row].title
        cell.detailTextLabel?.text = (mySearchController?.isActive)! ? filteredPetitions[indexPath.row].body : petitions[indexPath.row].body

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        detailVC.detailItem = (mySearchController?.isActive)! ? filteredPetitions[indexPath.row] : petitions[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}


// MARK: - Extension

extension ViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            DispatchQueue.global(qos: .userInitiated).async {
                self.filteredPetitions = self.petitions.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
}
