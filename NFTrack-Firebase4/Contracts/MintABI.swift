//
//  MintABI.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-10-09.
//

import Foundation
import web3swift

let mintContractAddress = EthereumAddress("0x18151C4517525C0A2AfFAbf645911cDA46FFE34E")

let mintABI = """
[
    {
        "anonymous": false,
        "inputs": [
        {
        "indexed": true,
        "internalType": "address",
        "name": "owner",
        "type": "address"
        },
        {
        "indexed": true,
        "internalType": "address",
        "name": "approved",
        "type": "address"
        },
        {
        "indexed": true,
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
        }
        ],
        "name": "Approval",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
        {
        "indexed": true,
        "internalType": "address",
        "name": "owner",
        "type": "address"
        },
        {
        "indexed": true,
        "internalType": "address",
        "name": "operator",
        "type": "address"
        },
        {
        "indexed": false,
        "internalType": "bool",
        "name": "approved",
        "type": "bool"
        }
        ],
        "name": "ApprovalForAll",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
        {
        "indexed": true,
        "internalType": "address",
        "name": "from",
        "type": "address"
        },
        {
        "indexed": true,
        "internalType": "address",
        "name": "to",
        "type": "address"
        },
        {
        "indexed": true,
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
        }
        ],
        "name": "Transfer",
        "type": "event"
    },
    {
        "inputs": [
        {
        "internalType": "address",
        "name": "to",
        "type": "address"
        },
        {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
        }
        ],
        "name": "approve",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
        {
        "internalType": "address",
        "name": "receiver",
        "type": "address"
        }
        ],
        "name": "mintNft",
        "outputs": [
        {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
        }
        ],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
        {
        "internalType": "address",
        "name": "from",
        "type": "address"
        },
        {
        "internalType": "address",
        "name": "to",
        "type": "address"
        },
        {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
        }
        ],
        "name": "safeTransferFrom",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
        {
        "internalType": "address",
        "name": "from",
        "type": "address"
        },
        {
        "internalType": "address",
        "name": "to",
        "type": "address"
        },
        {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
        },
        {
        "internalType": "bytes",
        "name": "_data",
        "type": "bytes"
        }
        ],
        "name": "safeTransferFrom",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
        {
        "internalType": "address",
        "name": "operator",
        "type": "address"
        },
        {
        "internalType": "bool",
        "name": "approved",
        "type": "bool"
        }
        ],
        "name": "setApprovalForAll",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
        {
        "internalType": "address",
        "name": "from",
        "type": "address"
        },
        {
        "internalType": "address",
        "name": "to",
        "type": "address"
        },
        {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
        }
        ],
        "name": "transferFrom",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [],
        "stateMutability": "nonpayable",
        "type": "constructor"
    },
    {
        "inputs": [
        {
        "internalType": "address",
        "name": "owner",
        "type": "address"
        }
        ],
        "name": "balanceOf",
        "outputs": [
        {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
        }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
        {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
        }
        ],
        "name": "getApproved",
        "outputs": [
        {
        "internalType": "address",
        "name": "",
        "type": "address"
        }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
        {
        "internalType": "address",
        "name": "owner",
        "type": "address"
        },
        {
        "internalType": "address",
        "name": "operator",
        "type": "address"
        }
        ],
        "name": "isApprovedForAll",
        "outputs": [
        {
        "internalType": "bool",
        "name": "",
        "type": "bool"
        }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "name",
        "outputs": [
        {
        "internalType": "string",
        "name": "",
        "type": "string"
        }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
        {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
        }
        ],
        "name": "ownerOf",
        "outputs": [
        {
        "internalType": "address",
        "name": "",
        "type": "address"
        }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
        {
        "internalType": "bytes4",
        "name": "interfaceId",
        "type": "bytes4"
        }
        ],
        "name": "supportsInterface",
        "outputs": [
        {
        "internalType": "bool",
        "name": "",
        "type": "bool"
        }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "symbol",
        "outputs": [
        {
        "internalType": "string",
        "name": "",
        "type": "string"
        }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
        {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
        }
        ],
        "name": "tokenURI",
        "outputs": [
        {
        "internalType": "string",
        "name": "",
        "type": "string"
        }
        ],
        "stateMutability": "view",
        "type": "function"
    }
]
"""
let mintBytecode = """
60806040523480156200001157600080fd5b506040518060400160405280600781526020017f4e46547261636b000000000000000000000000000000000000000000000000008152506040518060400160405280600381526020017f54524b0000000000000000000000000000000000000000000000000000000000815250816000908051906020019062000096929190620000b8565b508060019080519060200190620000af929190620000b8565b505050620001cd565b828054620000c69062000168565b90600052602060002090601f016020900481019282620000ea576000855562000136565b82601f106200010557805160ff191683800117855562000136565b8280016001018555821562000136579182015b828111156200013557825182559160200191906001019062000118565b5b50905062000145919062000149565b5090565b5b80821115620001645760008160009055506001016200014a565b5090565b600060028204905060018216806200018157607f821691505b602082108114156200019857620001976200019e565b5b50919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b61269280620001dd6000396000f3fe608060405234801561001057600080fd5b50600436106100ea5760003560e01c806370a082311161008c578063b88d4fde11610066578063b88d4fde1461025b578063c87b56dd14610277578063e985e9c5146102a7578063e9c2e14b146102d7576100ea565b806370a08231146101f157806395d89b4114610221578063a22cb4651461023f576100ea565b8063095ea7b3116100c8578063095ea7b31461016d57806323b872dd1461018957806342842e0e146101a55780636352211e146101c1576100ea565b806301ffc9a7146100ef57806306fdde031461011f578063081812fc1461013d575b600080fd5b61010960048036038101906101049190611962565b610307565b604051610116919061205a565b60405180910390f35b6101276103e9565b6040516101349190612075565b60405180910390f35b610157600480360381019061015291906119b4565b61047b565b6040516101649190611ff3565b60405180910390f35b61018760048036038101906101829190611926565b610500565b005b6101a3600480360381019061019e9190611820565b610618565b005b6101bf60048036038101906101ba9190611820565b610678565b005b6101db60048036038101906101d691906119b4565b610698565b6040516101e89190611ff3565b60405180910390f35b61020b600480360381019061020691906117bb565b61074a565b6040516102189190612257565b60405180910390f35b610229610802565b6040516102369190612075565b60405180910390f35b610259600480360381019061025491906118ea565b610894565b005b6102756004803603810190610270919061186f565b610a15565b005b610291600480360381019061028c91906119b4565b610a77565b60405161029e9190612075565b60405180910390f35b6102c160048036038101906102bc91906117e4565b610b1e565b6040516102ce919061205a565b60405180910390f35b6102f160048036038101906102ec91906117bb565b610bb2565b6040516102fe9190612257565b60405180910390f35b60007f80ac58cd000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff191614806103d257507f5b5e139f000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916145b806103e257506103e182610bdf565b5b9050919050565b6060600080546103f890612487565b80601f016020809104026020016040519081016040528092919081815260200182805461042490612487565b80156104715780601f1061044657610100808354040283529160200191610471565b820191906000526020600020905b81548152906001019060200180831161045457829003601f168201915b5050505050905090565b600061048682610c49565b6104c5576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016104bc906121b7565b60405180910390fd5b6004600083815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050919050565b600061050b82610698565b90508073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff16141561057c576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161057390612217565b60405180910390fd5b8073ffffffffffffffffffffffffffffffffffffffff1661059b610cb5565b73ffffffffffffffffffffffffffffffffffffffff1614806105ca57506105c9816105c4610cb5565b610b1e565b5b610609576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161060090612137565b60405180910390fd5b6106138383610cbd565b505050565b610629610623610cb5565b82610d76565b610668576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161065f90612237565b60405180910390fd5b610673838383610e54565b505050565b61069383838360405180602001604052806000815250610a15565b505050565b6000806002600084815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff161415610741576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161073890612177565b60405180910390fd5b80915050919050565b60008073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1614156107bb576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016107b290612157565b60405180910390fd5b600360008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050919050565b60606001805461081190612487565b80601f016020809104026020016040519081016040528092919081815260200182805461083d90612487565b801561088a5780601f1061085f5761010080835404028352916020019161088a565b820191906000526020600020905b81548152906001019060200180831161086d57829003601f168201915b5050505050905090565b61089c610cb5565b73ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16141561090a576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610901906120f7565b60405180910390fd5b8060056000610917610cb5565b73ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548160ff0219169083151502179055508173ffffffffffffffffffffffffffffffffffffffff166109c4610cb5565b73ffffffffffffffffffffffffffffffffffffffff167f17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c3183604051610a09919061205a565b60405180910390a35050565b610a26610a20610cb5565b83610d76565b610a65576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610a5c90612237565b60405180910390fd5b610a71848484846110b0565b50505050565b6060610a8282610c49565b610ac1576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610ab8906121f7565b60405180910390fd5b6000610acb61110c565b90506000815111610aeb5760405180602001604052806000815250610b16565b80610af584611123565b604051602001610b06929190611fcf565b6040516020818303038152906040525b915050919050565b6000600560008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16905092915050565b6000610bbe60066112d0565b6000610bca60066112e6565b9050610bd683826112f4565b80915050919050565b60007f01ffc9a7000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916149050919050565b60008073ffffffffffffffffffffffffffffffffffffffff166002600084815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614159050919050565b600033905090565b816004600083815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550808273ffffffffffffffffffffffffffffffffffffffff16610d3083610698565b73ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b92560405160405180910390a45050565b6000610d8182610c49565b610dc0576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610db790612117565b60405180910390fd5b6000610dcb83610698565b90508073ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff161480610e3a57508373ffffffffffffffffffffffffffffffffffffffff16610e228461047b565b73ffffffffffffffffffffffffffffffffffffffff16145b80610e4b5750610e4a8185610b1e565b5b91505092915050565b8273ffffffffffffffffffffffffffffffffffffffff16610e7482610698565b73ffffffffffffffffffffffffffffffffffffffff1614610eca576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610ec1906121d7565b60405180910390fd5b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff161415610f3a576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610f31906120d7565b60405180910390fd5b610f45838383611312565b610f50600082610cbd565b6001600360008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254610fa0919061239d565b925050819055506001600360008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254610ff79190612316565b92505081905550816002600083815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550808273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef60405160405180910390a4505050565b6110bb848484610e54565b6110c784848484611317565b611106576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016110fd90612097565b60405180910390fd5b50505050565b606060405180602001604052806000815250905090565b6060600082141561116b576040518060400160405280600181526020017f300000000000000000000000000000000000000000000000000000000000000081525090506112cb565b600082905060005b6000821461119d578080611186906124b9565b915050600a82611196919061236c565b9150611173565b60008167ffffffffffffffff8111156111df577f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b6040519080825280601f01601f1916602001820160405280156112115781602001600182028036833780820191505090505b5090505b600085146112c45760018261122a919061239d565b9150600a856112399190612502565b60306112459190612316565b60f81b818381518110611281577f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a905350600a856112bd919061236c565b9450611215565b8093505050505b919050565b6001816000016000828254019250508190555050565b600081600001549050919050565b61130e8282604051806020016040528060008152506114ae565b5050565b505050565b60006113388473ffffffffffffffffffffffffffffffffffffffff16611509565b156114a1578373ffffffffffffffffffffffffffffffffffffffff1663150b7a02611361610cb5565b8786866040518563ffffffff1660e01b8152600401611383949392919061200e565b602060405180830381600087803b15801561139d57600080fd5b505af19250505080156113ce57506040513d601f19601f820116820180604052508101906113cb919061198b565b60015b611451573d80600081146113fe576040519150601f19603f3d011682016040523d82523d6000602084013e611403565b606091505b50600081511415611449576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161144090612097565b60405180910390fd5b805181602001fd5b63150b7a0260e01b7bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916817bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916149150506114a6565b600190505b949350505050565b6114b8838361151c565b6114c56000848484611317565b611504576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016114fb90612097565b60405180910390fd5b505050565b600080823b905060008111915050919050565b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16141561158c576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161158390612197565b60405180910390fd5b61159581610c49565b156115d5576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016115cc906120b7565b60405180910390fd5b6115e160008383611312565b6001600360008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546116319190612316565b92505081905550816002600083815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550808273ffffffffffffffffffffffffffffffffffffffff16600073ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef60405160405180910390a45050565b60006116fd6116f8846122a3565b612272565b90508281526020810184848401111561171557600080fd5b611720848285612445565b509392505050565b60008135905061173781612600565b92915050565b60008135905061174c81612617565b92915050565b6000813590506117618161262e565b92915050565b6000815190506117768161262e565b92915050565b600082601f83011261178d57600080fd5b813561179d8482602086016116ea565b91505092915050565b6000813590506117b581612645565b92915050565b6000602082840312156117cd57600080fd5b60006117db84828501611728565b91505092915050565b600080604083850312156117f757600080fd5b600061180585828601611728565b925050602061181685828601611728565b9150509250929050565b60008060006060848603121561183557600080fd5b600061184386828701611728565b935050602061185486828701611728565b9250506040611865868287016117a6565b9150509250925092565b6000806000806080858703121561188557600080fd5b600061189387828801611728565b94505060206118a487828801611728565b93505060406118b5878288016117a6565b925050606085013567ffffffffffffffff8111156118d257600080fd5b6118de8782880161177c565b91505092959194509250565b600080604083850312156118fd57600080fd5b600061190b85828601611728565b925050602061191c8582860161173d565b9150509250929050565b6000806040838503121561193957600080fd5b600061194785828601611728565b9250506020611958858286016117a6565b9150509250929050565b60006020828403121561197457600080fd5b600061198284828501611752565b91505092915050565b60006020828403121561199d57600080fd5b60006119ab84828501611767565b91505092915050565b6000602082840312156119c657600080fd5b60006119d4848285016117a6565b91505092915050565b6119e6816123d1565b82525050565b6119f5816123e3565b82525050565b6000611a06826122d3565b611a1081856122e9565b9350611a20818560208601612454565b611a29816125ef565b840191505092915050565b6000611a3f826122de565b611a4981856122fa565b9350611a59818560208601612454565b611a62816125ef565b840191505092915050565b6000611a78826122de565b611a82818561230b565b9350611a92818560208601612454565b80840191505092915050565b6000611aab6032836122fa565b91507f4552433732313a207472616e7366657220746f206e6f6e20455243373231526560008301527f63656976657220696d706c656d656e74657200000000000000000000000000006020830152604082019050919050565b6000611b11601c836122fa565b91507f4552433732313a20746f6b656e20616c7265616479206d696e746564000000006000830152602082019050919050565b6000611b516024836122fa565b91507f4552433732313a207472616e7366657220746f20746865207a65726f2061646460008301527f72657373000000000000000000000000000000000000000000000000000000006020830152604082019050919050565b6000611bb76019836122fa565b91507f4552433732313a20617070726f766520746f2063616c6c6572000000000000006000830152602082019050919050565b6000611bf7602c836122fa565b91507f4552433732313a206f70657261746f7220717565727920666f72206e6f6e657860008301527f697374656e7420746f6b656e00000000000000000000000000000000000000006020830152604082019050919050565b6000611c5d6038836122fa565b91507f4552433732313a20617070726f76652063616c6c6572206973206e6f74206f7760008301527f6e6572206e6f7220617070726f76656420666f7220616c6c00000000000000006020830152604082019050919050565b6000611cc3602a836122fa565b91507f4552433732313a2062616c616e636520717565727920666f7220746865207a6560008301527f726f2061646472657373000000000000000000000000000000000000000000006020830152604082019050919050565b6000611d296029836122fa565b91507f4552433732313a206f776e657220717565727920666f72206e6f6e657869737460008301527f656e7420746f6b656e00000000000000000000000000000000000000000000006020830152604082019050919050565b6000611d8f6020836122fa565b91507f4552433732313a206d696e7420746f20746865207a65726f20616464726573736000830152602082019050919050565b6000611dcf602c836122fa565b91507f4552433732313a20617070726f76656420717565727920666f72206e6f6e657860008301527f697374656e7420746f6b656e00000000000000000000000000000000000000006020830152604082019050919050565b6000611e356029836122fa565b91507f4552433732313a207472616e73666572206f6620746f6b656e2074686174206960008301527f73206e6f74206f776e00000000000000000000000000000000000000000000006020830152604082019050919050565b6000611e9b602f836122fa565b91507f4552433732314d657461646174613a2055524920717565727920666f72206e6f60008301527f6e6578697374656e7420746f6b656e00000000000000000000000000000000006020830152604082019050919050565b6000611f016021836122fa565b91507f4552433732313a20617070726f76616c20746f2063757272656e74206f776e6560008301527f72000000000000000000000000000000000000000000000000000000000000006020830152604082019050919050565b6000611f676031836122fa565b91507f4552433732313a207472616e736665722063616c6c6572206973206e6f74206f60008301527f776e6572206e6f7220617070726f7665640000000000000000000000000000006020830152604082019050919050565b611fc98161243b565b82525050565b6000611fdb8285611a6d565b9150611fe78284611a6d565b91508190509392505050565b600060208201905061200860008301846119dd565b92915050565b600060808201905061202360008301876119dd565b61203060208301866119dd565b61203d6040830185611fc0565b818103606083015261204f81846119fb565b905095945050505050565b600060208201905061206f60008301846119ec565b92915050565b6000602082019050818103600083015261208f8184611a34565b905092915050565b600060208201905081810360008301526120b081611a9e565b9050919050565b600060208201905081810360008301526120d081611b04565b9050919050565b600060208201905081810360008301526120f081611b44565b9050919050565b6000602082019050818103600083015261211081611baa565b9050919050565b6000602082019050818103600083015261213081611bea565b9050919050565b6000602082019050818103600083015261215081611c50565b9050919050565b6000602082019050818103600083015261217081611cb6565b9050919050565b6000602082019050818103600083015261219081611d1c565b9050919050565b600060208201905081810360008301526121b081611d82565b9050919050565b600060208201905081810360008301526121d081611dc2565b9050919050565b600060208201905081810360008301526121f081611e28565b9050919050565b6000602082019050818103600083015261221081611e8e565b9050919050565b6000602082019050818103600083015261223081611ef4565b9050919050565b6000602082019050818103600083015261225081611f5a565b9050919050565b600060208201905061226c6000830184611fc0565b92915050565b6000604051905081810181811067ffffffffffffffff82111715612299576122986125c0565b5b8060405250919050565b600067ffffffffffffffff8211156122be576122bd6125c0565b5b601f19601f8301169050602081019050919050565b600081519050919050565b600081519050919050565b600082825260208201905092915050565b600082825260208201905092915050565b600081905092915050565b60006123218261243b565b915061232c8361243b565b9250827fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0382111561236157612360612533565b5b828201905092915050565b60006123778261243b565b91506123828361243b565b92508261239257612391612562565b5b828204905092915050565b60006123a88261243b565b91506123b38361243b565b9250828210156123c6576123c5612533565b5b828203905092915050565b60006123dc8261241b565b9050919050565b60008115159050919050565b60007fffffffff0000000000000000000000000000000000000000000000000000000082169050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6000819050919050565b82818337600083830152505050565b60005b83811015612472578082015181840152602081019050612457565b83811115612481576000848401525b50505050565b6000600282049050600182168061249f57607f821691505b602082108114156124b3576124b2612591565b5b50919050565b60006124c48261243b565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8214156124f7576124f6612533565b5b600182019050919050565b600061250d8261243b565b91506125188361243b565b92508261252857612527612562565b5b828206905092915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b6000601f19601f8301169050919050565b612609816123d1565b811461261457600080fd5b50565b612620816123e3565b811461262b57600080fd5b50565b612637816123ef565b811461264257600080fd5b50565b61264e8161243b565b811461265957600080fd5b5056fea26469706673582212201c86b30c777e8412794b531976c2cd4f4e44f70cdd46b7d4efaa794981483a6964736f6c63430008000033
"""