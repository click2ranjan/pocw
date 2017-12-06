//
//  ViewController.swift
//  POCTest
//
//  Created by Ranjan Mallick on 06/12/17.
//  Copyright © 2017 Ranjan Mallick. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // table instance
    private var myTableView: UITableView!
    //top navigation instance
    private var myNavigationbar:UINavigationBar!
    //Mutable array for Row data
    private var myDataArray:NSMutableArray!
    //Dummy Data since json data is not working
    private let myTitle: NSArray = ["Beavers","Flag","Transportation"]
    private let myDescription: NSArray = ["Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony","","It is a well known fact that polar bears are the main mode of transportation in Canada. They consume far less gas and have the added benefit of being difficult to steal."]
    private let myImageURL: NSArray = ["http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg","http://images.findicons.com/files/icons/662/world_flag/128/flag_of_canada.png","http://1.bp.blogspot.com/_VZVOmYVm68Q/SMkzZzkGXKI/AAAAAAAAADQ/U89miaCkcyo/s400/the_golden_compass_still.jpg"]
    private let cellId = "cellId"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.red
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        //table instance
        self.myTableView = UITableView(frame: CGRect(x: 0, y: 80, width: displayWidth, height: displayHeight - 80))
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.view.addSubview(myTableView)
        self.myTableView.register(CustomTableCell.self, forCellReuseIdentifier: cellId)
        self.myTableView.rowHeight = UITableViewAutomaticDimension
        self.myTableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        //navogation instance
        myNavigationbar  = UINavigationBar(frame: CGRect(x: 0, y: 0, width: displayWidth, height: 80))
        self.view.addSubview(myNavigationbar);
        let navItem = UINavigationItem(title: "About Canada");
        myNavigationbar.setItems([navItem], animated: false);
        
        
        
        //json parsing call
       // self.parseJSON()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    //Dynamic Row height
    // override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //  return UITableViewAutomaticDimension
    //}
    
    //Estinamting row height
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        // displaying Title on Navigarion Bar
        self.navigationController?.isNavigationBarHidden = false
        
        //For Reinitialising the layout if new view added
        self.myTableView.layoutSubviews()
        
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // calculate line height
    func lines(label: UILabel) -> Int {
        let textSize = CGSize(width: label.frame.size.width, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(label.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(label.font.lineHeight))
        let lineCount = rHeight/charSize
        return lineCount
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomTableCell
        
        cell.cellLabelTitle.text = myTitle.object(at: indexPath.row) as? String
        
        cell.cellLabelDescription.text = myDescription.object(at: indexPath.row) as? String
        
        //let rowHeight: Int = self.lines(label: cell.cellLabelDescription)
        // cell.cellLabelDescription.numberOfLines = rowHeight
        // cell.cellLabelDescription.sizeToFit()
        
        let urlimage = myImageURL.object(at: indexPath.row) as! String
        print(urlimage)
        
        
        cell.cellImageView.downloadImageFrom(link: myImageURL.object(at: indexPath.row) as! String, contentMode: UIViewContentMode.scaleAspectFit)
        //myTableView.estimatedRowHeight = 200.0
        //cell.imgWrapperHeight.frame.size.height = rowHeight
        //cell.frame.size.height = CGFloat(rowHeight * 10)
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseJSON()
    {
        let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            // Checkpoint for ERROR
            guard error == nil else {
                print("returning error")
                return
            }
            
            //Checkpoint for nil data
            guard let content = data else {
                print("not returning data")
                return
            }
            
            // Bad Data processing
            var dataString = String(data: data!, encoding:.utf8)!
            dataString = dataString.replacingOccurrences(of: "\\", with: "'")
            let cleanData: NSData = dataString.data(using: String.Encoding.utf8)! as NSData
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            
            if let array = json["rows"] as? [String] {
                print(" containing JSON")
            }
            
            // Refreshing Tableview without Locking main thread
            DispatchQueue.main.async {
                //self.tableView.reloadData()
            }
            
        }
        
        task.resume()
        
    }
    
    
    //Orientation handling
    override var shouldAutorotate: Bool {
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        self.myTableView.frame = CGRect(x: 0, y: 80, width: displayWidth, height: displayHeight - 80)
        self.myNavigationbar.frame  = CGRect(x: 0, y: 0, width: displayWidth, height: 80)
        return true
    }
    //Orientation Supporting
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeLeft]
        
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// Image downloading using GCD
extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            
            DispatchQueue.main.async {
                //print(link)
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}


// Custom Cell  Class
class CustomTableCell: UITableViewCell {
    var cellLabelTitle: UILabel!
    var cellLabelDescription: UILabel!
    var cellImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellLabelTitle = UILabel(frame: CGRect(x: 100, y: 0, width: 200, height: 20))
        cellLabelTitle.textAlignment = .left
        addSubview(cellLabelTitle)
        
        cellLabelDescription = UILabel(frame: CGRect(x: 100, y: 20, width: 220, height: 80))
        cellLabelDescription.textAlignment = .left
        cellLabelDescription.lineBreakMode = .byWordWrapping
        cellLabelDescription.numberOfLines = 20
        cellLabelDescription.font =  UIFont.systemFont(ofSize: 12)
        addSubview(cellLabelDescription)
        
        cellImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cellImageView.backgroundColor = UIColor.clear
        
        addSubview(cellImageView)
        
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


