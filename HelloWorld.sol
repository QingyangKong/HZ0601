// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract MyToken is ERC721, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;
    
    string constant METADATA_SHIBAINU = "ipfs://QmXw7TEAJWKjKifvLE25Z9yjvowWk2NWY3WgnZPUto9XoA";
    string constant METADATA_HUSKY = "ipfs://QmTFXZBmmnSANGRGhRVoahTTVPJyGaWum8D3YicJQmG97m";
    string constant METADATA_BULLDOG = "ipfs://QmSM5h4WseQWATNhFWeCbqCTAGJCZc11Sa1P5gaXk38ybT";

    address public maticToUsd = 0x001382149eBa3441043c1c66972b4772963f5D43;
    uint256 public constant MINIMUM_VALUE = 5 * 10 ** 16; // 0.05usd

    AggregatorV3Interface dataFeed;

    constructor()
        ERC721("MyToken", "MTK")
        Ownable(msg.sender)
    {
        dataFeed = AggregatorV3Interface(maticToUsd);
    }

    function safeMint() public payable {
        require(convertMaticToUsd(msg.value) > MINIMUM_VALUE, "please send more matic");
        // convert value from ether to usd
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, METADATA_SHIBAINU);
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