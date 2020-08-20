pragma solidity >=0.4.22 <0.7.0;

contract Event {
   
    uint8 public boardSize = 3;

    address[3][3] borad;

    address public player1;
    address public player2;

    constructor () public{
        player1 = msg.sender;
    }
    
    function joinGame() public{
        //確認玩家2未被使用
        assert(player2 == address(0));
        player2 = msg.sender;
    }
   
    
}