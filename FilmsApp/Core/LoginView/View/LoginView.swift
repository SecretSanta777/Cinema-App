//
//  LoginView.swift
//  FilmsApp
//
//  Created by Владимир Царь on 13.11.2025.
//

import UIKit
import Combine

class LoginView: UIViewController {
    
    var viewModel: LoginViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var emailErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()

    private lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Войти"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "email"
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
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupValidation()
    }
    
    private func setupUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubviews(titleLabel, emailField, passwordField, loginButton, emailErrorLabel, passwordErrorLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            
            // emailField
            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            // Email Field
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            //
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            
        ])
    }
    
    private func setupValidation() {
        let textFieldPuiblisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: emailField)
            .compactMap { ($0.object as? UITextField)?.text }
            .map { self.viewModel.isValidEmail($0)}
            .eraseToAnyPublisher()
        
        let passwordFieldPuiblisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: passwordField)
            .compactMap { ($0.object as? UITextField)?.text }
            .map { self.viewModel.isValidPassword($0)}
            .eraseToAnyPublisher()
        
        Publishers.CombineLatest(textFieldPuiblisher, passwordFieldPuiblisher)
            .map { $0 && $1 }
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
        
        Publishers.CombineLatest(textFieldPuiblisher, passwordFieldPuiblisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValidEmail, isValidPassword in
                let allValid = isValidEmail && isValidPassword
                
                UIView.animate(withDuration: 0.3) {
                    // Меняем цвет кнопки
                    if allValid {
                        // Когда все валидно - яркий синий
                        self?.loginButton.backgroundColor = .systemBlue
                    } else {
                        // Когда не валидно - серый и полупрозрачный
                        self?.loginButton.backgroundColor = .systemGray
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        let action = UIAction { [weak self]_ in
            guard let self = self else { return }
            
            let email = self.emailField.text ?? ""
            let password = self.passwordField.text ?? ""
            
            let user = UserData(email: email, password: password)
            viewModel.authService.signIn(user: user) { result in
                switch result {
                case .success(_):
                    NotificationCenter.default.post(name: .windowManager, object: nil, userInfo: [String.windowManager: AppRoute.tabBarView])
                case .failure(let failure):
                    let alert = UIAlertController(title: "Ошибка", message: "Верефецируйте аккунт или проверьте пароль", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ок", style: .default)
                    
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    
                    print(failure)
                }
            }
        }
        loginButton.addAction(action, for: .touchUpInside)
    }
}
