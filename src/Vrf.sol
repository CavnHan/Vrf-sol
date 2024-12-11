pragma solidity ^0.8.0;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Vrf is OwnableUpgradeable {
    constructor() {
        _disableInitializers();
    }

    address public VrfManager;

    struct RequestStatus {
        bool fulfilled;
        uint256[] randomWords;
    }
    modifier onlyManager() {
        require(
            msg.sender == address(VrfManager),
            "Only manager can call this function"
        );
        _;
    }

    event RequestSend(uint256 requestId, uint256 numwords, address current);
    event FillRandomWords(uint256 requestId, uint256[] randomWords);

    mapping(uint256 => RequestStatus) public requestMappings;
    uint256[] public requestIds;
    uint256 public lastRequestId;

    function initialize(address initOwner, address Manager) public initializer {
        __Ownable_init(initOwner);
        VrfManager = Manager;
    }

    function requestRandWords(
        uint256 requestId,
        uint256 numwords
    ) external onlyOwner {
        requestMappings[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSend(requestId, numwords, address(this));
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) external onlyManager {
        requestMappings[requestId] = RequestStatus({
            randomWords: randomWords,
            fulfilled: true
        });
        emit FillRandomWords(requestId, randomWords);
    }

    function getRequestStatus(
        uint256 _requestId
    ) external view returns (bool fulfilled, uint256[] memory randomWords) {
        return (
            requestMappings[_requestId].fulfilled,
            requestMappings[_requestId].randomWords
        );
    }
    function setManager(address newManager) public onlyOwner {
        VrfManager = newManager;
    }
}
