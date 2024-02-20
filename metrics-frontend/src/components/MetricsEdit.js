import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Button, Form, Container, Row, Col } from 'react-bootstrap';
import { useParams, useNavigate } from 'react-router-dom';

function MetricEdit() {
  const [metric, setMetric] = useState({
    name: '',
    value: '',
    metric_type: '',
    unit: '',
    timestamp: '',
  });
  const { id } = useParams(); // Extracting ID from URL
  const [errors, setErrors] = useState({});
  const navigate = useNavigate();

  useEffect(() => {
    // Fetch the metric details from the API
    axios.get(`http://localhost:3000/metrics/${id}`)
      .then(response => {
        console.log(response.data);
        response.data.timestamp = new Date(response.data.timestamp).toISOString().slice(0, 16);
        setMetric(response.data);
      })
      .catch(error => {handleError(error)});
  }, [id]);

  const handleChange = (e) => {
    console.log(e.target.name, e.target.value);
    setMetric({ ...metric, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    axios.put(`http://localhost:3000/metrics/${id}`, metric)
      .then(() => {
        navigate('/list');
      })
      .catch(error => handleError(error));
  };

  const handleError = (error) => {
    if (error.response && error.response.status === 422) {
      setErrors(error.response.data.errors);
    } else {
      console.log('Error creating metric:', error);
    }
  }

  return (
    <Container>
      <Row>
        <Col>
          <h2>Edit Metric</h2>
          <Form onSubmit={handleSubmit}>
          <Form.Group className="mb-3" controlId="formMetricName">
              <Form.Label>Name:</Form.Label>
              <Form.Control
                type="text"
                name="name"
                value={metric.name}
                onChange={handleChange}
                placeholder="Enter metric name"
                isInvalid={!!errors.name}
              />
              {errors.name && <Form.Control.Feedback type="invalid">{errors.name}</Form.Control.Feedback>}
            </Form.Group>

            <Form.Group className="mb-3" controlId="formMetricValue">
              <Form.Label>Value:</Form.Label>
              <Form.Control
                type="text"
                name="value"
                value={metric.value}
                onChange={handleChange}
                placeholder="Enter metric value"
                isInvalid={!!errors.value}
              />
              {errors.value && <Form.Control.Feedback type="invalid">{errors.value}</Form.Control.Feedback>}
            </Form.Group>

            <Form.Group className="mb-3" controlId="formMetricType">
              <Form.Label>Metric Type:</Form.Label>
              <Form.Control
                type="text"
                name="metric_type"
                value={metric.metric_type}
                onChange={handleChange}
                placeholder="Enter metric type"
                isInvalid={!!errors.metric_type}
              />
              {errors.metric_type && <Form.Control.Feedback type="invalid">{errors.metric_type}</Form.Control.Feedback>}
            </Form.Group>

            <Form.Group className="mb-3" controlId="formMetricUnit">
              <Form.Label>Unit:</Form.Label>
              <Form.Control
                type="text"
                name="unit"
                value={metric.unit}
                onChange={handleChange}
                placeholder="Enter unit"
                isInvalid={!!errors.unit}
              />
              {errors.unit && <Form.Control.Feedback type="invalid">{errors.unit}</Form.Control.Feedback>}
            </Form.Group>

            <Form.Group className="mb-3" controlId="formMetricTimestamp">
              <Form.Label>Timestamp:</Form.Label>
              <Form.Control
                type="datetime-local"
                name="timestamp"
                step="15"
                value={metric.timestamp}
                onChange={handleChange}
                isInvalid={!!errors.timestamp}
              />
              {errors.timestamp && <Form.Control.Feedback type="invalid">{errors.timestamp}</Form.Control.Feedback>}
            </Form.Group>

            <Button variant="primary" type="submit">Update Metric</Button>
          </Form>
        </Col>
      </Row>
    </Container>
  );
}

export default MetricEdit;
