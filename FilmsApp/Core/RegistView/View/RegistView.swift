//  RegistView.swift
//  FilmsApp
//
//  Created by Владимир Царь on 13.11.2025.
//

import UIKit
import Combine

class RegistView: UIViewController {
    
    var viewModel: RegistViewModel
    var cancellables: Set<AnyCancellable> = []
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Регистрация"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.backgroundColor = .white.withAlphaComponent(0.9)
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.backgroundColor = .white.withAlphaComponent(0.9)
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var nameField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name"
        textField.backgroundColor = .white.withAlphaComponent(0.9)
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var registButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.systemBlue.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    private lazy var haveAccButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Уже есть аккаунт? Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    init(viewModel: RegistViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        setupUI()
        setupConstraints()
        setupValidation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAction()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        // Градиентный фон
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Добавляем элементы
        view.addSubviews(titleLabel, nameField, passwordField, emailField, registButton, haveAccButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            // Email Field
            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            // Password Field
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            // Email Field
            nameField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            nameField.heightAnchor.constraint(equalToConstant: 50),
            
            // Register Button
            registButton.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 40),
            registButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            registButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            registButton.heightAnchor.constraint(equalToConstant: 55),
            
            // Have Account Button
            haveAccButton.topAnchor.constraint(equalTo: registButton.bottomAnchor, constant: 20),
            haveAccButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            haveAccButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            haveAccButton.heightAnchor.constraint(equalToConstant: 50),
            haveAccButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupValidation() {
        let textFieldPublisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: emailField)
            .compactMap { ($0.object as? UITextField)?.text }
            .map { self.viewModel.isValidEmail($0) }
            .eraseToAnyPublisher()
        
        let passwordFieldPublisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: passwordField)
            .compactMap { ($0.object as? UITextField)?.text }
            .map { self.viewModel.isValidPassword($0) }
            .eraseToAnyPublisher()
        
        let namePublisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: nameField)
            .compactMap { ($0.object as? UITextField)?.text }
            .map { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .eraseToAnyPublisher()
        
        Publishers.CombineLatest3(textFieldPublisher, passwordFieldPublisher, namePublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] values in
                let (isValidEmail, isValidPassword, isValidName) = values
                let allValid = isValidEmail && isValidPassword && isValidName
                
                UIView.animate(withDuration: 0.3) {
                    if allValid {
                        // Когда все валидно - яркий синий
                        self?.registButton.backgroundColor = .systemBlue
                        self?.registButton.layer.shadowOpacity = 0.3
                        self?.registButton.alpha = 1.0
                    } else {
                        // Когда не валидно - серый и полупрозрачный
                        self?.registButton.backgroundColor = .systemGray
                        self?.registButton.layer.shadowOpacity = 0.1
                        self?.registButton.alpha = 0.6
                    }
                }
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest3(textFieldPublisher, passwordFieldPublisher, namePublisher)
            .map { $0 && $1 && $2 }
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: registButton)
            .store(in: &cancellables)
    }
    
    private func addAction() {
        let registAction = UIAction { [weak self] _ in
            
            guard let self = self else { return }
            
            let email = self.emailField.text ?? ""
            
            let password = self.passwordField.text ?? ""
            
            let name = self.nameField.text ?? ""
            
            let user = UserData(email: email, password: password, name: name)
            
            viewModel.authService.createNewUser(user: user) { result in
                switch result {
                case .success(_):
                    NotificationCenter.default.post(name: .windowManager, object: nil, userInfo: [String.windowManager : AppRoute.loginView])
                    UserDefaults.standard.setValue(self.nameField.text, forKey: "name")
                case .failure(let failure):
                    let alert = UIAlertController(title: "Ошибка", message: failure.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ок", style: .default)
                    
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    print(failure)
                }
            }
            
        }
        registButton.addAction(registAction, for: .touchUpInside)
        
        // Действие для кнопки "Уже есть аккаунт"
        let haveAccAction = UIAction { _ in
            NotificationCenter.default.post(name: .windowManager, object: nil, userInfo: [String.windowManager : AppRoute.loginView])
        }
        haveAccButton.addAction(haveAccAction, for: .touchUpInside)
    }
    
}
