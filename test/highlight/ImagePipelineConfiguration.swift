// The MIT License (MIT)
//
// Copyright (c) 2015-2024 Alexander Grebenyuk (github.com/kean).

import Foundation
// ^ @keyword.import

extension ImagePipeline {
    /// The pipeline configuration.
    public struct Configuration: @unchecked Sendable {
        /// Image cache used by the pipeline.
        public var imageCache: (any ImageCaching)? {
            //                  ^ @keyword
            //                      ^ @type
            // This exists simply to ensure we don't init ImageCache.shared if the
            // user provides their own instance.
            get { isCustomImageCacheProvided ? customImageCache : ImageCache.shared }
            set {
                customImageCache = newValue
                isCustomImageCacheProvided = true
            }
        }

        /// Default implementation uses shared ``ImageDecoderRegistry`` to create
        /// a decoder that matches the context.
        public var makeImageDecoder: @Sendable (ImageDecodingContext) -> (any ImageDecoding)? = {
            //                                                            ^ @keyword
            //                                                                ^ @type
            ImageDecoderRegistry.shared.decoder(for: $0)
        }

        /// Instantiates a pipeline configuration.
        ///
        /// - parameter dataLoader: `DataLoader()` by default.
        // NOTE: Surgical change on next line: renamed `dataLoader` to `any` to show it is a contextual keyword
        public init(any: any DataLoading = DataLoader()) {
            //      ^ @variable.parameter
            //           ^ @keyword
            //               ^ @type
            self.dataLoader = any
        }
}
