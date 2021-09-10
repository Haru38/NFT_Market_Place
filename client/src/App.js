import React, { useState, useEffect } from "react";
import NFTMarketContract from "./contracts/NFTMarket.json";
import getWeb3 from "./getWeb3";

import { makeStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';


import { BrowserRouter as Router, Route, NavLink } from "react-router-dom";

import Home from './Home';
// import SellItem from './SellItem'
// import MyNFTs from './MyNFTs'
// import BuyItem from './BuyItem'


import "./App.css";

const App = () => {
  const [state, setState] = useState({web3: null, accounts: null, contract: null});

  // useEffect(() => {
  //   const init = async() => {
  //     try {
  //       // Get network provider and web3 instance.
  //       const web3 = await getWeb3();

  //       // Use web3 to get the user's accounts.
  //       const accounts = await web3.eth.getAccounts();

  //       // Get the contract instance.
  //       const networkId = await web3.eth.net.getId();
  //       const deployedNetwork = NFTMarketContract.networks[networkId];
  //       const instance = new web3.eth.Contract(
  //         NFTMarketContract.abi,
  //         deployedNetwork && deployedNetwork.address,
  //       );

  //       // Set web3, accounts, and contract to the state, and then proceed with an
  //       setState({web3, accounts, contract: instance});

  //     } catch(error) {
  //       // Catch any errors for any of the above operations.
  //       alert(
  //         `Failed to load web3, accounts, or contract. Check console for details.`,
  //       );
  //       console.error(error);
  //     }
  //   }
  //   init();
  // }, []);

  // const runExample = async () => {
  //   const { accounts, contract } = state;
  // };

  return (
    
      <Router>
        <div>
        <AppBar position="static" color="default" style={{ margin: 0 }}>
          <Toolbar>
           <Typography variant="h6" color="inherit">
             <NavLink className="nav-link" to="/">Home</NavLink>
           </Typography>
           
          </Toolbar>
       </AppBar>
    
        <Route path="/" exact component={Home} />
        </div>
      </Router>
  
  )
}


export default App;

/**
 *  <Route path="/SellNFTItem/" component={SellItem} />
            <Route path="/MyNFTs/" component={MyNFTs} />
            <Route path="/BuyNFTItem/" component={BuyItem} />

                  <NavLink className="nav-link" to="/new/">Sell NFT Item</NavLink>
          <NavLink className="nav-link" to="/new/">My NFTsm</NavLink>
          <NavLink className="nav-link" to="/new/">Buy NFT Item</NavLink>
 * 
 */