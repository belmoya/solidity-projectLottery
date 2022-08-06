//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Lottery{
    uint public minFee;
    address public owner;
    address[] public players;
    mapping(address => uint) public playerBalances;

    constructor(uint _minFee){
        minFee = _minFee;
        owner = msg.sender;
    }

    function play() public payable minFeePay {
        require(msg.value >= minFee, "Hola"); //validamos valor que los participantes pondrán para sumarse a la lotería
        players.push(msg.sender); //participantes que se unen a la loteria
        playerBalances[msg.sender] += msg.value;
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function getRandomNumber() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }
    
    function pickWinner() public onlyOwner {
        uint index = getRandomNumber() % players.length;
        (bool sucess, ) = players[index].call{value:getBalance()}("");
        require(sucess, "FALLO, reintente");
        players = new address [](0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier minFeePay(){
        require(msg.value >= minFee, "MAs dinero porfis");
        _;
    } 
}

