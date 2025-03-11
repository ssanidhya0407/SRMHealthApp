//
//  DoctorsViewController.swift
//  SRMHealthApp
//
//  Created by Sanidhya's MacBook Pro on 11/03/25.
//

import UIKit
import FirebaseFirestore

struct Doctor {
    var id: String
    var name: String
    var specialization: String
    var availability: String
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.specialization = dictionary["specialization"] as? String ?? ""
        self.availability = dictionary["availability"] as? String ?? ""
    }
}

class DoctorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    var doctors: [Doctor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Find Doctor"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DoctorTableViewCell.self, forCellReuseIdentifier: "DoctorCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        fetchDoctors()
    }
    
    func fetchDoctors() {
        let db = Firestore.firestore()
        db.collection("doctors").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching doctors: \(error)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            self.doctors = documents.map { Doctor(dictionary: $0.data()) }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for: indexPath) as! DoctorTableViewCell
        let doctor = doctors[indexPath.row]
        cell.configure(with: doctor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let doctor = doctors[indexPath.row]
        let doctorDetailVC = DoctorDetailViewController(doctor: doctor)
        navigationController?.pushViewController(doctorDetailVC, animated: true)
    }
}

class DoctorTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let specializationLabel: UILabel = {
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
        addSubview(specializationLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        specializationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            specializationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            specializationLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with doctor: Doctor) {
        nameLabel.text = doctor.name
        specializationLabel.text = doctor.specialization
    }
}
