# ===============================
# Stage 1 - Build dependencies
# ===============================
FROM python:3.11-slim AS builder

WORKDIR /app

# Prevent python from writing pyc files
# Prevents .pyc files
ENV PYTHONDONTWRITEBYTECODE=1  
# Logs appear instantly (important for Kubernetes logs)                 
ENV PYTHONUNBUFFERED=1

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency file
COPY requirements.txt .

# Install dependencies to a separate folder
RUN pip install --upgrade pip && \
    pip install --prefix=/install -r requirements.txt


# ===============================
# Stage 2 - Runtime image
# ===============================
FROM python:3.11-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create non-root user
RUN useradd -m appuser

# Copy dependencies from builder stage
COPY --from=builder /install /usr/local

# Copy application code
COPY . .

# Change ownership
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

# Example command for FastAPI / Flask / Django
CMD ["python", "app.py"]

#other examples

# CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]

# ENTRYPOINT ["uvicorn", "app:app", "--host", "0.0.0.0"]

# CMD ["--port", "8000"]