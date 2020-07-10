//
//  ShowDetailsViewModel.swift
//  Shows
//
//  Created by mac on 10/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

public final class ShowDetailsViewModel {
        
    let episodes: Binder<[Episode]?> = Binder([])
    let show: Binder<Show>!
    
    var error: Error? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var episodesError: Error? {
          didSet {
              self.showEpisodesErrorClosure?()
          }
      }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingClosure?()
        }
    }
    
    var isLoadingEpisodes: Bool = false {
           didSet {
               self.updateLoadingEpisodesClosure?()
           }
       }
    
    var showAlertClosure: (() -> Void)?
    var showEpisodesErrorClosure: (() -> Void)?
    var updateLoadingClosure: (() -> Void)?
    var updateLoadingEpisodesClosure: (() -> Void)?
    
    init(_ show: Show) {
        self.show = Binder(show)
        
        getShowInfo(show)
        getShowEpisodes(show)
    }
    
    func getShowInfo(_ show: Show) {
        isLoading = true
        
        ShowServices.shared.getShowInfo(show) {[weak self] (show, error) in
            guard let self = self else { return }
            
            self.isLoading = false
            
            DispatchQueue.main.async {
                guard error == nil else {
                    self.error = error
                    return
                }
                
                self.show.value = show!
            }
        }
    }
    
    func getShowEpisodes(_ show: Show) {
        isLoadingEpisodes = true
        
        ShowServices.shared.getShowEpisodes(show) {[weak self] (arrEpisodes, error) in
            guard let self = self else { return }
            
            self.isLoadingEpisodes = false

            DispatchQueue.main.async {
                guard error == nil else {
                    self.episodesError = error
                    return
                }

                self.episodes.value = arrEpisodes
            }
        }
    }
}
