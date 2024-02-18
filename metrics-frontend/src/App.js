import './App.css';
import React, { useEffect, useState } from 'react';

function App() {
  const [metrics, setMetrics] = useState([]);

  useEffect(() => {
    fetch('http://localhost:3000/metrics')
      .then(response => response.json())
      .then(data => setMetrics(data))
      .catch(error => console.error('Error fetching metrics:', error));
  }, []);

  return (
    <div>
      <h1>Metrics</h1>
      <ul>
        {metrics.map(metric => (
          <li key={metric.id}>
            {metric.name} ({metric.metric_type}): {metric.value} {metric.unit} at {new Date(metric.timestamp).toLocaleString()}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;
