// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract KarthikToken is Ownable, ERC721("Karthik Gupta Token", "KGT") {
    uint tokenId;
    uint counter;
    
    struct TokenMetadata {
        uint timestamp;
        uint tokenId;
        string tokenUri;
    }
    
    mapping(address => TokenMetadata[]) tokenOwnership;
    TokenMetadata[] tokenMetadataArray;
    
    function getTokenOwnership(address _user) public view returns (TokenMetadata[] memory) {
        return tokenOwnership[_user];
    }
    
    function incrToken() internal returns (uint) {
        return tokenId++;
    }
    
    function incrCounter() internal returns (uint) {
        return ++counter;
    }
    
    function _baseURI() internal view virtual override returns (string memory) {
        return "KarthikToken/base/";
    }
    
    function mintToken(uint _tokenId) public {
        _safeMint(msg.sender, _tokenId);
        
        TokenMetadata memory data = TokenMetadata(block.timestamp, _tokenId, string(abi.encodePacked("random uri ", Strings.toString(incrCounter()))));
        
        tokenMetadataArray.push(data);
        tokenOwnership[msg.sender].push(data);
        
        incrToken();
    }
    
    function burnToken(uint _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender, "You are not permitted with this operation!");
        _burn(_tokenId);
        _removeBurnedTokenMetadata(_tokenId);
        _removeBurnedTokenFromOwnership(_tokenId, msg.sender);
    }
    
    function _removeBurnedTokenMetadata(uint _tokenId) internal returns (bool) {
        for(uint i=0; i<tokenMetadataArray.length; i++) {
            if (tokenMetadataArray[i].tokenId == _tokenId) {
                delete tokenMetadataArray[i];
                return true;
            }
        }
        return false;
    }
    
    function _removeBurnedTokenFromOwnership(uint _tokenId, address _tokenOwner) internal returns (bool) {
        for(uint i=0; i<tokenOwnership[_tokenOwner].length; i++) {
            if (tokenOwnership[_tokenOwner][i].tokenId == _tokenId) {
                delete tokenOwnership[_tokenOwner][i];
                return true;
            }
        }
        return false;
    }
}
