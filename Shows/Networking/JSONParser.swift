//
//  JSONParser.swift
//  Shows
//
//  Created by mac on 02/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation


class JSONParser {
    static let shared = JSONParser()
    
    func parseJSON<T: Decodable>(ofType: T.Type, _ data: Data) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            
            return decodedData
        }
        catch (let error) {
            print(error.localizedDescription)
            
            return nil
        }
    }
    
    func parseToJSON(_ data: Data) -> [String : Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            
            return json
        }
        catch (let error) {
            print(error.localizedDescription)
            
            return nil
        }
    }
}
