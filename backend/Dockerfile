FROM ubuntu:18.04
COPY Plan2Dance_backend /opt/p2d_backend/
RUN apt-get update && apt-get install -y --fix-missing python3 python3-pip mysql-client ffmpeg
RUN apt-get install -y libmysqlclient-dev
RUN pip3 install -r /opt/p2d_backend/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
EXPOSE 8081
WORKDIR /opt/p2d_backend