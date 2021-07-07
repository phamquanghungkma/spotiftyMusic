//
//  SettingsViewController.swift
//  notifyApp
//
//  Created by Tofu-imac on 3/6/21.
//

import UIKit

class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,style:.grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        setUpTableView()
   
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    func setUpTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self

    }
    private func configureModels() {
        sections.append(Section(title:"Profile", options: [Option(title: "View Your Profile", handler: { [weak self] in
            self?.viewProfile()
        })]))
        
        sections.append(Section(title:"Account", options: [Option(title: "Sign Out", handler: { [weak self] in
            self?.signOutTapped()
        })]))
    }
    private func viewProfile() {
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    private func signOutTapped() {
        
    }


// MARK: - Delegate and DataSource
}
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("sections",sections[section])
        return sections[section].options.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
    }
    
    
}
