CREATE TABLE superob AS (
  standard_deviation pk9real,       // Standard deviation of raw observations used to make up the super-obbed value
  n_obs pk9real,                    // Number of raw observations that went into the super-obbed value
  cloud_fraction pk9real,           // Fraction of observations that were cloudy
  sf_max pk9real,                   // Structure function maximum
);

