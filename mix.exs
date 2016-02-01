defmodule ElixirKoans do
  use Mix.Project

  def project do
    [
      app: :elixir_koans,
      version: "1.0.0",
      deps: [
        {:dogma, "~>0.0", only: :dev}
      ]
    ]
  end
end
