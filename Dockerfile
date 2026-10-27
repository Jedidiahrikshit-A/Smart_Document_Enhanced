
FROM node:22-slim AS frontend-build

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm install --include=optional

COPY frontend/ ./
RUN npm run build

FROM python:3.11-slim

WORKDIR /app

COPY backend/requirements.txt backend/requirements.txt
RUN pip install --no-cache-dir -r backend/requirements.txt

COPY backend/ backend/
COPY --from=frontend-build /app/frontend/dist/ frontend/dist/

ENV PORT=3000
ENV PYTHONUNBUFFERED=1

EXPOSE 3000

CMD ["sh", "-c", "cd /app/backend && python app.py"]

