// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VolcanoToken is Ownable, ERC721("VolcanoToken", "VTK") {
    uint tokenId;
    
    struct TokenMetadata {
        uint timestamp;
        uint tokenId;
        string tokenUri;
    }
    
    mapping(address => TokenMetadata[]) tokenOwnership;
    
    function getTokenOwnership(address _user) public view returns (TokenMetadata[] memory) {
        return tokenOwnership[_user];
    }
    
    function incrToken() internal returns (uint) {
        return tokenId++;
    }
    
    function _baseURI() internal view virtual override returns (string memory) {
        return "VolcanoToken/base";
    }
    
    function mintToken() public returns (uint) {
        uint _tokenId = incrToken();
        _safeMint(msg.sender, _tokenId);
        
        TokenMetadata memory data = TokenMetadata(block.timestamp, tokenId, "some uri data");
        
        tokenOwnership[msg.sender].push(data);
        
        return _tokenId;
    }
    
    function burnToken(uint _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender, "You are not permitted with this operation!");
        _burn(_tokenId);
        _removeBurnedTokenFromOwnership(_tokenId, msg.sender);
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
