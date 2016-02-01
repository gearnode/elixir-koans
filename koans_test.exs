ExUnit.start
ExUnit.configure trace: true
defmodule KoansTest do
  # Run unit test on concurrently with other tests
  use ExUnit.Case, async: true
end
