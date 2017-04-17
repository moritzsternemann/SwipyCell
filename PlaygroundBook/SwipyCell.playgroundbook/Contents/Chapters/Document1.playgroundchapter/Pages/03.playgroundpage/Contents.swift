//#-hidden-code
import UIKit
import PlaygroundSupport

public class HowToViewController: GradientViewController, UITableViewDataSource, UITableViewDelegate {

    private struct AssessmentStatus {
        var states: Set<SwipyCellState> = []
        var toggle: Bool = false
        var exit: Bool = false
    }
    private var assessmentStatus = AssessmentStatus()

    private let tableView = UITableView()

    private let initialNumberItems = 1
    private var numberItems: Int = 0
    private var cellToDelete: SwipyCell? = nil

    var checkView: UIView!
    var greenColor: UIColor!
    var crossView: UIView!
    var redColor: UIColor!
    var clockView: UIView!
    var yellowColor: UIColor!
    var listView: UIView!
    var brownColor: UIColor!

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
 # So Many Possibilities

 Now that you know the basics about SwipyCell, we can focus on the cooler and more advanced stuff.

 You can add as many **swipe triggers** as there are *trigger points* set-up (no need to worry about that just now, more info available on [GitHub](https://github.com/moritzsternemann/SwipyCell/tree/3.0.1#trigger-points)), customize all the **icons and colors**, choose from **two different modes** and much more to customzie the look and feel.

 First I added some more icons and colors you can use:
*/
checkView = UIImageView(imageNamed: "check")
crossView = UIImageView(imageNamed: "cross")
clockView = UIImageView(imageNamed: "clock")
listView = UIImageView(imageNamed: "list")

greenColor = #colorLiteral(red: 0.3333333333, green: 0.8352941176, blue: 0.3137254902, alpha: 1)
redColor = #colorLiteral(red: 0.9098039216, green: 0.2392156863, blue: 0.05490196078, alpha: 1)
yellowColor = #colorLiteral(red: 0.9960784314, green: 0.8509803922, blue: 0.2196078431, alpha: 1)
brownColor = #colorLiteral(red: 0.8078431373, green: 0.5843137255, blue: 0.3843137255, alpha: 1)
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

public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = SwipyCell()
  cell.textLabel?.text = "Swipe me! ✌️"
//#-end-hidden-code

/*:
 I've added the same cell you created earlier.

 Try out at least four states and all modes you can set triggers for!
 As you've see before, the states which refer to existing trigger points, consist of an integer and the enum value `.left` or `.right`.
 The integer is the index of the trigger point, counting from the inside to the outside. The second parameter defines the side of the cell on which the trigger will be.
 For this lesson I set-up two different trigger points on each side of the cell.
 The two modes you can choose from are *toggle* and *exit*. Toggle is useful for marking or adding something, exit is mostly useful for removing items.
*/
//#-hidden-code
  cell.selectionStyle = .gray
  cell.contentView.backgroundColor = UIColor.white
  cell.defaultColor = tableView.backgroundView?.backgroundColor
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, SwipyCellMode, exit, toggle, .)
//#-code-completion(identifier, show, SwipyCellState, state())
//#-code-completion(identifier, show, SwipyCellDirection, left, right)
//#-code-completion(identifier, show, checkView, crossView, clockView, listView, greenColor, redColor, yellowColor, brownColor)
//#-code-completion(identifier, show, nil, cell)

//#-editable-code
cell.addSwipeTrigger(forState: .state(0, .left), withMode: .toggle, swipeView: checkView, swipeColor: greenColor, completion: nil)

// Add more swipe triggers using the same syntax as above, alter the states and modes you use...
cell.addSwipeTrigger(forState: .state(<#T##Int##Int#>, .<#Side#>), withMode: .<#SwipyCellMode#>, swipeView: crossView, swipeColor: redColor, completion: nil)

cell.addSwipeTrigger(forState: .state(<#T##Int##Int#>, .<#Side#>), withMode: .<#SwipyCellMode#>, swipeView: clockView, swipeColor: yellowColor, completion: nil)

cell.addSwipeTrigger(forState: .state(<#T##Int##Int#>, .<#Side#>), withMode: .<#SwipyCellMode#>, swipeView: listView, swipeColor: brownColor, completion: nil)

//#-end-editable-code
//#-hidden-code
cell.setCompletionBlocks(completionHandler)

  return cell
}

private func completionHandler(cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) {
    assessmentStatus.states.insert(state)
    if mode == .toggle { assessmentStatus.toggle = true }
    if mode == .exit {
        assessmentStatus.exit = true
        deleteCell(cell)
    }

    checkAssessment()
}

private func checkAssessment() {
    if assessmentStatus.states.count >= 4
        && assessmentStatus.toggle == true
        && assessmentStatus.exit == true {
        PlaygroundPage.current.assessmentStatus = .pass(message: "### Great work! 👊 \n\n Now you know about the many ways you can use SwipyCell. \n\n To get a short summary and find out where to get SwipyCell,\n see the **[last page](@next)**")
    }
}

private func deleteCell(_ cell: SwipyCell) {
    numberItems = 0
    let indexPath = tableView.indexPath(for: cell)
    tableView.deleteRows(at: [indexPath!], with: .fade)

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
        self.numberItems = 1
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

}

extension UIImageView {
    convenience init(imageNamed: String) {
        let image = UIImage(named: imageNamed)
        self.init(image: image)
    }
}

PlaygroundPage.current.liveView = HowToViewController()
//#-end-hidden-code
