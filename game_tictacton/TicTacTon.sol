pragma solidity >=0.4.22 <0.7.0;

contract Event {
   
    uint8 public boardSize = 3;

    address[3][3] board;

    address public player1;
    address public player2;
    address activePlayer;

    constructor () public{
        player1 = msg.sender;
    }
    
    function joinGame() public{
        //確認玩家2未被使用
        assert(player2 == address(0));
        player2 = msg.sender;
        activePlayer = player2;
    }

    function getBoard() view public returns(address[3][3]){
        return board;
    }

    function setStone(uint8 _x, uint8 _y) public {
        require(_x < 3);
        require(_y < 3);
        require(board[_x][_y] == address(0));
        require(activePlayer == msg.sender);
        board[_x][_y] = msg.sender;

       changePlayer();
    }

    function changePlayer() private {
        if(activePlayer == player1){
            activePlayer = player2;
        }else{
            activePlayer = player1;
        }
    }
   
    
}