import 'dotenv/config';
import { makeApp } from './server';
import { ethers } from 'ethers';
import { database } from './db';

const privateKey = process.env.PRIVATE_KEY;
const port = process.env.PORT || '8080';

if (!privateKey) {
  throw new Error('Missing PRIVATE_KEY or PORT env var');
}

const address = ethers.utils.computeAddress(privateKey);
const signer = new ethers.utils.SigningKey(privateKey);
const app = makeApp(signer, '/', database);
console.log(`Serving on port ${port} with signing address ${address}`);
app.listen(parseInt(port));

module.exports = app;
