import React from 'react';
import './App.css';
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';
import About from './about';
import Calc from './calc';

function App() {
  return (
    <Router>
      <div className="App">
        <header className="App-header">
          <Link to="/">Home</Link><Link to="/about">About</Link>
        </header>
        <div className="Body">
          <Route exact path="/" component={Calc} />
          <Route path="/about" component={About} />
        </div>
      </div>
    </Router>
  );
}

export default App;
