pragma solidity >=0.4.22 <0.7.0;

contract Array {
   uint[5] myArray;
   uint[3][3] myArray2;
   uint[2][] myArray3;

   constructor() public {
       myArray[0] = 5;
       myArray3.push([1,1]);
       myArray3.push([2,2]);
   }

   function getMyArray() public view returns (uint[5] memory){
       return myArray;
   }
   
   function getMyArray2() public view returns (uint[3][3] memory){
       return myArray2;
   }
   
   function getMyArray2Sub() public view returns (uint[3] memory){
       return myArray2[0];
   }
   
   function getMyArray3() public view returns (uint[2][] memory){
       return myArray3;
   }
}