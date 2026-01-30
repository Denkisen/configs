return {
	"yetone/avante.nvim",
	opts = {
		instructions_file = "",
		provider = "ollama",
		providers = {
			ollama = {
				__inherited_from = "openai",
				api_key_name = "",
				endpoint = "http://127.0.0.1:11434",
				model = "gpt-oss:20b",
			},
		},
	},
}
