// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// Simple Lotery contract Description: 
//Manager Deploy the contract and players play in lotery. In lotery, only 1 eth amount is send. Manager can not play in lotery. After all the players played in lotery,  only manager can check winner
//Manager got a profit of 1eth every time lottery played. Other than it all the balance will be added to the winners account.
//Players can not be able to play with same address more than one time
contract lotery{
    address payable manager;
    address payable[] players;
    address payable player_win;
    constructor(){
        manager = payable(msg.sender);
    }
    function alreadyenter() private view returns(bool){
        for(uint i = 0;i<players.length;i++){
            if(players[i] == msg.sender){
                return true;
            }
        }
        return false;
    }
    function send() payable public {
        require(msg.sender != manager, "Manager can't play lottery");
        require(msg.value == 1 ether, "You can only enter amount of 1 Eth");
        require(alreadyenter() == false,"You have already entered your amount");
        players.push(payable(msg.sender));
    }
    function randomNumber_encrypted() private view returns(uint _x){
        _x = uint(keccak256(abi.encodePacked(block.difficulty,block.number,players))); //generating random number
    }
    function winner() public {
        require(msg.sender == manager,"Winner can only be Picked by Manager");
        uint i = randomNumber_encrypted()%players.length;
        player_win = players[i];
        player_win.transfer((address(this).balance)- 1 ether); //1 eth is paid to manager
        manager.transfer(address(this).balance); //Contract balance == 0
        players = new address payable[](0);
    }

}