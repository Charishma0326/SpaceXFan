//
//  FavoriteRockets.swift
//  SpaceX_Fan
//
//  Created by YeshwantSatya on 04/08/21.
//

import UIKit
import Alamofire
import AlamofireImage

class FavoriteRockets: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableRef: UITableView!

    var reuse = ReuseModelClass()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reuse.urlStr = "https://api.spacexdata.com/v4/launches/"
        
        getFavoriteRocketsListService()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {

        tableRef.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reuse.rocketNameArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:RocketsListCell! = tableRef.dequeueReusableCell(withIdentifier: "cell") as? RocketsListCell
        
        
        let nameStr = "Name: "
        let rocketNmStr = reuse.rocketNameArr[indexPath.row] as? String
        cell.rocketName.text = nameStr + rocketNmStr!
        
        let infoStr = "Flight Number: "
        let rocketNumStr = reuse.rocketFlightNumArr[indexPath.row] as? String
        cell.flightNum.text = infoStr + rocketNumStr!

        
        AF.request(reuse.imgArr[indexPath.row] as! String).responseData { (response) in
            if response.error == nil {
                print(response.result)
                
                // Show the downloaded image:
                if let data = response.data {
                    cell.tbImgRef.image = UIImage(data: data)
                }
            }
        }
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RocketDetails") as? RocketDetails
        vc?.idStr = (reuse.idArr[indexPath.row] as? String)!
        
        self.navigationController?.pushViewController(vc!, animated: false)
        
    }
    
    func getFavoriteRocketsListService() {
        
        AF.request(reuse.urlStr).responseJSON { response in
            
            print(response)
            
            if let value = response.value {
                
                print(value)
                
                let arr = value as! NSArray
                
                print(arr.count)
                
                for i in (0..<arr.count).reversed() {
                    
                    let dict = arr [i] as! NSDictionary
                    
                    self.reuse.rocketNameArr .append(dict["name"] as! NSString)
                    self.reuse.idArr .append(dict["id"] as! NSString)
                    
                    let str = dict["flight_number"] as! NSNumber
                    self.reuse.rocketFlightNumArr .append(str.stringValue)
                    
                    if  (dict["details"] != nil) {
                        
                        self.reuse.rocketDetailsArr .append(dict["details"] as? NSString ?? String())
                        
                        
                        
                    }
                    
                    else{
                        
                        
                        self.reuse.rocketDetailsArr .append("No Details")
                        
                    }
                    
                    
                    
                    let linksDict = dict["links"] as! NSDictionary
                    let patchDict = linksDict["patch"] as! NSDictionary
                    
                    
                    if  (patchDict["small"] != nil) {
                        
                        self.reuse.imgArr .append(patchDict["small"] as? NSString ?? String())
                        
                        
                        
                    }
                    
                    else{
                        
                        
                        self.reuse.imgArr .append(" ")
                        
                    }
                    
                    
                }
                
                
                self.tableRef.reloadData()
                
            }
            
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
