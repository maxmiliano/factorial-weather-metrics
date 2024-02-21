# Factorial Code Challenge

## Description

We need a Frontend + Backend application that allows you to post and visualize weather metrics. Each metric will have: Timestamp, name, and value. The metrics will be shown in a timeline and must show averages per minute/hour/day. The metrics will be persisted in the database.

## Stack

- **Ruby on Rails as the backend**: It was chosen because it is a framework that allows you to create APIs quickly and easily. It has a lot of libraries and gems that help to create a robust and secure application.
- **React for the frontend**: It was chosen because of it allows us to create a dynamic and interactive user interface based on components.
- **PostgreSQL as the database**: It was chosen because it is a robust and reliable database that allows us to store and retrieve data quickly and easily.
- **Docker for development and production**: It allows us to create a development environment quickly and easily. It also allows us to create a production environment that is easy to scale and maintain.

## Decisions

- **Split application**: The application was split into two parts: the backend and the frontend. It was chosen because it allows us to create a more scalable and maintainable application. It also allows us to have separate concerns and easily spot what is part of the backend and frontend.
- **Metrics**: The metrics will be stored in a table called `metrics` with the following columns: `id`, `name`, `value`, `timestamp`, `created_at`, and `updated_at`. Decided to add more fields to the table to make it easier to query and filter the data.
- **Metric Types**: The `metrics_type` is a string field in the `metrics` table that will be used to filter the metrics. It was chosen because it is a simple and flexible way to filter and group the metrics. If the application grows and the metrics become more complex, we can create a new table to store the metrics type and create a relationship between the `metrics` and `metrics_type` tables.
- **Averages**: The averages will be calculated using the `AVG` function from PostgreSQL. It was chosen because it is a fast and reliable way to calculate averages. If the application grows and the averages become a bottleneck, we can create a cache to store the averages and update them periodically.
  Note: It was considered to calculate the averages in the frontend, but it was discarded because it would require a lot of data to be transferred from the backend to the frontend, and it would make the application slower and less reliable. Having the averages calculated in the backend allows us to have more control over the data and make the application more scalable.
- **Error handling**: The application has a basic error handling in the backend. Decided to leave a more robust error handling as future improvements when the application need to scale up.

## How to run the application

### Development

1. Clone the repository
2. Run `docker-compose up` in the root folder to start the application
  This is will start:
    - Database service (PostgreSQL)
    - Backend application (Ruby on Rails)
    - Frontend application (React)
  The first time it will take a while to download the images and install the dependencies.
3. The frontend will be available at `http://localhost:4000`
4. The backend will be available at `http://localhost:3000`


### Tests

- **Backend**: To run tests in the backend, run the following command in the root folder:

```bash
bundle exec rspec
```

## Future Improvements

- **Authentication**: Add authentication to the application to make it secure and reliable.
- **Metrics Type**: Create a new table to store the metrics type and create a relationship between the `metrics` and `metrics_type` tables.
- **Metric Name**: Normalize the data model by moving the `name` field to a new model (`City`, for instance) and create a relationship between the `metrics` and the table with this `metric_name` tables.
- **Averages Cache**: Create a cache to store the averages and update them periodically.
- **Charts**: Add charts to the frontend to visualize the metrics and averages.
- **Error handling**: Implement error handling also in the frontend to make the application more reliable and user-friendly.
- **Frontend Tests**: Add tests to the frontend to make the application more reliable and maintainable.
