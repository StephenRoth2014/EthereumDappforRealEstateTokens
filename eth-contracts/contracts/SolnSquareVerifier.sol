pragma solidity >=0.4.21 <0.6.0;
pragma experimental ABIEncoderV2;

import "./verifier.sol";
import "./ERC721Mintable.sol";

// TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
contract ZokratesVerifier is Verifier {

}

// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is CustomERC721Token {

// TODO define a solutions struct that can hold an index & an address
struct Solutions {
    uint256 index;
    address toAddress;
}

//define variable then assign in constructor
ZokratesVerifier public ZVerifier;
constructor(address _address) CustomERC721Token() public{
        ZVerifier = ZokratesVerifier(_address);
    }

// TODO define an array of the above struct
Solutions[] ArrayofSolutions;

// TODO define a mapping to store unique solutions submitted
mapping(bytes32 => Solutions) private uniqueSolution;

// TODO Create an event to emit when a solution is added
event SolutionAdded(uint256 index, address toAddress);

// TODO Create a function to add the solutions to the array and emit the event
function AddSolution(uint256 _index, address _toAddress, bytes32 _key) internal {
       
       Solutions memory _solution = Solutions({index : _index, toAddress : _toAddress});
       ArrayofSolutions.push(_solution);
       uniqueSolution[_key] = _solution;

        // TODO emit Approval Event
        emit SolutionAdded(_index, _toAddress);
    }

// TODO Create a function to mint new NFT only after the solution has been verified
//  - make sure the solution is unique (has not been used before)
//  - make sure you handle metadata as well as tokenSuplly

function Mint(address _to, uint256 _tokenId, uint[2] memory _input1, 
                uint[2][2] memory _input2, uint[2] memory _input3, uint[2] memory _input4) public 
{
    bytes32 key = keccak256(abi.encodePacked(_input1, _input2, _input3, _input4));
    require(uniqueSolution[key].toAddress == address(0),"must be unique");
    require(ZVerifier.verifyTx(_input1, _input2, _input3, _input4), "not correct");

    AddSolution(_tokenId, _to, key);
    super.mint(_to, _tokenId);
}

}

  


























