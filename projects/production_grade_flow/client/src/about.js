import React from 'react';
import { Link } from 'react-router-dom';

const About = () => {
  return (
    <div>
      <h1>About</h1>
      <p>This project is part of the <Link to="https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide">Docker and Kubernetes: The Complete Guide</Link> course on Udemy.</p>
    </div>
  );
}

export default About;