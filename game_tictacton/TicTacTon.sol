pragma solidity >=0.4.22 <0.7.0;

contract Event {
   
    uint8 public boardSize = 3;

    address[3][3] board;

    address public player1;
    address public player2;
    address activePlayer;

    uint8 public putStoneTimes = 0;

    constructor () public{
        player1 = msg.sender;
    }
    
    function joinGame() public{
        //確認玩家2未被使用
        assert(player2 == address(0));
        player2 = msg.sender;
        activePlayer = player2;
    }

    function getBoard() view public returns(address[3][3] memory){
        return board;
    }

    function setStone(uint8 _x, uint8 _y) public {
        require(_x < 3);
        require(_y < 3);
        require(board[_x][_y] == address(0));
        require(activePlayer == msg.sender);
        board[_x][_y] = msg.sender;

        //下子數加1
        putStoneTimes++;

        checkResult(_x, _y);//TODO 需要依結果做處理
       
        changePlayer();
    }

    function changePlayer() private {
        if(activePlayer == player1){
            activePlayer = player2;
        }else{
            activePlayer = player1;
        }
    }


    //檢查結果
    function checkResult(uint8 _x, uint8 _y) private view{
        //檢查列
        for(uint8 i = 0; i < boardSize; i++){
            if(board[i][_y] != activePlayer){
                break;
            }

            if(i == boardSize - 1){
                // TODO 贏了
            }
        }

        //檢查行
        for(uint8 i = 0; i < boardSize; i++){
            if(board[_x][i] != activePlayer){
                break;
            }

            if(i == boardSize - 1){
                // TODO 贏了
            }
        }

        //檢查對角線
        if(_x == _y){
            for(uint8 i = 0; i< boardSize; i++ ){
                if(board[i][i] != activePlayer){
                    break;
                }

                if(i == boardSize - 1){
                // TODO 贏了
                }
            }
        }

        //斜對角線
        if((_x+_y) == boardSize - 1){
            for(uint8 i = 0; i< boardSize; i++ ){
                if(board[i][(boardSize -1) - i] != activePlayer){
                    break;
                }

                if(i == boardSize - 1){
                // TODO 贏了
                }
            }
        }

        //和局
        if(putStoneTimes == boardSize * boardSize){
            // TODO 和局
        }
    }
   
    
}