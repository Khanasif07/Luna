//
//   .swift
//  Luna
//
//  Created by Admin on 08/07/21.
//

import UIKit
class HomeBottomSheetVC: UIViewController {
  
    //MARK:- OUTLETS
    //==============
    @IBOutlet weak var mainCotainerView: UIView!
    @IBOutlet weak var bottomLayoutConstraint : NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    
    //MARK:- VARIABLE
    //================
    var topSafeArea: CGFloat = 0.0
    var bottomSafeArea: CGFloat = 0.0
    var cgmDataArray : [ShareGlucoseData] = []
    lazy var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closePullUp))
    var fullView: CGFloat {
        return UIApplication.shared.statusBarHeight + 51.0
    }
    var partialView: CGFloat {
        return (textContainerHeight ?? 0.0) + UIApplication.shared.statusBarHeight + (110.5)
    }
    var textContainerHeight : CGFloat? {
        didSet{
            self.mainTableView.reloadData()
        }
    }
    var cgmData : [ShareGlucoseData] = []{
        didSet{
            self.cgmDataArray = cgmData
            self.mainTableView.reloadData()
        }
    }
   
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.isMovingToParent else { return }
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainCotainerView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15)
        mainCotainerView.addShadowToTopOrBottom(location: .top, color: UIColor.black.withAlphaComponent(0.15))
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                    self.mainTableView.isScrollEnabled = false
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                    self.mainTableView.isScrollEnabled = true
                }
                
            }) { (completion) in
            }
        }
    }
}

//MARK:- Private functions
//========================
extension HomeBottomSheetVC {
    
    private func initialSetup() {
        setupTableView()
        addObserver()
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(HomeBottomSheetVC.panGesture))
        view.addGestureRecognizer(gesture)
        setupSwipeGesture()
    }
    
    private func setupTableView() {
        self.mainTableView.isScrollEnabled = true
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: BottomSheetTopCell.self)
        self.mainTableView.registerCell(with: BottomSheetChartCell.self)
        self.mainTableView.registerCell(with: BottomSheetInsulinCell.self)
        self.mainTableView.registerCell(with: BottomSheetBottomCell.self)
        setupfooterView()
    }
    
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(bleDidUpdateValue), name: .BleDidUpdateValue, object: nil)
    }
    
    @objc func bleDidUpdateValue(notification : NSNotification){
        if let dict = notification.object as? NSDictionary {
                print(dict)
        }
        self.mainTableView.reloadData()
    }
    
    private func setupfooterView(){
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.frame.width, height: 100.0)))
        self.mainTableView.tableFooterView = view
    }
    
    private func setupSwipeGesture() {
        swipeDown.direction = .down
        swipeDown.delegate = self
        mainTableView.addGestureRecognizer(swipeDown)
    }
    
    @objc func closePullUp() {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
        })
    }
    
    func rotateLeft(dropdownView: UIView,left: CGFloat = -1) {
        UIView.animate(withDuration: 1.0, animations: {
            dropdownView.transform = CGAffineTransform(rotationAngle: ((180.0 * CGFloat(Double.pi)) / 180.0) * CGFloat(left))
            self.view.layoutIfNeeded()
        })
    }
          
}

//MARK:- UITableViewDelegate
//========================
extension HomeBottomSheetVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            return SystemInfoModel.shared.insulinData?.endIndex ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueCell(with: BottomSheetTopCell.self, indexPath: indexPath)
            cell.populateCell()
            return cell
        case 2:
            let cell = tableView.dequeueCell(with: BottomSheetInsulinCell.self, indexPath: indexPath)
            cell.populateCell()
            return cell
        case 3:
            let cell = tableView.dequeueCell(with: BottomSheetBottomCell.self, indexPath: indexPath)
            cell.topLineDashView.isHidden = indexPath.row == 0
            if let insulinData = SystemInfoModel.shared.insulinData {
            cell.timeLbl.text = (Double(insulinData[indexPath.row].date) ).getDateTimeFromTimeInterval("h:mm a")
            cell.unitLbl.text = (insulinData[indexPath.row].insulinData ?? "") + " Units"
            }
            return cell
        default:
            let cell = tableView.dequeueCell(with: BottomSheetChartCell.self, indexPath: indexPath)
            cell.cgmData = cgmDataArray
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- Gesture Delegates
//========================
extension HomeBottomSheetVC : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //Identify gesture recognizer and return true else false.
        if (!mainTableView.isDragging && !mainTableView.isDecelerating) {
            return gestureRecognizer.isEqual(self.swipeDown) ? true : false
        }
        return false
    }
}

extension HomeBottomSheetVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // This will be called every time the user scrolls the scroll view with their finger
        // so each time this is called, contentOffset should be different.
        print(self.mainTableView.contentOffset.y)
        if self.mainTableView.contentOffset.y < 0{
            self.mainTableView.isScrollEnabled = false
            print(self.mainTableView.contentOffset.y)
        } else if self.mainTableView.contentOffset.y == 0.0 {
            self.mainTableView.isScrollEnabled = false
            print(self.mainTableView.contentOffset.y)
        } else{
            self.mainTableView.isScrollEnabled = true
        }
        //Additional workaround here.
    }
}


