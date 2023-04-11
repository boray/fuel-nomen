const axios = require('axios');
require('dotenv').config();
var express = require("express");
var fuels = require("fuels");

var app = express();

const NOMEN_TWITTER = process.env.NOMEN_TWITTER;
const CONTRACT_ID = process.env.CONTRACT_ID;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const HEADER = 'Bearer ' + process.env.TOKEN;
const ACCOUNT_AGE_LIMIT = process.env.ACCOUNT_AGE_LIMIT;

const wallet = fuels.Wallet.fromPrivateKey(PRIVATE_KEY);


app.get('/:id/:address', async (req, res) => {
const tweet_id = req.params.id;
const fuel_address = req.params.address;
request_url = 'https://api.twitter.com/2/tweets/'+tweet_id+'?expansions=author_id&user.fields=created_at';
var config = {
  method: 'get',
  url: request_url,
  headers: { 
    'Authorization': HEADER, 
  }
};

axios(config)
.then(function (response) {
  resp = JSON.stringify(response.data);
  tweet_text = response.data.data.text;
  account_creation_date = response.data.includes.users[0].created_at;
  const isEligible = checkEligible(fuel_address,tweet_text,account_creation_date);
  res.send(isEligible);
})
.catch(function (error) {
  return error;
});

 
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
 });
 
const checkEligible = (address,text,date) => {
  const addressOk = text.includes(address);
  const nomenMentioned = text.includes(NOMEN_TWITTER);
  var d1 = new Date();
  var d2 = new Date(date);
  const accountOk = (d1.getTime() - d2.getTime()) > ACCOUNT_AGE_LIMIT;
  if(accountOk){
    if(addressOk){
      if(nomenMentioned){
        return "eligible";
      }
      else{
        return "nomen_is_not_mentioned"
      }
    }
    else{
      return "address_is_not_mentioned"
    }
  }
  else{
    return "account_is_not_old_enough"
  }
}; 


