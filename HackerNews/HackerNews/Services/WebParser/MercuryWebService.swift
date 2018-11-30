//
//  MercuryWebService.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/29/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct MercuryContent {
    let content: String?
}

extension MercuryContent: ObjectType {
    init?(json: JSONDictionary) {
        content = json["content"] as? String
    }
}

extension MercuryContent {
    struct Requests {
        static func content(for urlString: String) -> Request<MercuryContent> {
            let header = [
                "x-api-key": "<put your mercury id here>"
            ]
            return Request(query: "parser?url=\(urlString)", method: .get, headers: header)
        }
    }
}

struct MercuryWebService {
    static func fetchContent(for urlString: String?, complete: @escaping ((String?) -> Void)) {
        guard let url = urlString else {
            complete(nil)
            return
        }
        
        let request = MercuryContent.Requests.content(for: url)
        Server(apiBase: "https://mercury.postlight.com/").request(request) { content, error in
            complete(content?.content)
        }
    }
}
