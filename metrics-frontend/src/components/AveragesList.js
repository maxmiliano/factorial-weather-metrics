import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Container, Table, Form, ListGroup } from 'react-bootstrap';

function AveragesList() {
  const [groupedMetrics, setGroupedMetrics] = useState([]);
  const [interval, setInterval] = useState('minute');

  useEffect(() => {
    fetch(`http://localhost:3000/metrics/averages?interval=${interval}`)
      .then(response => response.json())
      .then(data => {
        const groupedByName = data.reduce((acc, currentValue) => {
          if (!acc[currentValue.name]) {
            acc[currentValue.name] = [];
          }
          acc[currentValue.name].push(currentValue);
          return acc;
        }, {});
        setGroupedMetrics(groupedByName)
      })
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
    <Container>
      <h1>Metrics Timeline</h1>
      <Form.Group controlId="interval-select">
        <Form.Label>Grouped by:</Form.Label>
        <Form.Control as="select" value={interval} onChange={e => setInterval(e.target.value)}>
          <option value="minute">Minute</option>
          <option value="hour">Hour</option>
          <option value="day">Day</option>
        </Form.Control>
      </Form.Group>

      <div className="mb-3" >
        {Object.keys(groupedMetrics).map((cityName) => (
          <div key={cityName}>
            <h2>{cityName}</h2>
            <Table striped bordered hover size="sm">
              <thead>
                <tr>
                  <th>Time</th>
                  <th>Metric Type</th>
                  <th>Average Value</th>
                </tr>
              </thead>
              <tbody>
                {groupedMetrics[cityName].map((metric, index) => (
                  <tr key={index}>
                    <td>{formatIntervalGroup(metric.interval_group, interval)}</td>
                    <td>{metric.metric_type}</td>
                    <td>{parseFloat(metric.average_value).toFixed(1)} {metric.unit}</td>
                  </tr>
                ))}
              </tbody>
            </Table>
          </div>
        ))}
      </div>
    </Container>
  );
};

export default AveragesList;
