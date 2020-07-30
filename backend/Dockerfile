FROM ubuntu:18.04
COPY Plan2Dance_backend /opt/p2d_backend/
RUN sed -i s@/archive.ubuntu.com/@/mirrors.ustc.edu.cn/@g /etc/apt/sources.list
RUN apt-get update && apt-get install -y --fix-missing python3 python3-pip mysql-client ffmpeg
RUN apt-get install -y libmysqlclient-dev && chmod +x /opt/p2d_backend/plan2dance/Plan2Dance/run_planner/planner/optic-clp/optic-clp
RUN pip3 install -r /opt/p2d_backend/requirements.txt -i https://mirrors.aliyun.com/pypi/simple/
EXPOSE 8081
WORKDIR /opt/p2d_backend