import React from 'react';
import logo from './logo.svg';
import './App.css';
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';
import About from './about';
import Calc from './calc';

function App() {
  return (
    <Router>
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <Link to="/" className="App-link">Home</Link>
          <Link to="/about" className="App-link">About</Link>
        </header>
        <div>
          <Route exact path="/" component={Calc} />
          <Route path="/about" component={About} />
        </div>
      </div>
    </Router>
  );
}

export default App;
