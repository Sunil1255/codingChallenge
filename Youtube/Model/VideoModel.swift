//
//  VideoModel.swift
//  Youtube
//
//  Created by Sunil Chowdary on 10/06/17.
//  Copyright © 2017 Sunil Chowdary. All rights reserved.
//

import UIKit

class VideoModel {
    var _videoId: String!
    var _channelTitle: String!
    var _thumbnails: String!
    
    var videoId: String {
        if _videoId == nil {
            _videoId = ""
        }
        
        return _videoId
    }
    
    var channelTitle: String {
        if _channelTitle == nil {
            _channelTitle = ""
        }
        
        return _channelTitle
    }
    
    var thumbnails: String {
        if _thumbnails == nil {
            _thumbnails = ""
        }
        
        return _thumbnails
    }
}
