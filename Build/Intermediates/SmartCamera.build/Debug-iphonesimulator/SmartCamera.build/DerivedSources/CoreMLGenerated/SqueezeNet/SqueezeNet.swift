//
// SqueezeNet.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class SqueezeNetInput : MLFeatureProvider {

    /// Input image to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 227 pixels wide by 227 pixels high
    var image: CVPixelBuffer
    
    var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    init(image: CVPixelBuffer) {
        self.image = image
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class SqueezeNetOutput : MLFeatureProvider {

    /// Probability of each category as dictionary of strings to doubles
    let classLabelProbs: [String : Double]

    /// Most likely image category as string value
    let classLabel: String
    
    var featureNames: Set<String> {
        get {
            return ["classLabelProbs", "classLabel"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "classLabelProbs") {
            return try! MLFeatureValue(dictionary: classLabelProbs as [NSObject : NSNumber])
        }
        if (featureName == "classLabel") {
            return MLFeatureValue(string: classLabel)
        }
        return nil
    }
    
    init(classLabelProbs: [String : Double], classLabel: String) {
        self.classLabelProbs = classLabelProbs
        self.classLabel = classLabel
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class SqueezeNet {
    var model: MLModel

    /**
        Construct a model with explicit path to mlmodel file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
    convenience init() {
        let bundle = Bundle(for: SqueezeNet.self)
        let assetPath = bundle.url(forResource: "SqueezeNet", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as SqueezeNetInput
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as SqueezeNetOutput
    */
    func prediction(input: SqueezeNetInput) throws -> SqueezeNetOutput {
        let outFeatures = try model.prediction(from: input)
        let result = SqueezeNetOutput(classLabelProbs: outFeatures.featureValue(for: "classLabelProbs")!.dictionaryValue as! [String : Double], classLabel: outFeatures.featureValue(for: "classLabel")!.stringValue)
        return result
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - image: Input image to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 227 pixels wide by 227 pixels high
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as SqueezeNetOutput
    */
    func prediction(image: CVPixelBuffer) throws -> SqueezeNetOutput {
        let input_ = SqueezeNetInput(image: image)
        return try self.prediction(input: input_)
    }
}
