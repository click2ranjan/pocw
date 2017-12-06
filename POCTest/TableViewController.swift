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
    private var myDataArray:NSArray!
   
    
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
        self.view.addSubview(myTableView)
        self.myTableView.register(CustomTableCell.self, forCellReuseIdentifier: cellId)
        
        self.myTableView.rowHeight = UITableViewAutomaticDimension
        self.myTableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        //navogation instance
        myNavigationbar  = UINavigationBar(frame: CGRect(x: 0, y: 0, width: displayWidth, height: 80))
        self.view.addSubview(myNavigationbar);
        //let navItem = UINavigationItem(title: "About Canada");
        //myNavigationbar.setItems([navItem], animated: false);
        
        
        
        
        
        //json parsing call
        self.parseJSON()
        
        
        
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
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        return 0
//    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.myDataArray.count
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
        
        let SingleData = self.myDataArray.object(at: indexPath.row) as! NSDictionary
        
        if (SingleData.value(forKey: "title") as? String) != nil {
            // hey hey -- we got the `id` we needed!
            // TODO: parse the rest of the JSON...
            cell.cellLabelTitle.text = SingleData.value(forKey: "title") as? String
        }
        
        if (SingleData.value(forKey: "description") as? String) != nil {
            // hey hey -- we got the `id` we needed!
            // TODO: parse the rest of the JSON...
            cell.cellLabelDescription.text = SingleData.value(forKey: "description") as? String
        }
        if (SingleData.value(forKey: "imageHref") as? String) != nil {
            // hey hey -- we got the `id` we needed!
            // TODO: parse the rest of the JSON...
            let imageURL = SingleData.value(forKey: "imageHref") as? String
            
            cell.cellImageView.downloadImageFrom(link: imageURL!, contentMode: UIViewContentMode.scaleAspectFit)
        }
        
        
        
        
        
        
        //cell.cellLabelDescription.text = myDescription.object(at: indexPath.row) as? String
        
        //let rowHeight: Int = self.lines(label: cell.cellLabelDescription)
        // cell.cellLabelDescription.numberOfLines = rowHeight
        // cell.cellLabelDescription.sizeToFit()
        
//        let urlimage = myImageURL.object(at: indexPath.row) as! String
//        print(urlimage)
        
        
        //cell.cellImageView.downloadImageFrom(link: myImageURL.object(at: indexPath.row) as! String, contentMode: UIViewContentMode.scaleAspectFit)
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
    
    @objc func parseJSON()
    {
        let url1 = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
        
        if let url = url1 {
            if let data = try? Data(contentsOf: url as URL) {
                do {
                    
                    let responseStrInISOLatin = String(data: data, encoding: String.Encoding.isoLatin1)
                    guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                        print("could not convert data to UTF-8 format")
                        return
                    }
                    do {
                        let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                        let ResponceDictionary = responseJSONDict as? NSDictionary
                        
                        let rowTitle = ResponceDictionary?.value(forKey: "title")
                        self.myDataArray = ResponceDictionary?.value(forKey: "rows") as! NSArray
                        self.myTableView.dataSource = self
                        self.myTableView.delegate = self
                        self.myTableView.reloadData()
                        
                        let navItem = UINavigationItem(title: rowTitle as! String);
                        myNavigationbar.setItems([navItem], animated: false);
                        let refreshItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: nil, action: #selector(parseJSON))
                        navItem.rightBarButtonItem = refreshItem
                        myNavigationbar.setItems([navItem], animated: false)
                        
                        //print(dict)
                    } catch {
                        print(error)
                    }
                    
                    
                    //let parsedData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                    
                    //Store response in NSDictionary for easy access
                    //let dict = parsedData as? NSDictionary
                    
                    //let currentConditions = "\(dict!["currently"]!)"
                    
                    //This produces an error, Type 'Any' has no subscript members
                    //let currentTemperatureF = ("\(dict!["currently"]!["temperature"]!!)" as NSString).doubleValue
                    
                    //Display all current conditions from API
                    //print(currentConditions)
                    
                    //Output the current temperature in Fahrenheit
                    //print(currentTemperatureF)
                    
                }
                    //else throw an error detailing what went wrong
                catch let error as NSError {
                    print("Details of JSON parsing error:\n \(error)")
                }
            }
        }
        
    }
   
  override  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let headerHeight: CGFloat
        
        switch section {
            
        case 0:
            // first section for test - set value for height
            headerHeight = 0
            
        default:
            // other Sections - set value for height
            headerHeight = 0
        }
        
        return headerHeight
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


