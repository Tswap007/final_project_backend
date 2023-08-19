// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract WonderlandWanderers is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    // Mapping to store custom URIs for each token
    mapping(uint256 => string) private _tokenURIs;
    // Mapping to store and check if metaDataUri exists figured this will be cheaper and faster than looping through each tokenId and comparing their URI.
    mapping(string => bool) private _itemExists;

    constructor() ERC721("Wonderland Wanderers", "WW") {}

    function safeMint(
        address to,
        string memory metaDataUri,
        string memory imageUri
    ) public {
        require(_itemExists[imageUri] == false, "Item Exists Already");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _tokenURIs[tokenId] = metaDataUri; // Store the custom URI for the token
        _itemExists[imageUri] = true; // store the metaDataUri exist bool to use for checks
    }

    // Override tokenURI function to use custom URIs
    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return _tokenURIs[tokenId];
    }

    function getTotalItemCount() public view returns (uint256) {
        uint256 count = _tokenIdCounter.current();
        return count;
    }

    function itemExists(string memory proposedURI) public view returns (bool) {
        return _itemExists[proposedURI];
    }

    // The following functions are overrides required by Solidity.

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
        // Clear the custom URI for the burned token
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
