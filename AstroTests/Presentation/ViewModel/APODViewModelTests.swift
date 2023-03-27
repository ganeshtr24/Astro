//
//  APODViewModelTests.swift
//  AstroTests
//
//  Created by Ganesh TR on 27/03/23.
//

import XCTest
@testable import Astro

final class APODViewModelTests: XCTestCase {
    
    static let oldAPOD = APOD(copyright: nil, date: "2023-03-26", explanation: "How far out will humanity explore? If this video's fusion of real space imagery and fictional space visualizations is on the right track, then at least the Solar System. Some of the video's wondrous sequences depict future humans drifting through the rings of Saturn, exploring Jupiter from a nearby spacecraft, and jumping off a high cliff in the low gravity of a moon of Uranus. Although no one can know the future, wandering and exploring beyond boundaries -- both physical and intellectual -- is part of the human spirit and has frequently served humanity well in the past.", url: "//player.vimeo.com/video/108650530?title=0&byline=0&portrait=0&badge=0&color=ffffff", hdurl: nil, title: "Wanderers", thumbnailURL: "https://i.vimeocdn.com/video/498302788-1759ec05c94228b94684cc914ed2cc533feb864b674924022f35c78476e1d684-d_640")
    static let apod = APOD(copyright: "Cari Letelier", date: "2023-03-27", explanation: "Reports of powerful solar flares started a seven-hour quest north to capture modern monuments against an aurora-filled sky. The peaks of iconic Arctic Henge in Raufarhöfn in northern Iceland were already aligned with the stars: some are lined up toward the exact north from one side and toward exact south from the other. The featured image, taken after sunset late last month, looks directly south, but since the composite image covers so much of the sky, the north star Polaris is actually visible at the very top of the frame. Also visible are familiar constellations including the Great Bear (Ursa Major) on the left, and the Hunter (Orion) on the lower right. The quest was successful. The sky lit up dramatically with bright and memorable auroras that shimmered with amazing colors including red, pink, yellow, and green -- sometimes several at once.", url: "https://apod.nasa.gov/apod/image/2303/ArcticHenge_Letelier_960.jpg", hdurl: "https://apod.nasa.gov/apod/image/2303/ArcticHenge_Letelier_1765.jpg", title: "Aurora Over Arctic Henge", thumbnailURL: nil)
    
    var useCase: APODUseCase!
    var viewModel: DefaultAPODViewModel!
    
    
    func test_whenActiveNetworkConnection_thenFetchesAPOD_shouldAlwaysProvideAPOD() {
        useCase = APODMockUseCase(pod: Self.apod, error: nil)
        viewModel = DefaultAPODViewModel(useCase: useCase, imageRepository: nil)
        viewModel.aPod.observe(on: self) { apod in
            if let apod {
                XCTAssertTrue(apod.date == Self.apod.date)
            }
        }
        viewModel.fetchAPOD()
    }
    
    func test_whenApiFailure_thenFetchesAPOD_shouldAlwaysProvideError() {
        let expectation = expectation(description: "test_whenApiFailure_thenFetchesAPOD_shouldAlwaysProvideError")
        expectation.expectedFulfillmentCount = 2
        useCase = APODMockUseCase(pod: nil, error: DataTransferError.networkFailure(.notConnected))
        viewModel = DefaultAPODViewModel(useCase: useCase, imageRepository: nil)
        viewModel.aPod.observe(on: self) { apod in
            XCTAssertNil(apod)
        }
        viewModel.error.observe(on: self) { error in
            expectation.fulfill()
        }
        viewModel.fetchAPOD()
        waitForExpectations(timeout:2, handler: nil)
        XCTAssertNotNil(viewModel.error.value)
    }
    
