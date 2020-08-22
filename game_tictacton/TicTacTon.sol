pragma solidity >=0.4.22 <0.7.0;

contract TicTacTon {
   
    uint constant public gameCost = 0.1 ether;

    uint8 public boardSize = 3;
    bool gameActive;

    address[3][3] board;

    address payable public player1;
    address payable public player2;
    address payable activePlayer;

    uint8 public putStoneCounter = 0;

    event PlayerJoined(address player);
    event NextPlayer(address player);
    event GameOverWithWin(address player);
    event GameOverWithDraw();
    event PayoutSuccess(address player, uint balance);

    uint withdrawBalanceWithPlayer1;
    uint withdrawBalanceWithPlayer2;

    uint timeToReact = 3 minutes;
    uint gameVaildUntil;

    constructor () public payable{
        player1 = msg.sender;
        //msg.value是玩家轉進的錢
        require(msg.value == gameCost);
        gameVaildUntil = now + timeToReact;
    }
    
    function joinGame() public payable{
        //確認玩家2未被使用
        assert(player2 == address(0));
        gameActive = true;
        require(msg.value == gameCost);
        player2 = msg.sender;
        activePlayer = player2;
        emit PlayerJoined(activePlayer);
    }

    function getBoard() view public returns(address[3][3] memory){
        return board;
    }

    //玩家下子
    function setStone(uint8 _x, uint8 _y) public {
        require(board[_x][_y] == address(0));
        //避免玩家過久無回應
        require(gameVaildUntil > now);
        require(activePlayer == msg.sender);
        assert(gameActive);
        assert(_x < 3);
        assert(_y < 3);
        board[_x][_y] = msg.sender;

        //下子數加1
        putStoneCounter++;
        gameVaildUntil = now + timeToReact;

        if(checkResult(_x, _y)){
            return;
        }
        changePlayer();
    }

    function setWinner(address payable winner) private {
        gameActive = false;
        emit GameOverWithWin(winner);
        //send函數會返回送錢的結果(最多使用21000gas)
        //成功為TRUE
        //失敗為FALSE
        //而transfer函數(可用所有的gas)不會返回結果，假如傳送失敗，它會回滾到這一次改變狀態的初始狀態(相當於是最後一子尚未下的狀態。)。
        //並丟出異常
        if(!winner.send(address(this).balance)){
            //建立一個機制讓玩家可以取回交易失敗的錢。
            if(winner == player1){
                withdrawBalanceWithPlayer1 = address(this).balance;
            }else{
                withdrawBalanceWithPlayer2 = address(this).balance;
            }
        }else{
            emit PayoutSuccess(winner, address(this).balance);
        }
    }

    //讓玩家可以有機會取回發送失敗的錢
    function wihdrawIn() public {
        if(msg.sender == player1){
            require(withdrawBalanceWithPlayer1 > 0);
            withdrawBalanceWithPlayer1 = 0;
            player1.transfer(withdrawBalanceWithPlayer1);
            emit PayoutSuccess(player1, withdrawBalanceWithPlayer1);
        }else{
            require(withdrawBalanceWithPlayer2 > 0);
            withdrawBalanceWithPlayer2 = 0;
            player2.transfer(withdrawBalanceWithPlayer2);
            emit PayoutSuccess(player2, withdrawBalanceWithPlayer2);
        }
    }

    //玩家超時時，可以緊急將遊戲結束，雙房和局。
    function emergecyCashOut() public {
        require(gameVaildUntil < now);
        require(gameActive);
        setDraw();
    }

    function setDraw() private{
        gameActive = false;
        emit GameOverWithDraw();

        uint payoutBalance = address(this).balance/2;

        if(!player1.send(payoutBalance)){
            withdrawBalanceWithPlayer1 = payoutBalance;
        }else{
            emit PayoutSuccess(player1, payoutBalance);
        }

        if(!player2.send(payoutBalance)){
            withdrawBalanceWithPlayer2 = payoutBalance;
        }else{
            emit PayoutSuccess(player2, payoutBalance);
        }
    }

    function changePlayer() private {
        if(activePlayer == player1){
            activePlayer = player2;
        }else{
            activePlayer = player1;
        }

         gameVaildUntil = now + timeToReact;
        emit NextPlayer(activePlayer);
    }


    //檢查結果
    //有結果回傳 True，沒結果回傳 false
    function checkResult(uint8 _x, uint8 _y) private returns (bool){
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