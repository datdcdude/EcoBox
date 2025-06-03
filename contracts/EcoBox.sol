// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EcoBox {
    struct Participant {
        string aliasName;
        uint256 joinCount;
        uint256 currentBoxId;
    }

    struct Box {
        address apex;
        address[] members;
        uint256 tier;
        uint256 capacity;
    }

    mapping(address => Participant) public participants;
    mapping(uint256 => Box) public boxes;
    uint256 public boxCounter;

    constructor() {
        boxCounter = 1;
        _createBox(msg.sender);
    }

    function _createBox(address apex) internal {
        Box storage b = boxes[boxCounter];
        b.apex = apex;
        b.tier = 1;
        b.capacity = 8;
        boxCounter++;
    }

    function setAlias(string memory _alias) public {
        participants[msg.sender].aliasName = _alias;
    }

    function joinBox(string memory _alias) public {
        require(bytes(participants[msg.sender].aliasName).length == 0, "Alias already set");
        participants[msg.sender] = Participant(_alias, 1, boxCounter - 1);
        boxes[boxCounter - 1].members.push(msg.sender);

        if (boxes[boxCounter - 1].members.length == boxes[boxCounter - 1].capacity) {
            address oldApex = boxes[boxCounter - 1].apex;
            _createBox(oldApex);
        }
    }

    function aliasOf(address user) public view returns (string memory) {
        return participants[user].aliasName;
    }

    function getBoxInfoByAddress(address user) public view returns (Participant memory) {
        return participants[user];
    }

    function lastBoxId(address user) public view returns (uint256) {
        return participants[user].currentBoxId;
    }
}
