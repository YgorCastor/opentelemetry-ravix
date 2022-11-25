defmodule OpentelemetryRavix do
  require OpenTelemetry.Tracer

  def setup(store, config \\ []) do
    success_event = [:ravix, store, :requests, :success]
    failure_event = [:ravix, store, :requests, :error]

    :telemetry.attach(
      {__MODULE__, success_event},
      success_event,
      &__MODULE__.handle_success/4,
      config
    )

    :telemetry.attach(
      {__MODULE__, failure_event},
      failure_event,
      &__MODULE__.handle_failure/4,
      config
    )
  end

  @doc false
  def handle_success(
        _event,
        _event_payload,
        event_labels,
        config
      ) do
    {parent_token, span} = build_span(event_labels, config)
    OpenTelemetry.Span.set_status(span, OpenTelemetry.status(:ok))
    OpenTelemetry.Span.end_span(span)

    if parent_token != :undefined do
      OpenTelemetry.Ctx.detach(parent_token)
    end
  end

  @doc false
  def handle_failure(
        _event,
        _event_payload,
        event_labels,
        config
      ) do
    {parent_token, span} = build_span(event_labels, config)
    OpenTelemetry.Span.set_status(span, OpenTelemetry.status(:error))
    OpenTelemetry.Span.end_span(span)

    if parent_token != :undefined do
      OpenTelemetry.Ctx.detach(parent_token)
    end
  end

  defp build_span(
         %{node_url: node_url, database: database},
         config
       ) do
    end_time = :opentelemetry.timestamp()
    span_name = "RavenDB #{database}"

    additional_attributes = Keyword.get(config, :additional_attributes, %{})

    base_attributes = %{
      "db.name": database,
      "db.url": node_url
    }

    attributes =
      base_attributes
      |> Map.merge(additional_attributes)

    parent_context =
      case OpentelemetryProcessPropagator.fetch_ctx(self()) do
        :undefined ->
          OpentelemetryProcessPropagator.fetch_parent_ctx(1, :"$callers")

        ctx ->
          ctx
      end

    parent_token =
      if parent_context != :undefined do
        OpenTelemetry.Ctx.attach(parent_context)
      else
        :undefined
      end

    {parent_token,
     OpenTelemetry.Tracer.start_span(span_name, %{
       start_time: end_time,
       attributes: attributes,
       kind: :client
     })}
  end
end
