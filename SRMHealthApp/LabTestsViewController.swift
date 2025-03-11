//
//  LabTestsViewController.swift
//  SRMHealthApp
//
//  Created by Sanidhya's MacBook Pro on 11/03/25.
//

import UIKit
import FirebaseFirestore

struct LabTest {
    var id: String
    var name: String
    var price: Double
    var description: String
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.price = dictionary["price"] as? Double ?? 0.0
        self.description = dictionary["description"] as? String ?? ""
    }
}

class LabTestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    var labTests: [LabTest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Lab Tests"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LabTestTableViewCell.self, forCellReuseIdentifier: "LabTestCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        fetchLabTests()
    }
    
    func fetchLabTests() {
        let db = Firestore.firestore()
        db.collection("labTests").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching lab tests: \(error)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            self.labTests = documents.map { LabTest(dictionary: $0.data()) }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labTests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabTestCell", for: indexPath) as! LabTestTableViewCell
        let labTest = labTests[indexPath.row]
        cell.configure(with: labTest)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let labTest = labTests[indexPath.row]
        let labTestDetailVC = LabTestDetailViewController(labTest: labTest)
        navigationController?.pushViewController(labTestDetailVC, animated: true)
    }
}

class LabTestTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(priceLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with labTest: LabTest) {
        nameLabel.text = labTest.name
        priceLabel.text = "$\(labTest.price)"
    }
}
