import './App.css';
import { useState } from 'react';
import axios from 'axios';


const TWEET_TEMPLATE = "I%20am%20joining%20Fuel%20Nomen%20testnet%20and%20my%20address%20is%20";

function App() {

  const [url, setUrl] = useState("");
  const [isConnected, setConnected] = useState(false);
  const [account, setAccount] = useState();
  const [balance, setBalance] = useState();


  const handleConnect = async (event) => {
    event.preventDefault();
    const isConnected = await window.fuel.connect();
    setConnected(isConnected);
    console.log("Connection response", isConnected);
    const accounts = await window.fuel.accounts();
    setAccount(accounts[0]);
    console.log("Account ", accounts[0]);
   

  }
  const handleSubmit = (event) => {
    event.preventDefault();
    const api_base = "http://localhost:3000/" + getTweetId(url) + "account"
    axios.get(api_base)
    
    .then(response => {
      alert(response.data);
      console.log(response);
    })
    // if error
    .catch(function(error) {
      console.log(error);
    });
  }

  
  const getTweetId = (tweet_link) => {
    const status_index = tweet_link.indexOf("status/") + 7;
    const suffix_index = tweet_link.indexOf("?s=");
    var tweet_id = "";
    if(suffix_index > 0){
      tweet_id = tweet_link.substring(status_index,suffix_index);
    }
    else{
      tweet_id = tweet_link.substring(status_index);
    }
    return tweet_id;
    };
    
  return (
    <div className="App">
      <header className="App-header">
        <h2>
        1. Claim testnet tokens from {" "}
        <a
          className='App-link'
          href="https://faucet-beta-2.fuel.network/"
          target="_blank"
          rel="noopener noreferrer"
        >
        Fuel Faucet
        </a>
        </h2>
        <h2>
          2.
          <button className="App-button-connect"
                  onClick={handleConnect}>
          Connect to fuel wallet
          </button>
        </h2>
        <h2>
        3. 
        <a
          className='App-link'
          href={"https://twitter.com/intent/tweet?text=" + TWEET_TEMPLATE +account}
          target="_blank"
          rel="noopener noreferrer"
        >
        Tweet
        </a>
        {" "}
        your address to prove you're not a bot
        </h2>

        <h2>
        
        <form onSubmit={handleSubmit}>
        4.
        <input 
               className='App-textbox'
               type="text"
               placeholder='Paste tweet link'       
               value={url}
               onChange={(e) => setUrl(e.target.value)} />

        <input className="App-button-claim" type="submit" value="Claim" />
      </form>
      </h2>
      </header>
    </div>
  );
}

export default App;
