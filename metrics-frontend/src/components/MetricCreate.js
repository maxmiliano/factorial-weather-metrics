import React, { useState } from 'react';
import axios from 'axios';
import { Button, Form, Container, Row, Col } from 'react-bootstrap';

function MetricCreate() {
  const [metric, setMetric] = useState({
    name: '',
    value: '',
    metric_type: '',
    unit: '',
    timestamp: '',
  });
  const [errors, setErrors] = useState({});

  const handleChange = (e) => {
    setMetric({ ...metric, [e.target.name]: e.target.value });
  }

  const handleSubmit = (e) => {
    e.preventDefault();
    axios.post('http://localhost:3000/metrics', metric)
      .then((response) => {
        console.log(response);
        setErrors({});
      })
      .catch((error) => {
        if (error.response && error.response.status === 422) {
          setErrors(error.response.data.errors);
        } else {
          console.log('Error creating metric:', error);
        }
      });
  };


  return(
    <Container>
      <Row>
        <Col>
          <h2>Create Metric</h2>
          <Form onSubmit={handleSubmit}>
            <Form.Group className="mb-3" controlId="formMetricName">
              <Form.Label>Name:</Form.Label>
              <Form.Control
                type="text"
                name="name"
                value={metric.name}
                onChange={handleChange}
                placeholder="Enter metric name"
                isInvalid={!!errors.name} />
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
                isInvalid={!!errors.value} />
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
                isInvalid={!!errors.metric_type} />
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
                isInvalid={!!errors.unit} />
              {errors.unit && <Form.Control.Feedback type="invalid">{errors.unit}</Form.Control.Feedback>}
            </Form.Group>

            <Form.Group className="mb-3" controlId="formMetricTimestamp">
              <Form.Label>Timestamp:</Form.Label>
              <Form.Control
                type="datetime-local"
                name="timestamp"
                value={metric.timestamp}
                onChange={handleChange}
                isInvalid={!!errors.timestamp} />
              {errors.timestamp && <Form.Control.Feedback type="invalid">{errors.timestamp}</Form.Control.Feedback>}
            </Form.Group>

            <Button variant="primary" type="submit">
              Create Metric
            </Button>
          </Form>
        </Col>
      </Row>
    </Container>
  );
}

export default MetricCreate;
