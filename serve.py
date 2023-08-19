from fastapi import FastAPI, HTTPException
import subprocess

app = FastAPI()

print('''Starting server...

Warning: The http endpoint allows arbitrary code execution\
on the host. This is a proof of concept. 
TODO:
Add authentication.
Only allow specific commands.
on predefined endpoints.
Run the server in a container and/or in an isolated network.
'''

@app.post("/run")
async def run_command(command: str):
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    exit_code = process.wait()

    response_content = {
        "stdout": stdout.decode(),
        "stderr": stderr.decode(),
        "exit_code": exit_code
    }

    if exit_code == 0:
        return response_content
    else:
        raise HTTPException(status_code=500, detail=response_content)

