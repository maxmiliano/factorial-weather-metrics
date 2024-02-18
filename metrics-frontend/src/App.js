import './App.css';
import React, { useEffect, useState } from 'react';

function App() {
  const [groupedMetrics, setGroupedMetrics] = useState([]);
  const [interval, setInterval] = useState('minute');

  useEffect(() => {
    fetch(`http://localhost:3000/metrics/averages?interval=${interval}`)
      .then(response => response.json())
      .then(data => setGroupedMetrics(data))
      .catch(error => console.error('Error fetching metrics:', error));
  }, [interval]);

  // Function to format interval_group based on the selected interval
  const formatIntervalGroup = (intervalGroup, interval) => {
    const date = new Date(intervalGroup);
    switch (interval) {
      case 'day':
        return date.toLocaleDateString();
      case 'hour':
        return `${date.toLocaleDateString()} ${date.getHours()}:00`;
      case 'minute':
        return `${date.toLocaleDateString()} ${date.getHours()}:${String(date.getMinutes()).padStart(2, '0')}`;
      default:
        return intervalGroup;
    }
  };

  return (
    <div className="App">
      <h1>Metrics Averages</h1>
      <div>
        <label htmlFor="interval-select">Group by:</label>
        <select id="interval-select" value={interval} onChange={e => setInterval(e.target.value)}>
          <option value="minute">Minute</option>
          <option value="hour">Hour</option>
          <option value="day">Day</option>
        </select>
      </div>
      <ul>
        {groupedMetrics.map((metric, index) => (
          <div key={index}>
            <h2>{metric.name} ({metric.metric_type}): {formatIntervalGroup(metric.interval_group, interval)}</h2>
            <p>Average: {metric.average_value} {metric.unit}</p>
          </div>
        ))}
      </ul>
    </div>
  );
}

export default App;
