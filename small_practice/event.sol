pragma solidity >=0.4.22 <0.7.0;

contract Event {
    uint8 myInt;
    
    //事件的定義
    event MyEvent();

    event MyEvent2(uint8 myInt);
    
    function setMyInt(uint8 _myInt) public{
       //事件的觸發，這邊要特別注意，事件的監聽是只能在solidity外部的。
       emit MyEvent();
       emit MyEvent2(_myInt);
    }
    
}