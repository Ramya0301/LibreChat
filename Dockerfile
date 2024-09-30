# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy your project files into the container
COPY . .

# Install FastAPI and Uvicorn dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that Uvicorn will run on
EXPOSE 8080

# Command to run FastAPI app using Uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
