# Step 1: Pick a base image (the OS)
FROM python:3.11-slim

# Step 2: Set environment variables
# Prevents Python from writing pyc files and ensures output is sent to logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONBUFFERED=1

WORKDIR /app

# Step 3: Create a non-privileged user
RUN adduser --disabled-password --gecos "" appuser

# Step 4: Install the libraries inside the container
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Copy Python code and change ownership to the new user
COPY src/ ./src/
RUN chown -R appuser /app

# Step 6: Switch to the non-root user
USER appuser

# Step 6: Define the command to start the app
CMD ["python3", "src/app.py"]
