//
//  ViewController.swift
//  LiveStreamDemo
//
//  Created by User on 2022/6/1.
//

import UIKit
import IJKMediaFramework

class ViewController: UIViewController {
    
    var player: IJKFFMoviePlayerController!
    
    var statusLabel: UILabel = {
        let stateLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 80, height: 40))
        stateLabel.text = "未連接"
        stateLabel.textColor = UIColor.white
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        return stateLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let player = IJKFFMoviePlayerController(contentURLString: "", with: IJKFFOptions.byDefault())
        
        player?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        player?.view.frame = self.view.bounds // previewView.bounds
        
//        self.view.autoresizesSubviews = true
        self.view.addSubview((player?.view)!)
        self.player = player
        player?.prepareToPlay()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.play()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player, queue: OperationQueue.main, using: { [weak self] notification in
            
            guard let this = self else {
                return
            }
            let state = this.player.loadState
            switch state {
            case IJKMPMovieLoadState.playable:
                this.statusLabel.text = "Playable"
            case IJKMPMovieLoadState.playthroughOK:
                this.statusLabel.text = "Playing"
            case IJKMPMovieLoadState.stalled:
                this.statusLabel.text = "Buffering"
                self?.dismiss(animated: true, completion: nil)
            default:
                this.statusLabel.text = "Playing"
            }
        })

    }

}

