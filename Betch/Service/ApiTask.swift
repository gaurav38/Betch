//
//  ApiTask.swift
//  Betch
//
//  Created by Gaurav Saraf on 8/12/17.
//  Copyright © 2017 Gaurav Saraf. All rights reserved.
//

import Foundation

class ApiTask {
    private var continueExecution: Bool = true
    private let session: URLSession = URLSession.shared
    private var task: URLSessionDataTask? = nil
    private var callBack: ((_ data: AnyObject?) -> Void)? = nil
    public var request: URLRequest!
    public var requestInterval: Int!
    
    init(_ request: URLRequest, _ interval: Int, _ callBack: @escaping (_ data: AnyObject?) -> Void) {
        self.request = request
        self.requestInterval = interval
        self.callBack = callBack
    }
    
    public func start() {
        execute()
    }
    
    public func stop() {
        continueExecution = false
    }
    
    private func resume() {
        if continueExecution {
            execute()
        }
    }
    
    private func execute() {
        self.initSessionTask()
        self.task?.resume()
        
        let delayInNanoSeconds = UInt64(requestInterval) * NSEC_PER_SEC
        let time = DispatchTime.now() + Double(Int64(delayInNanoSeconds)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.resume()
        }
    }
    
    private func initSessionTask() {
        self.task = session.dataTask(with: self.request) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                self.callBack!(nil)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("\(error.debugDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("[taskForGETMethod]: Request code other than 2xx")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            let dataToReturn = self.convertDataWithCompletionHandler(data)
            self.callBack!(dataToReturn)
        }
    }
    
    private func convertDataWithCompletionHandler(_ data: Data) -> AnyObject {
        
        let newData = data
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        } catch {
            print("Could not parse the data as JSON: '\(data)'")
            print("Could not parse the data as JSON")
        }
        return parsedResult
    }
}
