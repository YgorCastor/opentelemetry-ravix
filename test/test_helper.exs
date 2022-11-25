ExUnit.start()

defmodule OpentelemetryRavix.Case do
  use ExUnit.CaseTemplate

  import Ravix.RQL.Query

  setup do
    _ = start_supervised!({Finch, name: Ravix.Finch})
    _ = start_supervised!(OpentelemetryRavix.Test.Store)

    {:ok, session_id} = OpentelemetryRavix.Test.Store.open_session()
    {:ok, _} = from("@all_docs") |> delete_for(session_id)
    _ = OpentelemetryRavix.Test.Store.close_session(session_id)

    :ok
  end
end
