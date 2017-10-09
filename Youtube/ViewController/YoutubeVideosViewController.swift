//
//  YoutubeVideosViewController.swift
//  Youtube
//
//  Created by Sunil Chowdary on 10/06/17.
//  Copyright © 2017 Sunil Chowdary. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class YoutubeVideosViewController: UIViewController,YTPlayerViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var videosCollectionView: UICollectionView!
    
    
    
    var userName : String!
    var searchController: UISearchController!
    var dataModel: VideoModel!
    var dataModels = [VideoModel]()
    var i = 0
    var searchText: String? {
        didSet {
            searchController?.searchBar.text = searchText
            searchController?.searchBar.placeholder = searchText
            dataModels.removeAll()
            self.videosCollectionView.reloadData()
            downloadYoutubeVideosData()
            
            
        }
    }
    // MARK: View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if UserDefaults.standard.value(forKey: "loggedUser") == nil {
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as!ViewController
            self.present(viewController, animated: true, completion: nil)
            
        }
        else
        {
            userName = UserDefaults.standard.value(forKey: "loggedUser") as! String
            self.setupSearchController()
            searchText = userName
            
            self.navigationItem.title = userName
            
            

            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.layer.cornerRadius = 20
            imageView.layer.masksToBounds = false
            imageView.image = UIImage(named:"profile")

            if UserDefaults.standard.value(forKey: "profilePic") != nil
            {

                    DispatchQueue.main.async() {
                        imageView.image  = UIImage(data: UserDefaults.standard.value(forKey: "profilePic")! as! Data)
                }

            }
            else{
                
                imageView.image = UIImage(named:"profile")
            }
            
            
            
            let rightNavBarButton = UIBarButtonItem(customView:imageView)
            self.navigationItem.rightBarButtonItem = rightNavBarButton

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    
    
    // MARK: SearchController Setup
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for videos"
        searchController.searchBar.text = searchText
        searchController.searchBar.delegate = self
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(red: 234/255, green: 52/255, blue: 36/255, alpha: 1.0)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
       // navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        let leftNavBarButton = UIBarButtonItem(customView:searchController.searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    // MARK: Webservices Integration
    
    func downloadYoutubeVideosData() {
        
        let searchTxt = searchText?.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
         let srt = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(searchTxt!)&chart=mostPopular&type=&forUsername=\(userName!)&key=AIzaSyD8KADhGLnc1g71B1YDr-6RsIJIuHDIs0g&maxResults=25"
        Alamofire.request(srt).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["items"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        
                        var id = obj["id"]?["videoId"]
                         if id! == nil && obj["id"]?["playlistId"] == nil {
                            id = obj["id"]?["playlistId"] as! String
                        }
                        else if id! == nil && obj["id"]?["channelId"] != nil {
                            id = obj["id"]?["channelId"] as! String
                        }
                       
                        let tile =  obj["snippet"]?["title"]
                        let thumbnail = obj["snippet"]?["thumbnails"] as? Dictionary<String, AnyObject>
                        let image = thumbnail?["high"]?["url"]
                        print(tile as! String)
                        self.dataModel = VideoModel()
                        self.dataModel._videoId = id as! String
                        self.dataModel._channelTitle = tile as! String
                        self.dataModel._thumbnails = image as! String
                        self.dataModels.append(self.dataModel)
                       
                    }
                }
                
                self.videosCollectionView.reloadData()
            }
        }
    }
    
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
     
        return UIColor.white
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        
        
        debugPrint("check state " , state)
        
        if state == YTPlayerState.ended && state == YTPlayerState.paused {
            
            playerView.isHidden = true
            videosCollectionView.reloadData()
            
        }
    }
    


}
// MARK: Delegates & Datasource Confirmation

extension YoutubeVideosViewController:UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Searchbar
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar == searchController.searchBar {
            searchBar.placeholder = "Search videos"
        }
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar == searchController.searchBar {
            searchText = searchBar.text
            searchController.isActive = false
        }
    }
    
    //MARK: CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! CollectionViewCellWithImageViewAndLabel
        dataModel = dataModels[indexPath.row]
        
        cell.titleLabel.text = dataModel._channelTitle
     
        cell.playerView.tag = indexPath.row
        cell.playerView.delegate = self
        cell.playerView.isHidden = true
        cell.thumbnailImageView.isHidden = false
        
        let url = URL(string: dataModel._thumbnails)
        
        cell.playerView.load(withVideoId: dataModel._videoId)

        cell.thumbnailImageView.kf.setImage(with: url)

        cell.layer.cornerRadius = 10
        
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.white.cgColor
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 5.0
       cell.layer.masksToBounds = false
        
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        cell.layer.shouldRasterize = true
        
        cell.layer.rasterizationScale = UIScreen.main.scale
        
       

    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        dataModel = dataModels[indexPath.row]
        
        let cell = videosCollectionView!.cellForItem(at: indexPath) as! CollectionViewCellWithImageViewAndLabel

        cell.playerView.isHidden = false
        cell.thumbnailImageView.isHidden = true
        
        cell.playerView.playVideo()

        
    }
    
   
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToNearestVisibleCollectionViewCell()
        }
    }
    
    func scrollToNearestVisibleCollectionViewCell() {
        let visibleCenterPositionOfScrollView = Float(videosCollectionView.contentOffset.x + (self.videosCollectionView!.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<videosCollectionView.visibleCells.count {
            let cell = videosCollectionView.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = videosCollectionView.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.videosCollectionView!.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredVertically, animated: true)
 
            let cell = videosCollectionView!.cellForItem(at: IndexPath(row: closestCellIndex, section: 0)) as! CollectionViewCellWithImageViewAndLabel

            dataModel = dataModels[closestCellIndex]
            
            if closestCellIndex > 1
            {
                cell.playerView.isHidden = false
                cell.playerView.playVideo()
                cell.thumbnailImageView.isHidden = true
                

            }
            
            
        }
    }

    
    
    

}
