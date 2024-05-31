//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract HelloWorld {
    string public defaultWord = "Hello World";
    mapping(address => string) public addrToWord;
    mapping(address => bool) public whiteList;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function setWord(string calldata _word) public {
        require(whiteList[msg.sender], "only address in whitelist can call the function");
        addrToWord[msg.sender] = _word;
    }

    function addToWhiteList(address addrToAdd) public {
        require(msg.sender == owner, "only owner has permission to call the function");
        whiteList[addrToAdd] = true;
    }
}