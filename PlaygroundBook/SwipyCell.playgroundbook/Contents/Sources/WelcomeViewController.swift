import UIKit
import PlaygroundSupport

public class WelcomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let gradientView = GradientView()
    private let tableView = UITableView()
    private let passLabel = UILabel()
    private var passLabelYConstraint1: NSLayoutConstraint!
    private var passLabelYConstraint2: NSLayoutConstraint!
    private let passLabelYOffset: CGFloat = 40

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()

        gradientView.isHidden = false
        gradientView.gradientLayer.colors = Constants.backgroundColors.map { $0.cgColor }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.clipsToBounds = false
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.2
        tableView.layer.shadowOffset = .zero
        tableView.layer.shadowRadius = 10

        passLabel.text = "Great! How to implement this?\nCheck out the next page 😉"
        passLabel.numberOfLines = 3
        passLabel.textAlignment = .center
        passLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }

    private func setupSubviews() {
        view.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        gradientView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let wc = tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        wc.priority = 750
        wc.isActive = true
        tableView.widthAnchor.constraint(lessThanOrEqualToConstant: 375).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: Constants.cellHeight).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        view.addSubview(passLabel)
        passLabel.translatesAutoresizingMaskIntoConstraints = false
        passLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        passLabelYConstraint1 = passLabel.topAnchor.constraint(equalTo: view.bottomAnchor)
        passLabelYConstraint1.isActive = true
        passLabelYConstraint2 = passLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: passLabelYOffset)
    }

    // MARK: TableView DataSource & Delegate

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SwipyCell()
        cell.selectionStyle = .gray
        cell.textLabel?.text = "Swipe me! ✌️"

        let greenColor = #colorLiteral(red: 0.3333333333, green: 0.8352941176, blue: 0.3137254902, alpha: 1)

        cell.addSwipeTrigger(forState: .state(0, .left), withMode: .toggle, swipeView: UIView(), swipeColor: greenColor) { cell, state, mode in
          self.passLabelYConstraint1.isActive = false
          self.passLabelYConstraint2.isActive = true
          UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: [], animations: {
              self.view.layoutIfNeeded()
          }, completion: nil)
        }

        return cell
    }

}
