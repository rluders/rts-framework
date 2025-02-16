extends State

func enter(params: Dictionary = {}) -> void:
	print("Entering Idle State")
	# Aqui, você pode configurar animações ou efeitos visuais para o estado ocioso

func exit() -> void:
	print("Exiting Idle State")
	# Limpar ou preparar ao sair do estado ocioso

func update(delta: float) -> void:
	# Atualizações lógicas para o estado ocioso, caso necessário
	pass
