// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol";

contract TheResponsesCollection is ERC721A, Ownable {
    uint256 public constant mintPrice = 0.003 ether;
    uint256 public constant maxMintPerUser = 10;
    uint256 public constant maxMintSupply = 10000;

    constructor(address initialOwner)
        ERC721A("TheResponsesCollection", "RSPS")
        Ownable(initialOwner)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://bafybeiaixbx5qgbd337ex2x4psgoj2eqtfftcyi4siyufpuhwpssy2z4ky/";
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : '';
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function safeMint(uint256 quantity) public payable  {
        require(msg.value >= quantity * mintPrice, "Not Enough Funds. You Need More ETH!");
        require(_numberMinted(msg.sender) + quantity <= maxMintPerUser, "Maximum Mint Limit is 10.");
        require(_totalMinted() + quantity <= maxMintSupply, "SOLD OUT");
        _safeMint(msg.sender, quantity);
    }

    function withdraw(address _addr) external onlyOwner{
        uint256 balance = address(this).balance;
        // Address.sendValue(payable(msg.sender), balance);
        payable(_addr).transfer(balance);
    }
}