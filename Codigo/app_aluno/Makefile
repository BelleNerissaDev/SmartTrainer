# Define o alvo padrão como 'help'
.DEFAULT_GOAL := help

# Variáveis
FLUTTER=flutter
PROJECT_NAME=nome_do_projeto
COVERAGE_PATH=coverage
LCOV_FILE=$(COVERAGE_PATH)/lcov.info

# Cria .dart_tool e .packages
.PHONY: init
init:
	$(FLUTTER) pub get
	$(MAKE) mock

# Executa todos os testes
.PHONY: test-all
test-all:
	$(FLUTTER) test --coverage

# Executa testes unitários
.PHONY: test-unit
test-unit:
	$(FLUTTER) test test/unit/ --coverage

# Executa testes de widget
.PHONY: test-widget
test-widget:
	$(FLUTTER) test test/widget/ --coverage

# Executa testes de integração
.PHONY: test-integration
test-integration:
	$(FLUTTER) test test/integration/ --coverage

# Gera cobertura de testes
.PHONY: coverage
coverage:
	@if [ -f "$(LCOV_FILE)" ]; then \
		genhtml $(LCOV_FILE) --output-directory $(COVERAGE_PATH)/html; \
		COVERAGE=$$(lcov --summary $(LCOV_FILE) | grep 'lines' | awk '{print $$2}' | sed 's/%//'); \
		echo "Coverage is $$COVERAGE%"; \
		if [ "$$COVERAGE" \< "60.0" ]; then \
			echo "Coverage is below 60%"; \
			exit 1; \
		fi; \
	else \
		echo "Error: $(LCOV_FILE) not found. Coverage report not generated."; \
		exit 1; \
	fi


# Executa o projeto
.PHONY: run
run:
	$(FLUTTER) run

# Compila o projeto
.PHONY: build
build:
	$(FLUTTER) build apk

# Analisa o código
.PHONY: analyze
analyze:
	$(FLUTTER) analyze

# Limpa arquivos gerados
.PHONY: clean
clean:
	$(FLUTTER) clean
	rm -rf $(COVERAGE_PATH)

# Cria os mocks de testes
.PHONY: mock
mock:
	dart run build_runner build --delete-conflicting-outputs

# Mostra todas as opções disponíveis
.PHONY: help
help:
	@echo "Comandos disponíveis:"
	@echo "  make init       			- Inicializa o projeto"
	@echo "  make test-all       		- Executa os testes do projeto"
	@echo "  make test-unit      		- Executa testes unitários"
	@echo "  make test-widget    		- Executa testes de widget"
	@echo "  make test-integration 		- Executa testes de integração"
	@echo "  make coverage   			- Executa testes e gera relatório de cobertura"
	@echo "  make run        			- Executa o projeto"
	@echo "  make build      			- Compila o projeto para Android (APK)"
	@echo "  make analyze    			- Analisa o código do projeto"
	@echo "  make clean      			- Limpa arquivos temporários e de build"
	@echo "  make mock       			- Cria os mocks de testes"
	@echo "  make help       			- Mostra esta ajuda"
