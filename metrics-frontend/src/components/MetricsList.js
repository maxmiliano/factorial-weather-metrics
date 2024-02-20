import axios from 'axios';
import React, { useEffect, useState } from 'react';
import { Button, Table } from 'react-bootstrap';
import { useNavigate } from 'react-router-dom';

function MetricsList() {
  const [metrics, setMetrics] = useState([]);
  const navigate = useNavigate();

  const handleDelete = (id) => {
    if(window.confirm('Are you sure you want to delete this metric?')) {
      axios.delete(`http://localhost:3000/metrics/${id}`)
        .then(() => {
          setMetrics(metrics.filter(metric => metric.id !== id));

        })
        .catch(error => {
          console.error('Error deleting metric:', error);
        });
    }
  };

  useEffect(() => {
    fetch('http://localhost:3000/metrics')
      .then(response => response.json())
      .then(data => setMetrics(data))
      .catch(error => console.error('Error fetching metrics:', error));
  }, []);

  return (
    <div>
      <h2>Metrics List</h2>
      <Table striped bordered hover>
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Value</th>
            <th>Metric Type</th>
            <th>Unit</th>
            <th>Timestamp</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {metrics.map(metric => (
            <tr key={metric.id}>
              <td>{metric.id}</td>
              <td>{metric.name}</td>
              <td>{metric.value}</td>
              <td>{metric.metric_type}</td>
              <td>{metric.unit}</td>
              <td>{new Date(metric.timestamp).toLocaleString()}</td>
              <td>
                <Button variant="primary" className="me-2" onClick={() => navigate(`/edit/${metric.id}`)}>Edit</Button>
                <Button variant="danger" onClick={() => handleDelete(metric.id)}>Delete</Button>
              </td>
            </tr>
          ))}
        </tbody>
      </Table>
    </div>
  );
}

export default MetricsList;
