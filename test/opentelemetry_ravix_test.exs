defmodule OpentelemetryRavixTest do
  use OpentelemetryRavix.Case

  require OpenTelemetry.Tracer
  require Record

  alias OpentelemetryRavix.Test.Store, as: TestStore
  alias Ravix.Operations.Database.Maintenance

  for {name, spec} <- Record.extract_all(from_lib: "opentelemetry/include/otel_span.hrl") do
    Record.defrecord(name, spec)
  end

  setup do
    :application.stop(:opentelemetry)
    :application.set_env(:opentelemetry, :tracer, :otel_tracer_default)

    :application.set_env(:opentelemetry, :processors, [
      {:otel_batch_processor, %{scheduled_delay_ms: 1}}
    ])

    :application.start(:opentelemetry)

    :otel_batch_processor.set_exporter(:otel_exporter_pid, self())

    OpenTelemetry.Tracer.start_span("test")

    on_exit(fn ->
      OpenTelemetry.Tracer.end_span()
    end)
  end

  test "It should trigger on successfull queries" do
    OpentelemetryRavix.setup(TestStore)

    Maintenance.database_stats(TestStore)

    assert_receive {:span,
                    span(
                      name: "RavenDB test",
                      attributes: attributes,
                      kind: :client,
                      status: status
                    )}

    assert %{
             "db.name": "test"
           } = :otel_attributes.map(attributes)

    assert {:status, :ok, ""} = status
  end

  test "It should trigger on failed queries" do
    OpentelemetryRavix.setup(TestStore)

    Maintenance.database_stats(TestStore, "aaaaaa")

    assert_receive {:span,
                    span(
                      name: "RavenDB test",
                      attributes: attributes,
                      kind: :client,
                      status: status
                    )}

    assert %{
             "db.name": "test"
           } = :otel_attributes.map(attributes)

    assert {:status, :error, ""} = status
  end
end
