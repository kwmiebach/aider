print('''Starting server...

Warning: The http endpoint allows arbitrary code execution
on the host. This is a proof of concept. 

TODO:

Add https and authentication.
Only allow specific commands on predefined endpoints.
Run the server in a container and/or in an isolated network.
      
To test, run this command in a terminal:

curl -X POST -H "Content-Type: application/json" -d '{"command":"date"}' http://localhost:8000/run
     
''')

from pprint import pprint as pp
import fastapi

app = fastapi.FastAPI()
@app.get("/ping")
async def ping():
    return {
        "ok": True,
        "msg": "pong"
    }

@app.post("/run")
async def run_command(request: fastapi.Request):
    """
    This post endpoint expects one json parameter `command`,
    which is then executed as  shell command.
    It makes sense to use the `--message` option with aider to
    disable chat mode. Example for the content of `command`
    
    aider -m \"Write a hello world program in python\"

    The advantage is that the rest service does not depend so much on the
    internal aider code structure, 

    A disadvantage is that this is very unsecure, so additional measures like
    https, authentication and maybe restricting or parsing the command
    is absolutely necessary. See laso the TODO above.
    """

    request_json_data = await request.json()
    command = request_json_data.get("command",None)
    if command is None:
        raise fastapi.HTTPException(status_code=400, detail="Command not provided.")

    import subprocess
    posix_sub_process = subprocess.Popen(
        command,
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    stdout, stderr = posix_sub_process.communicate()
    posix_exit_code = posix_sub_process.wait()

    response_content = {
        "stdout": stdout.decode(),
        "stderr": stderr.decode(),
        "posix_exit_code": posix_exit_code
    }

    if posix_exit_code == 0:
        pp(response_content)
        return response_content
    else:
        pp(response_content)
        return response_content
        #raise fastapi.HTTPException(status_code=500, detail=response_content)
