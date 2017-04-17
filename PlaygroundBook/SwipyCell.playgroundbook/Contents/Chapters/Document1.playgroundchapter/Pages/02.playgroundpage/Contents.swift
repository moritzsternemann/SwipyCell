//#-hidden-code
import UIKit
import PlaygroundSupport

public class HowToViewController: GradientViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()

    private let initialNumberItems = 1
    private var numberItems: Int = 0
    private var cellToDelete: SwipyCell? = nil

    var checkView: UIView!
    var greenColor: UIColor!

    public override init() {
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        numberItems = initialNumberItems

        setupSubviews()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.clipsToBounds = true
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.2
        tableView.layer.shadowOffset = .zero
        tableView.layer.shadowRadius = 10
        tableView.tableFooterView = UIView()
        let backgroundView = UIView(frame: tableView.frame)
        backgroundView.backgroundColor = .white
        tableView.backgroundView = backgroundView

//#-end-hidden-code
/*:
 # Your First SwipyCell
 I've set up a common `UITableView` with one cell to use for our example.
 Your job is to implement your first SwipyCell!

 To get started, I set up some variables we'll need later:
*/
// The checkView will be shown 'below' the cell while swiping it
checkView = UIImageView(imageNamed: "check")

// greenColor will be used as the background color for the checkView
greenColor = #colorLiteral(red: 0.3333333333, green: 0.8352941176, blue: 0.3137254902, alpha: 1)
//#-hidden-code
    }

    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let wc = tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        wc.priority = 750
        wc.isActive = true
        tableView.widthAnchor.constraint(lessThanOrEqualToConstant: 375).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let hc = tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        hc.priority = 750
        hc.isActive = true
        tableView.heightAnchor.constraint(lessThanOrEqualToConstant: 667).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    // MARK: TableView DataSource & Delegate

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberItems
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }

//#-end-hidden-code

/*:
 Now you can configure the cell as you would for any UITableView.

 To add a swipe gesture handler to the cell, call `addSwipeTrigger` on the cell object. Use the previously assigned `checkView` and `greenColor` objects.
 For now just ignore the `mode`, `state` and `completion` arguments. You'll learn about them a later.
*/
public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = SwipyCell()
  cell.textLabel?.text = "Swipe me! ✌️"
//#-hidden-code
  cell.selectionStyle = .gray
  cell.contentView.backgroundColor = UIColor.white
  cell.defaultColor = tableView.backgroundView?.backgroundColor
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, checkView, greenColor, ., nil)
//#-editable-code
cell.addSwipeTrigger(forState: .state(0, .left), withMode: .toggle, swipeView: <#UIView#>, swipeColor: <#UIColor#>, completion: nil)
//#-end-editable-code
//#-hidden-code
cell.setCompletionBlock(forState: .state(0, .left)) { cell, state, mode in
  PlaygroundPage.current.assessmentStatus = .pass(message: "### Congratulations! 🎉 \n\n You've created your first SwipyCell. Want to know what else it can do? \n\n Check out the [**next page**](@next)")
}
//#-end-hidden-code
  return cell
}

//#-hidden-code

}

extension UIImageView {
    convenience init(imageNamed: String) {
        let image = UIImage(named: imageNamed)
        self.init(image: image)
    }
}

PlaygroundPage.current.liveView = HowToViewController()
//#-end-hidden-code
