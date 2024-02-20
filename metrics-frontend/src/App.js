import './App.css';
import React, { useEffect, useState } from 'react';
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';
import NavigationMenu from './components/NavigationMenu';
import AveragesList from './components/AveragesList';
import MetricCreate from './components/MetricCreate';
import MetricsList from './components/MetricsList';
import MetricsEdit from './components/MetricsEdit';

function App() {
  return (
    <BrowserRouter>
      <div className="App">
        <NavigationMenu />
        <Routes>
          <Route path="/" element={<AveragesList />} />
          <Route path="/create" element={<MetricCreate />} />
          <Route path="/list" element={<MetricsList />} />
          <Route path="/edit/:id" element={<MetricsEdit />} />
        </Routes>
      </div>
    </BrowserRouter>
  );
}

export default App;
