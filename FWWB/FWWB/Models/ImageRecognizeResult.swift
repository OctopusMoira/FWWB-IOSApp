//
//  ImageRecognizeResult.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/3/2.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit

struct ImageRecognizeResult {
    let landmark: String
    let city: String
    let imgUrl: String
}

struct EntityAnnotation: Codable {
    var mid: String?
    var locale: String?
    var description: String
    var score: Float
    var confidence: Float?
    var topicality: Float?
    var boundingPoly: BoundingPoly?
    var locations: Array<LocationInfo>
    var properties: Array<Property>?
    
    private enum CodingKeys: String, CodingKey {
        case locale, confidence, topicality, boundingPoly, properties
        case mid, description, score, locations
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locale = try container.decodeIfPresent(String.self, forKey: .locale) ?? nil
        self.confidence = try container.decodeIfPresent(Float.self, forKey: .confidence) ?? nil
        self.topicality = try container.decodeIfPresent(Float.self, forKey: .topicality) ?? nil
        self.boundingPoly = try container.decodeIfPresent(BoundingPoly.self, forKey: .boundingPoly) ?? nil
        self.properties = try container.decodeIfPresent(Array<Property>.self, forKey: .properties) ?? nil
        self.mid = try container.decodeIfPresent(String.self, forKey: .mid)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)!
        self.score = try container.decodeIfPresent(Float.self, forKey: .score)!
        self.locations = try container.decodeIfPresent(Array<LocationInfo>.self, forKey: .locations)!
    }
}

// request json struct
struct Requests: Codable {
    var requests: Array<Request>
}
struct Request: Codable {
    var image: Image
    var features: Array<Feature>
}


struct Image: Codable {
    var content: String
}
struct Feature: Codable {
    var type: FeatureType
}
enum FeatureType: String, Codable {
    case LANDMARK_DETECTION
    case TEXT_DETECTION
}

// response json struct
struct Responses: Codable {
    var responses: Array<Response>
}

struct Response: Codable {
    var landmarkAnnotations: Array<EntityAnnotation>
    
    private enum CodingKeys: String, CodingKey { case landmarkAnnotations }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.landmarkAnnotations = try container.decodeIfPresent(Array<EntityAnnotation>.self, forKey: .landmarkAnnotations) ?? [EntityAnnotation]()
    }
}

struct BoundingPoly: Codable {
    var vertices: Array<Vertex>
    // var normalizedVertices: Array<NormalizedVertex>
}

struct Vertex: Codable {
    var x: Float
    var y: Float
}

struct NormalizedVertex: Codable {
    var x: Float
    var y: Float
}

struct LocationInfo: Codable {
    var latLng: LatLng
}

struct LatLng: Codable {
    var latitude: Float
    var longitude: Float
}

struct Property: Codable {
    var name: String
    var value: String
    var uint64Value: String
}

struct TextResponses: Codable{
    var responses : Array<TextResponse>
}

struct TextResponse: Codable {
    var textAnnotations: Array<TextAnnotation>?
    var fullTextAnnotation: FullTextAnnotation?
}

struct TextAnnotation: Codable{
    var locale: String?
    var description: String?
    var boundingPoly: BoundingPoly?
}

struct FullTextAnnotation: Codable {
    var pages: Array<Page>?
    var text: String?
}

struct Page: Codable{
    var property: TextProperty?
    var width: Int?
    var height: Int?
    var blocks: Array<Block>?
    var confidence: Float?
}

struct TextProperty: Codable {
    var detectedLanguages: Array<DetectedLanguage>?
    var detectedBreak: DetectedBreak?
}

struct DetectedLanguage: Codable{
    var languageCode: String?
    var confidence: Float?
}

struct DetectedBreak: Codable{
    var type: String?
    var isPrefix: Bool?
}

struct Paragraph: Codable{
    var property: TextProperty?
    var boundingBox: BoundingPoly?
    var words: Array<Word>?
    var confidence: Float?
}

struct Word: Codable{
    var property: TextProperty?
    var boundingBox: BoundingPoly?
    var symbols: Array<Symbol>?
    var confidence: Float?
}

struct Symbol: Codable {
    var property: TextProperty?
    var boundingBox: BoundingPoly?
    var text: String?
    var confidence: Float?
}

struct Block: Codable{
    var property: TextProperty?
    var boundingBox: BoundingPoly?
    var paragraphs: Array<Paragraph>?
    var blockType: String?
    var confidence: Float?
}
