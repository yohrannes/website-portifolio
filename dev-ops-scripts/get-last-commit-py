import requests
import subprocess
import os


username = "yohrannes" # substitua pelo nome de usuário do GitHub
repo_name = "website-portifolio" # substitua pelo nome do repositório

url = f"https://api.github.com/repos/{username}/{repo_name}/commits"
response = requests.get(url)

if response.status_code == 200:
    data = response.json()
    latest_commit_sha = data[0]['sha']
    workdir = "/root/repos-github/website-portifolio"
    os.chdir(workdir)
    actual_commit_sha = os.popen('git rev-parse HEAD').read().strip()
    print(f"{actual_commit_sha}", "-> local website commit")
    print(f"{latest_commit_sha}", "-> latest website commit on github")
else:
    print(f"{response.status_code}")
    
if actual_commit_sha != latest_commit_sha:
    print ("updating website folders....")
    workdir = "/root/rep-github/website-portifolio"
    os.chdir(workdir)
    command = "sudo lsof -t -i tcp:5000 | xargs sudo kill -9;git pull origin main;python3 app.py"
    os.system(command)
else:
    print ("commits up-to-date")
