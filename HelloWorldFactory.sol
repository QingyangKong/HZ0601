//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {HelloWorld} from "./HelloWorld.sol";

contract HelloWorldFactory {
    HelloWorld[] public hws;

    function createFactory() public {
        HelloWorld hw = new HelloWorld();
        hws.push(hw);
    }

    function setWord(uint256 index, string calldata word) public {
        hws[index].addToWhiteList(address(this));
        hws[index].setWord(word);
    }

    function getWord(uint256 index) public view returns(string memory) {
        return hws[index].addrToWord(address(this));
    }
}

