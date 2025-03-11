//
//  MedicinesViewController.swift
//  SRMHealthApp
//
//  Created by Sanidhya's MacBook Pro on 11/03/25.
//

import UIKit
import FirebaseFirestore

struct Medicine {
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

class MedicinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    var medicines: [Medicine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Buy Medicines"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MedicineTableViewCell.self, forCellReuseIdentifier: "MedicineCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        fetchMedicines()
    }
    
    func fetchMedicines() {
        let db = Firestore.firestore()
        db.collection("medicines").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching medicines: \(error)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            self.medicines = documents.map { Medicine(dictionary: $0.data()) }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell", for: indexPath) as! MedicineTableViewCell
        let medicine = medicines[indexPath.row]
        cell.configure(with: medicine)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let medicine = medicines[indexPath.row]
        let medicineDetailVC = MedicineDetailViewController(medicine: medicine)
        navigationController?.pushViewController(medicineDetailVC, animated: true)
    }
}

class MedicineTableViewCell: UITableViewCell {
    
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
    
    func configure(with medicine: Medicine) {
        nameLabel.text = medicine.name
        priceLabel.text = "$\(medicine.price)"
    }
}
