import { useState } from 'react'
import './App.css'

function App() {
  const [count, setCount] = useState(0)
  const [available, setAvailable] = useState(false)
  const [message, setMessage] = useState("")



  return (
    <div className="App">
      <div>
        <a href="https://vitejs.dev" target="_blank">
          <img src="../public/fuelns.png" className="logo" alt="Fuel Name Service" />
        </a>
      </div>
      <h1>Fuel Name Service</h1>
      <div className="card">
        <input className="nameArea" type="text" name="name" placeholder="Search domain names"/>
      </div>
      <div>
      <button className="checkButton" onClick={() => setAvailable((available) => true)}>
          Check
        </button>
        <button className="mintButton" disabled={!available} onClick={() => setMessage("You have succesfully registered!")}>
          Register
        </button>
      </div>
      <div className="spaceDiv">

      </div>
      <p>
          {message}
     </p>
    </div>
  )
}

export default App
