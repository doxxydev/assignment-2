// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/utils/Counters.sol';

contract MyNFT is ERC721, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    uint256 public constant MAX_MINT = 20;
    uint256 public constant PRICE = 0.05 ether;
    bool public revealed = false;
    string public baseURI;

    Counters.Counter private _tokenIds;

    constructor(string memory _name, string memory _symbol, string memory _baseURI) ERC721(_name, _symbol) {
        setBaseURI(_baseURI);
    }

    function totalSupply() public view returns (uint) {
        return _tokenIds.current();
    }

    function mint(uint256 _amount) public payable {

        uint256 current = _tokenIds.current();
        
        require(!revealed, "Reveal has already happened");
        require(_amount > 0 && _amount <= MAX_MINT, "Mint count is invalid");
        require(current + _amount <= MAX_MINT, "Total supply exceeded");
        require(PRICE * _amount <= msg.value, "Ether value sent is not correct");

        

        _safeMint(msg.sender, _amount);
        for(uint i = 0; i < _amount; i++)
        {
        _tokenIds.increment();
        }
    }


    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Balance is zero");
        payable(msg.sender).transfer(balance);
    }

    function reveal() public onlyOwner {
        require(!revealed, "Reveal has already happened");
        revealed = true;
    }

    function setBaseURI(string memory _baseURI) public onlyOwner {
        baseURI = _baseURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");

        if(revealed == false) {
            return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, "unrevealed")) : "";
        }

        string memory base = baseURI;
        return bytes(base).length > 0 ? string(abi.encodePacked(base, tokenId.toString())) : "";
    }
}