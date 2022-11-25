[![Elixir CI](https://github.com/YgorCastor/ravix/actions/workflows/elixir.yml/badge.svg)](https://github.com/YgorCastor/ravix/actions/workflows/elixir.yml) [![Coverage Status](https://coveralls.io/repos/github/YgorCastor/opentelemetry-ravix/badge.svg)](https://coveralls.io/github/YgorCastor/opentelemetry-ravix)
[![Hex](https://img.shields.io/hexpm/v/opentelemetry-ravix?style=flat-square)](https://hex.pm/packages/opentelemetry-ravix)


# OpentelemetryRavix

Opentelemetry Wrapper for Ravix

# Usage

## Instaling

Add OpentelemetryRavix to your mix.exs dependencies

```elixir
{:opentelemetry_ravix, "~> 0.1.0"}
```

## Setup the Store and the Telemetry listener

Create a Ravix Store Module for your repository

```elixir
defmodule YourProject.YourStore do
  use Ravix.Documents.Store, otp_app: :your_app
end

OpentelemetryRavix.setup(YourProject.YourStore)
```