    func test_whenNoInternetConnection_whereUserAlreadySeenAPODOnce_ShouldAlwaysProvideOldCache () {
        UserDefaults.resetStandardUserDefaults()
        let mockNetworkService = MockNetworkService(data: Self.oldAPOD.toData())
        let defaultTransferService = DefaultDataTransferService(with: mockNetworkService)
        let apodRepository = DefaultAPODRepository(dataTransferService: defaultTransferService, cache: UserDefaultResponseStorage())
        useCase = DefaultAPODUseCase(apodRepository: apodRepository)
        viewModel = DefaultAPODViewModel(useCase: useCase, imageRepository: nil)
        viewModel.fetchAPODWithRequest(APODRequest(thumb: true, date: "26.03.2023"))
        
        viewModel.aPod.observe(on: self) { apod in
            if let apod {
                XCTAssertTrue(apod.date == Self.oldAPOD.date)
            }
        }
        mockNetworkService.data = nil
        mockNetworkService.error = .notConnected
        viewModel.fetchAPODWithRequest(APODRequest(thumb: true, date: "27.03.2023"))
    }
    
    func test_whenUserOpensApp_onActiveInternetConnection_ShouldAlwaysProvideFreshAPOD () {
        UserDefaults.resetStandardUserDefaults()
        let mockNetworkService = MockNetworkService(data: Self.oldAPOD.toData())
        let defaultTransferService = DefaultDataTransferService(with: mockNetworkService)
        let apodRepository = DefaultAPODRepository(dataTransferService: defaultTransferService, cache: UserDefaultResponseStorage())
        useCase = DefaultAPODUseCase(apodRepository: apodRepository)
        viewModel = DefaultAPODViewModel(useCase: useCase, imageRepository: nil)
        viewModel.fetchAPODWithRequest(APODRequest(thumb: true, date: "26.03.2023"))
        viewModel = nil
        viewModel = DefaultAPODViewModel(useCase: useCase, imageRepository: nil)
        viewModel.aPod.observe(on: self) { apod in
            if let apod {
                XCTAssertTrue(apod.date == Self.apod.date)
            }
        }
        mockNetworkService.data = Self.apod.toData()
        viewModel.fetchAPODWithRequest(APODRequest(thumb: true, date: "27.03.2023"))
    }
    
    func test_whenUserOpensApp_onInActiveInternetConnection_ShouldAlwaysProvideError () {
        let expectation = expectation(description: "test_whenUserOpensApp_onInActiveInternetConnection_ShouldAlwaysProvideError")
        expectation.expectedFulfillmentCount = 2
        let mockNetworkService = MockNetworkService(error: .notConnected)
        let defaultTransferService = DefaultDataTransferService(with: mockNetworkService)
        let userDefaults = UserDefaults(suiteName: "test_whenUserOpensApp_onInActiveInternetConnection_ShouldAlwaysProvideError")
        userDefaults!.removePersistentDomain(forName: "test_whenUserOpensApp_onInActiveInternetConnection_ShouldAlwaysProvideError")
        let userDefaultStorage = UserDefaultResponseStorage(userDefault: userDefaults!)
        userDefaultStorage.resetDefault()
        let apodRepository = DefaultAPODRepository(dataTransferService: defaultTransferService, cache: userDefaultStorage)
        useCase = DefaultAPODUseCase(apodRepository: apodRepository)
        viewModel = DefaultAPODViewModel(useCase: useCase, imageRepository: nil)
        viewModel.error.observe(on: self) { _ in
            expectation.fulfill()
        }
        viewModel.fetchAPODWithRequest(APODRequest(thumb: true, date: "27.03.2023"))
        waitForExpectations(timeout:2, handler: nil)
        XCTAssertEqual(viewModel.error.value, "We are not connected to the internet, showing you the last image we have.")
    }
    
}

class MockNetworkService: NetworkService {
    
    var data: Data?
    var error: NetworkError?
    
    init(data: Data? = nil, error: NetworkError? = nil) {
        self.data = data
        self.error = error
    }
    
    func request(endpoint: Astro.Requestable, completion: @escaping CompletionHandler) {
        if let data {
            completion(.success(data))
        } else if let error {
            completion(.failure(error))
        }
    }
}


fileprivate extension APOD {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
