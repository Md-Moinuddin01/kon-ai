.PHONY: dev dev-backend dev-frontend ingest test build up down clean

dev:
	@echo "Starting KON AI full stack locally..."
	@echo "Run 'make dev-backend' and 'make dev-frontend' in separate terminals, or use docker-compose up."

dev-backend:
	uv run uvicorn backend.app.main:app --host 0.0.0.0 --port 8000 --reload

dev-frontend:
	cd frontend && npm run dev

ingest:
	uv run python backend/ingestion/embed_and_index.py

test:
	uv run python -m unittest discover -s backend/tests

build:
	docker-compose build

up:
	docker-compose up -d

down:
	docker-compose down

clean:
	rm -rf __pycache__ .pytest_cache frontend/.next
