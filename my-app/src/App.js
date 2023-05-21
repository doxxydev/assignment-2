import React, { useEffect, useState } from 'react';
import Web3 from 'web3';
import myContractABI from './artifacts/contracts/MyNFT.sol/MyNFT.json';
import './App.css';

function App() {
  const [web3, setWeb3] = useState(undefined);
  const [account, setAccount] = useState('');
  const [contract, setContract] = useState(undefined);

  useEffect(() => {
    const init = async () => {
      if (typeof window.ethereum !== 'undefined') {
        const web3Instance = new Web3(window.ethereum);
        setWeb3(web3Instance);
      } else {
        window.alert('Please install MetaMask!');
      }
    }
    init();
  }, []);

  const connectToMetamask = async () => {
    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
    const contractInstance = new web3.eth.Contract(myContractABI.abi, "0x5fbdb2315678afecb367f032d93f642f64180aa3");
    console.log("Contract Instance:", contractInstance);
    setAccount(accounts[0]);
    setContract(contractInstance);
  }

  const mintToken = async () => {
    if(!contract) return;
    await contract.methods.mint(1).send({ from: account, value: web3.utils.toWei('0.05', 'ether') });
  }

  return (
    <div className="app">
      <div className="button-container">
        <button className="button" onClick={connectToMetamask}>Connect to MetaMask</button>
        <button className="button" onClick={mintToken}>Mint Token</button>
      </div>
      {contract && <h2 className="contract-address">Contract Address: {contract.address}</h2>}
    </div>
  );
}

export default App;
