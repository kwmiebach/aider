#/bin/bash
# To run the FastAPI app:
python_file=serve
uvicorn $python_file:app --host 0.0.0.0 --port 8000 --reload

