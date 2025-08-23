FROM python:3.11-slim

# Set workdir
WORKDIR /app

# Install system deps
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  libsqlite3-dev \
  && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
## Copy only app files (we kept SQL and storage.db out of .dockerignore)
COPY . /app

# Ensure storage.db location exists and a data dir for runtime DB if needed
RUN mkdir -p /app/data /app/Routes && touch /app/storage.db || true
RUN chown -R root:root /app/data /app/storage.db

ENV PYTHONUNBUFFERED=1

# Expose port
EXPOSE 8000

# Start app with uvicorn
CMD ["/usr/local/bin/uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
