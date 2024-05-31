// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";



contract MyToken is ERC721, ERC721URIStorage, VRFConsumerBaseV2Plus {
    uint256 private _nextTokenId;
    
    string constant METADATA_SHIBAINU = "ipfs://QmXw7TEAJWKjKifvLE25Z9yjvowWk2NWY3WgnZPUto9XoA";
    string constant METADATA_HUSKY = "ipfs://QmTFXZBmmnSANGRGhRVoahTTVPJyGaWum8D3YicJQmG97m";
    string constant METADATA_BULLDOG = "ipfs://QmSM5h4WseQWATNhFWeCbqCTAGJCZc11Sa1P5gaXk38ybT";

    address public maticToUsd = 0x001382149eBa3441043c1c66972b4772963f5D43;
    uint256 public constant MINIMUM_VALUE = 5 * 10 ** 16; // 0.05usd

    AggregatorV3Interface dataFeed;

    // add config here
    uint256 s_subscriptionId;
    address vrfCoordinator = //...;
    bytes32 s_keyHash = //...;
    uint32 callbackGasLimit = //...;
    uint16 requestConfirmations = //...;
    uint32 numWords = //...;

    mapping(uint256 => uint256) public requestIdToTokenId;

    constructor(uint256 subscriptionId)
        ERC721("MyToken", "MTK")
        VRFConsumerBaseV2Plus(vrfCoordinator) 
    {
        s_subscriptionId = subscriptionId;
        dataFeed = AggregatorV3Interface(maticToUsd);
    }

    function safeMint() public payable {
        require(convertMaticToUsd(msg.value) > MINIMUM_VALUE, "please send more matic");
        // convert value from ether to usd
        uint256 tokenId = _nextTokenId++;
        
        // send request here
        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                //....
            })
        );
        requestIdToTokenId[requestId] = tokenId;

        _safeMint(msg.sender, tokenId);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override {
        uint256 tokenId = requestIdToTokenId[requestId];
        uint256 randomNumber = randomWords[0] % 3;

        if(randomNumber == 1) {
            // set token uri here
        } else if(randomNumber == 2) {
            // set token uri here
        } else {
            // set token uri here
        }
    }


    function convertMaticToUsd(uint256 maticAmount) public view returns(uint256) {
        uint256 maticPrice =  uint256(getChainlinkDataFeedLatestAnswer());
        return maticAmount * maticPrice / (10**8);
    }

    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}