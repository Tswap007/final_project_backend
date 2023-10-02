// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract WonderlandWanderers is ERC721, ERC721URIStorage, Ownable {
    struct TokenInfo {
        string metaDataUri;
        string imageUri;
    }

    mapping(uint256 => TokenInfo) private _tokenIdToTokenInfo;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Wonderland Wanderers", "WW") {}

    function safeMint(
        address to,
        string memory metaDataUri,
        string memory imageUri
    ) public {
        require(bytes(metaDataUri).length > 0, "Metadata URI cannot be empty");
        require(bytes(imageUri).length > 0, "Image URI cannot be empty");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

        _tokenIdToTokenInfo[tokenId] = TokenInfo({
            metaDataUri: metaDataUri,
            imageUri: imageUri
        });
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return _tokenIdToTokenInfo[tokenId].metaDataUri;
    }

    function getImageUri(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return _tokenIdToTokenInfo[tokenId].imageUri;
    }

    function getTotalItemCount() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    function itemExists(string memory proposedURI) public view returns (bool) {
        for (uint256 i = 0; i < _tokenIdCounter.current(); i++) {
            if (
                keccak256(bytes(_tokenIdToTokenInfo[i].imageUri)) ==
                keccak256(bytes(proposedURI))
            ) {
                return true;
            }
        }
        return false;
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
        delete _tokenIdToTokenInfo[tokenId];
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
