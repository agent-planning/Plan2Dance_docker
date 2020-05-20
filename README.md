# Plan2Dance in Docker
![image](https://github.com/Dongbox/Plan2Dance_docker/blob/master/GUI/Plan2Dance/logo.png)

## How to install locally Plan2Dance?
Docker gives you an early way.

We use `Django` to generate a web service to solve the choreograph's request for MINI. So you can post your music to a Django in docker that it will run your request.

### 1.Install `docker`, `docker-compose` and `python3.6.7+` in your computer

```
Docker: https://www.docker.com/
Docker-compose: https://docs.docker.com/compose/install/
```

### 2.Download our projects.
```
git clone https://github.com/Dongbox/Plan2Dance_docker.git
```
### 3.Deploy
```
cd Plan2Dance_docker
docker-compose pull
docker-compose build
docker-compose up -d
```
It needs some time and wait for it over.
### 4.Check
```
docker logs p2d_backend
```
If not the error in the output, that\`s ok, else use `docker restart p2d_backend` to restart the container.
If migrations don't initial in MySQL database,
```
docker exec -it p2d_backend bash
python3 manage.py migrate  
```
that will migrate the projects\` models to database.

### 5.Run 
```
cd GUI/Plan2Dance
pip3 install -r requirements.txt
python3 win_main.py
```

## How to Run online Plan2Dance?


### 1.Install python3.6.7+ and Download the GUI program.
```
git clone https://github.com/Dongbox/Plan2Dance_docker.git
```
If you are using windows, you can download the .exe program in 
"https://github.com/Dongbox/Plan2Dance_docker/releases/download/0.0.1/Plan2Dance-qt-win-online.0.0.1.zip"

### 2.Run 
```
cd GUI/Plan2Dance
pip3 install -r requirements.txt
python3 win_main.py
```

> More infomation in https://github.com/Dongbox/Plan2Dance_docker/wiki
