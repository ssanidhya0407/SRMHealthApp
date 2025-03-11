//
//  DoctorDetailViewController.swift
//  SRMHealthApp
//
//  Created by Sanidhya's MacBook Pro on 11/03/25.
//


import UIKit

class DoctorDetailViewController: UIViewController {
    
    var doctor: Doctor
    
    let specializationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let availabilityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let bookAppointmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Book Appointment", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(bookAppointmentTapped), for: .touchUpInside)
        return button
    }()
    
    init(doctor: Doctor) {
        self.doctor = doctor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = doctor.name
        
        setupViews()
        populateData()
    }
    
    func setupViews() {
        view.addSubview(specializationLabel)
        view.addSubview(availabilityLabel)
        view.addSubview(bookAppointmentButton)
        
        specializationLabel.translatesAutoresizingMaskIntoConstraints = false
        availabilityLabel.translatesAutoresizingMaskIntoConstraints = false
        bookAppointmentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            specializationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            specializationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            specializationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            availabilityLabel.topAnchor.constraint(equalTo: specializationLabel.bottomAnchor, constant: 20),
            availabilityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            bookAppointmentButton.topAnchor.constraint(equalTo: availabilityLabel.bottomAnchor, constant: 20),
            bookAppointmentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bookAppointmentButton.widthAnchor.constraint(equalToConstant: 200),
            bookAppointmentButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func populateData() {
        specializationLabel.text = "Specialization: \(doctor.specialization)"
        availabilityLabel.text = "Availability: \(doctor.availability)"
    }
    
    @objc func bookAppointmentTapped() {
        // Book appointment logic here
        let alert = UIAlertController(title: "Appointment Booked", message: "Your appointment with Dr. \(doctor.name) has been booked.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}