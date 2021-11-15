//
//  MintContractABI.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-11-03.
//

/*
 Abstract:
 solireyMintContractAddress for the address
 */

let mintContractABI = """
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
        "inputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "name": "_artist",
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
let mintContractBytecode = """
60806040523480156200001157600080fd5b506040518060400160405280600781526020017f536f6c69726579000000000000000000000000000000000000000000000000008152506040518060400160405280600481526020017f5352455900000000000000000000000000000000000000000000000000000000815250816000908051906020019062000096929190620000f9565b508060019080519060200190620000af929190620000f9565b50505033600760006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506200020e565b8280546200010790620001a9565b90600052602060002090601f0160209004810192826200012b576000855562000177565b82601f106200014657805160ff191683800117855562000177565b8280016001018555821562000177579182015b828111156200017657825182559160200191906001019062000159565b5b5090506200018691906200018a565b5090565b5b80821115620001a55760008160009055506001016200018b565b5090565b60006002820490506001821680620001c257607f821691505b60208210811415620001d957620001d8620001df565b5b50919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b612700806200021e6000396000f3fe608060405234801561001057600080fd5b50600436106100f55760003560e01c80636352211e11610097578063b88d4fde11610066578063b88d4fde14610296578063c87b56dd146102b2578063e985e9c5146102e2578063e9c2e14b14610312576100f5565b80636352211e146101fc57806370a082311461022c57806395d89b411461025c578063a22cb4651461027a576100f5565b8063095ea7b3116100d3578063095ea7b31461017857806323b872dd1461019457806342842e0e146101b05780635f8a6414146101cc576100f5565b806301ffc9a7146100fa57806306fdde031461012a578063081812fc14610148575b600080fd5b610114600480360381019061010f91906119d0565b610342565b60405161012191906120c8565b60405180910390f35b610132610424565b60405161013f91906120e3565b60405180910390f35b610162600480360381019061015d9190611a22565b6104b6565b60405161016f9190612061565b60405180910390f35b610192600480360381019061018d9190611994565b61053b565b005b6101ae60048036038101906101a9919061188e565b610653565b005b6101ca60048036038101906101c5919061188e565b6106b3565b005b6101e660048036038101906101e19190611a22565b6106d3565b6040516101f39190612061565b60405180910390f35b61021660048036038101906102119190611a22565b610706565b6040516102239190612061565b60405180910390f35b61024660048036038101906102419190611829565b6107b8565b60405161025391906122c5565b60405180910390f35b610264610870565b60405161027191906120e3565b60405180910390f35b610294600480360381019061028f9190611958565b610902565b005b6102b060048036038101906102ab91906118dd565b610a83565b005b6102cc60048036038101906102c79190611a22565b610ae5565b6040516102d991906120e3565b60405180910390f35b6102fc60048036038101906102f79190611852565b610b8c565b60405161030991906120c8565b60405180910390f35b61032c60048036038101906103279190611829565b610c20565b60405161033991906122c5565b60405180910390f35b60007f80ac58cd000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916148061040d57507f5b5e139f000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916145b8061041d575061041c82610c4d565b5b9050919050565b606060008054610433906124f5565b80601f016020809104026020016040519081016040528092919081815260200182805461045f906124f5565b80156104ac5780601f10610481576101008083540402835291602001916104ac565b820191906000526020600020905b81548152906001019060200180831161048f57829003601f168201915b5050505050905090565b60006104c182610cb7565b610500576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016104f790612225565b60405180910390fd5b6004600083815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050919050565b600061054682610706565b90508073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1614156105b7576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016105ae90612285565b60405180910390fd5b8073ffffffffffffffffffffffffffffffffffffffff166105d6610d23565b73ffffffffffffffffffffffffffffffffffffffff1614806106055750610604816105ff610d23565b610b8c565b5b610644576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161063b906121a5565b60405180910390fd5b61064e8383610d2b565b505050565b61066461065e610d23565b82610de4565b6106a3576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161069a906122a5565b60405180910390fd5b6106ae838383610ec2565b505050565b6106ce83838360405180602001604052806000815250610a83565b505050565b60086020528060005260406000206000915054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000806002600084815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1614156107af576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016107a6906121e5565b60405180910390fd5b80915050919050565b60008073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff161415610829576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610820906121c5565b60405180910390fd5b600360008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050919050565b60606001805461087f906124f5565b80601f01602080910402602001604051908101604052809291908181526020018280546108ab906124f5565b80156108f85780601f106108cd576101008083540402835291602001916108f8565b820191906000526020600020905b8154815290600101906020018083116108db57829003601f168201915b5050505050905090565b61090a610d23565b73ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff161415610978576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161096f90612165565b60405180910390fd5b8060056000610985610d23565b73ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548160ff0219169083151502179055508173ffffffffffffffffffffffffffffffffffffffff16610a32610d23565b73ffffffffffffffffffffffffffffffffffffffff167f17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c3183604051610a7791906120c8565b60405180910390a35050565b610a94610a8e610d23565b83610de4565b610ad3576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610aca906122a5565b60405180910390fd5b610adf8484848461111e565b50505050565b6060610af082610cb7565b610b2f576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610b2690612265565b60405180910390fd5b6000610b3961117a565b90506000815111610b595760405180602001604052806000815250610b84565b80610b6384611191565b604051602001610b7492919061203d565b6040516020818303038152906040525b915050919050565b6000600560008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16905092915050565b6000610c2c600661133e565b6000610c386006611354565b9050610c448382611362565b80915050919050565b60007f01ffc9a7000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916149050919050565b60008073ffffffffffffffffffffffffffffffffffffffff166002600084815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614159050919050565b600033905090565b816004600083815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550808273ffffffffffffffffffffffffffffffffffffffff16610d9e83610706565b73ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b92560405160405180910390a45050565b6000610def82610cb7565b610e2e576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610e2590612185565b60405180910390fd5b6000610e3983610706565b90508073ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff161480610ea857508373ffffffffffffffffffffffffffffffffffffffff16610e90846104b6565b73ffffffffffffffffffffffffffffffffffffffff16145b80610eb95750610eb88185610b8c565b5b91505092915050565b8273ffffffffffffffffffffffffffffffffffffffff16610ee282610706565b73ffffffffffffffffffffffffffffffffffffffff1614610f38576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610f2f90612245565b60405180910390fd5b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff161415610fa8576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610f9f90612145565b60405180910390fd5b610fb3838383611380565b610fbe600082610d2b565b6001600360008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825461100e919061240b565b925050819055506001600360008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546110659190612384565b92505081905550816002600083815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550808273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef60405160405180910390a4505050565b611129848484610ec2565b61113584848484611385565b611174576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161116b90612105565b60405180910390fd5b50505050565b606060405180602001604052806000815250905090565b606060008214156111d9576040518060400160405280600181526020017f30000000000000000000000000000000000000000000000000000000000000008152509050611339565b600082905060005b6000821461120b5780806111f490612527565b915050600a8261120491906123da565b91506111e1565b60008167ffffffffffffffff81111561124d577f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b6040519080825280601f01601f19166020018201604052801561127f5781602001600182028036833780820191505090505b5090505b6000851461133257600182611298919061240b565b9150600a856112a79190612570565b60306112b39190612384565b60f81b8183815181106112ef577f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a905350600a8561132b91906123da565b9450611283565b8093505050505b919050565b6001816000016000828254019250508190555050565b600081600001549050919050565b61137c82826040518060200160405280600081525061151c565b5050565b505050565b60006113a68473ffffffffffffffffffffffffffffffffffffffff16611577565b1561150f578373ffffffffffffffffffffffffffffffffffffffff1663150b7a026113cf610d23565b8786866040518563ffffffff1660e01b81526004016113f1949392919061207c565b602060405180830381600087803b15801561140b57600080fd5b505af192505050801561143c57506040513d601f19601f8201168201806040525081019061143991906119f9565b60015b6114bf573d806000811461146c576040519150601f19603f3d011682016040523d82523d6000602084013e611471565b606091505b506000815114156114b7576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016114ae90612105565b60405180910390fd5b805181602001fd5b63150b7a0260e01b7bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916817bffffffffffffffffffffffffffffffffffffffffffffffffffffffff191614915050611514565b600190505b949350505050565b611526838361158a565b6115336000848484611385565b611572576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161156990612105565b60405180910390fd5b505050565b600080823b905060008111915050919050565b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1614156115fa576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016115f190612205565b60405180910390fd5b61160381610cb7565b15611643576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161163a90612125565b60405180910390fd5b61164f60008383611380565b6001600360008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825461169f9190612384565b92505081905550816002600083815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550808273ffffffffffffffffffffffffffffffffffffffff16600073ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef60405160405180910390a45050565b600061176b61176684612311565b6122e0565b90508281526020810184848401111561178357600080fd5b61178e8482856124b3565b509392505050565b6000813590506117a58161266e565b92915050565b6000813590506117ba81612685565b92915050565b6000813590506117cf8161269c565b92915050565b6000815190506117e48161269c565b92915050565b600082601f8301126117fb57600080fd5b813561180b848260208601611758565b91505092915050565b600081359050611823816126b3565b92915050565b60006020828403121561183b57600080fd5b600061184984828501611796565b91505092915050565b6000806040838503121561186557600080fd5b600061187385828601611796565b925050602061188485828601611796565b9150509250929050565b6000806000606084860312156118a357600080fd5b60006118b186828701611796565b93505060206118c286828701611796565b92505060406118d386828701611814565b9150509250925092565b600080600080608085870312156118f357600080fd5b600061190187828801611796565b945050602061191287828801611796565b935050604061192387828801611814565b925050606085013567ffffffffffffffff81111561194057600080fd5b61194c878288016117ea565b91505092959194509250565b6000806040838503121561196b57600080fd5b600061197985828601611796565b925050602061198a858286016117ab565b9150509250929050565b600080604083850312156119a757600080fd5b60006119b585828601611796565b92505060206119c685828601611814565b9150509250929050565b6000602082840312156119e257600080fd5b60006119f0848285016117c0565b91505092915050565b600060208284031215611a0b57600080fd5b6000611a19848285016117d5565b91505092915050565b600060208284031215611a3457600080fd5b6000611a4284828501611814565b91505092915050565b611a548161243f565b82525050565b611a6381612451565b82525050565b6000611a7482612341565b611a7e8185612357565b9350611a8e8185602086016124c2565b611a978161265d565b840191505092915050565b6000611aad8261234c565b611ab78185612368565b9350611ac78185602086016124c2565b611ad08161265d565b840191505092915050565b6000611ae68261234c565b611af08185612379565b9350611b008185602086016124c2565b80840191505092915050565b6000611b19603283612368565b91507f4552433732313a207472616e7366657220746f206e6f6e20455243373231526560008301527f63656976657220696d706c656d656e74657200000000000000000000000000006020830152604082019050919050565b6000611b7f601c83612368565b91507f4552433732313a20746f6b656e20616c7265616479206d696e746564000000006000830152602082019050919050565b6000611bbf602483612368565b91507f4552433732313a207472616e7366657220746f20746865207a65726f2061646460008301527f72657373000000000000000000000000000000000000000000000000000000006020830152604082019050919050565b6000611c25601983612368565b91507f4552433732313a20617070726f766520746f2063616c6c6572000000000000006000830152602082019050919050565b6000611c65602c83612368565b91507f4552433732313a206f70657261746f7220717565727920666f72206e6f6e657860008301527f697374656e7420746f6b656e00000000000000000000000000000000000000006020830152604082019050919050565b6000611ccb603883612368565b91507f4552433732313a20617070726f76652063616c6c6572206973206e6f74206f7760008301527f6e6572206e6f7220617070726f76656420666f7220616c6c00000000000000006020830152604082019050919050565b6000611d31602a83612368565b91507f4552433732313a2062616c616e636520717565727920666f7220746865207a6560008301527f726f2061646472657373000000000000000000000000000000000000000000006020830152604082019050919050565b6000611d97602983612368565b91507f4552433732313a206f776e657220717565727920666f72206e6f6e657869737460008301527f656e7420746f6b656e00000000000000000000000000000000000000000000006020830152604082019050919050565b6000611dfd602083612368565b91507f4552433732313a206d696e7420746f20746865207a65726f20616464726573736000830152602082019050919050565b6000611e3d602c83612368565b91507f4552433732313a20617070726f76656420717565727920666f72206e6f6e657860008301527f697374656e7420746f6b656e00000000000000000000000000000000000000006020830152604082019050919050565b6000611ea3602983612368565b91507f4552433732313a207472616e73666572206f6620746f6b656e2074686174206960008301527f73206e6f74206f776e00000000000000000000000000000000000000000000006020830152604082019050919050565b6000611f09602f83612368565b91507f4552433732314d657461646174613a2055524920717565727920666f72206e6f60008301527f6e6578697374656e7420746f6b656e00000000000000000000000000000000006020830152604082019050919050565b6000611f6f602183612368565b91507f4552433732313a20617070726f76616c20746f2063757272656e74206f776e6560008301527f72000000000000000000000000000000000000000000000000000000000000006020830152604082019050919050565b6000611fd5603183612368565b91507f4552433732313a207472616e736665722063616c6c6572206973206e6f74206f60008301527f776e6572206e6f7220617070726f7665640000000000000000000000000000006020830152604082019050919050565b612037816124a9565b82525050565b60006120498285611adb565b91506120558284611adb565b91508190509392505050565b60006020820190506120766000830184611a4b565b92915050565b60006080820190506120916000830187611a4b565b61209e6020830186611a4b565b6120ab604083018561202e565b81810360608301526120bd8184611a69565b905095945050505050565b60006020820190506120dd6000830184611a5a565b92915050565b600060208201905081810360008301526120fd8184611aa2565b905092915050565b6000602082019050818103600083015261211e81611b0c565b9050919050565b6000602082019050818103600083015261213e81611b72565b9050919050565b6000602082019050818103600083015261215e81611bb2565b9050919050565b6000602082019050818103600083015261217e81611c18565b9050919050565b6000602082019050818103600083015261219e81611c58565b9050919050565b600060208201905081810360008301526121be81611cbe565b9050919050565b600060208201905081810360008301526121de81611d24565b9050919050565b600060208201905081810360008301526121fe81611d8a565b9050919050565b6000602082019050818103600083015261221e81611df0565b9050919050565b6000602082019050818103600083015261223e81611e30565b9050919050565b6000602082019050818103600083015261225e81611e96565b9050919050565b6000602082019050818103600083015261227e81611efc565b9050919050565b6000602082019050818103600083015261229e81611f62565b9050919050565b600060208201905081810360008301526122be81611fc8565b9050919050565b60006020820190506122da600083018461202e565b92915050565b6000604051905081810181811067ffffffffffffffff821117156123075761230661262e565b5b8060405250919050565b600067ffffffffffffffff82111561232c5761232b61262e565b5b601f19601f8301169050602081019050919050565b600081519050919050565b600081519050919050565b600082825260208201905092915050565b600082825260208201905092915050565b600081905092915050565b600061238f826124a9565b915061239a836124a9565b9250827fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff038211156123cf576123ce6125a1565b5b828201905092915050565b60006123e5826124a9565b91506123f0836124a9565b925082612400576123ff6125d0565b5b828204905092915050565b6000612416826124a9565b9150612421836124a9565b925082821015612434576124336125a1565b5b828203905092915050565b600061244a82612489565b9050919050565b60008115159050919050565b60007fffffffff0000000000000000000000000000000000000000000000000000000082169050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6000819050919050565b82818337600083830152505050565b60005b838110156124e05780820151818401526020810190506124c5565b838111156124ef576000848401525b50505050565b6000600282049050600182168061250d57607f821691505b60208210811415612521576125206125ff565b5b50919050565b6000612532826124a9565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff821415612565576125646125a1565b5b600182019050919050565b600061257b826124a9565b9150612586836124a9565b925082612596576125956125d0565b5b828206905092915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b6000601f19601f8301169050919050565b6126778161243f565b811461268257600080fd5b50565b61268e81612451565b811461269957600080fd5b50565b6126a58161245d565b81146126b057600080fd5b50565b6126bc816124a9565b81146126c757600080fd5b5056fea26469706673582212201af45c41052aa624078e93492b4fbae745c14e40ed90f1836aa34ca4524062aa64736f6c63430008000033
"""
