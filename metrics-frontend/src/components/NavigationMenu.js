import React from 'react';
import { LinkContainer } from 'react-router-bootstrap';
import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';

function NavigationMenu() {
  return(
    <Navbar bg="light" expand="lg">
      <Navbar.Brand href="/">Metrics</Navbar.Brand>
      <Navbar.Toggle aria-controls="basic-navbar-nav" />
      <Navbar.Collapse id="basic-navbar-nav">
        <Nav className="mr-auto">
          <LinkContainer to="/">
            <Nav.Link>Averages</Nav.Link>
          </LinkContainer>
          <LinkContainer to="/create">
            <Nav.Link>Create</Nav.Link>
          </LinkContainer>
          <LinkContainer to="/list">
            <Nav.Link>List</Nav.Link>
          </LinkContainer>
        </Nav>
      </Navbar.Collapse>
    </Navbar>
  );
}

export default NavigationMenu;
