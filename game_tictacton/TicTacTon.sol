pragma solidity >=0.4.22 <0.7.0;

contract Event {
   
    uint8 public boardSize = 3;
    bool gameActive;

    address[3][3] board;

    address public player1;
    address public player2;
    address activePlayer;

    uint8 public putStoneCounter = 0;

    constructor () public{
        player1 = msg.sender;
    }
    
    function joinGame() public{
        //確認玩家2未被使用
        assert(player2 == address(0));
        gameActive = true;
        player2 = msg.sender;
        activePlayer = player2;
    }

    function getBoard() view public returns(address[3][3] memory){
        return board;
    }

    function setStone(uint8 _x, uint8 _y) public {
        require(board[_x][_y] == address(0));
        require(activePlayer == msg.sender);
        assert(gameActive);
        assert(_x < 3);
        assert(_y < 3);
        board[_x][_y] = msg.sender;

        //下子數加1
        putStoneTimes++;

        if(checkResult(_x, _y)){
            return;
        }
        changePlayer();
    }

    function setWinner(address winner) private {
        gameActive = false;
        // TODO 玩家勝利事件
        // TODO 送錢給贏家
    }

    function setDraw() private{
         gameActive = false;
        // TODO 玩家和局事件
    }

    function changePlayer() private {
        if(activePlayer == player1){
            activePlayer = player2;
        }else{
            activePlayer = player1;
        }
    }


    //檢查結果
    //有結果回傳 True，沒結果回傳 false
    function checkResult(uint8 _x, uint8 _y) private view returns (bool){
        //檢查列
        for(uint8 i = 0; i < boardSize; i++){
            if(board[i][_y] != activePlayer){
                break;
            }

            if(i == boardSize - 1){
                setWinner(activePlayer);
                return true;
            }
        }

        //檢查行
        for(uint8 i = 0; i < boardSize; i++){
            if(board[_x][i] != activePlayer){
                break;
            }

            if(i == boardSize - 1){
                setWinner(activePlayer);
                return true;
            }
        }

        //檢查對角線
        if(_x == _y){
            for(uint8 i = 0; i< boardSize; i++ ){
                if(board[i][i] != activePlayer){
                    break;
                }

                if(i == boardSize - 1){
                    setWinner(activePlayer);
                    return true;
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
                    setWinner(activePlayer);
                    return true;
                }
            }
        }

        //和局
        if(putStoneCounter == (boardSize ** 2)){
           setDraw();
           return true;
        }

        return false;
    }
   
    
}