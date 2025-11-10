# Use a specific lightweight base image
# python:3.11-slim is chosen for smaller image size (~120MB vs ~900MB for full python)
FROM python:3.11-slim

# Set the working directory inside the container
# All subsequent commands will run from this directory
WORKDIR /app

# Copy dependency file first (for Docker layer caching)
# If only code changes, this layer is reused, speeding up builds
COPY requirements.txt .

# Install system dependencies and Python packages
# --no-cache-dir reduces image size by not storing pip cache
# curl is needed for Docker health checks
RUN apt-get update && apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir -r requirements.txt

# Copy all project files
COPY . .

# Create a non-root user for security
RUN useradd -m appuser
USER appuser

# Expose the Flask app port
EXPOSE 5000

# Command to run the Flask app
CMD ["python", "app.py"]
