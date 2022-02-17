// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract SpaceDoge is ERC721A, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _tokenIdCounter;
    string _baseUri;
    string _contractUri;
    
    uint public constant MAX_SUPPLY = 7979;
    uint public price = 0.1 ether;
    bool public isSalesActive = true;
    
    constructor() ERC721A("Space Doge", "SPACE") {
        _contractUri = "ipfs://QmYk3mM9skJmqSyMUmdbWz1ZkXJeRam3hzAecux1Fwnj5k/space_doge_contract_uri.json";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : '';
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseUri;
    }
    
    function mint(uint quantity) external payable {
        require(isSalesActive, "Sale is currently not active.");
        require(totalSupply() + quantity <= MAX_SUPPLY, "Quantity not available");
        require(quantity <= 10);
        require(msg.value >= price * quantity, "Ether sent is not sufficient."); 
        _safeMint(msg.sender, quantity);
    }
    
    function contractURI() public view returns (string memory) {
        return _contractUri;
    }
    
    function setBaseURI(string memory newBaseURI) external onlyOwner {
        _baseUri = newBaseURI;
    }
    
    function setContractURI(string memory newContractURI) external onlyOwner {
        _contractUri = newContractURI;
    }
    
    function toggleSales() external onlyOwner {
        isSalesActive = !isSalesActive;
    }
    
    function setPrice(uint newPrice) external onlyOwner {
        price = newPrice;
    }
    
    function withdrawAll() external onlyOwner {
        require(payable(msg.sender).send(address(this).balance));
    }
}
