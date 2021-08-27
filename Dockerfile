### 依赖Jenkins现有基础镜像二次构建
FROM jenkins/jenkins:latest

USER root

LABEL kvusr=hello1024lc@gmail.com

RUN mkdir -p /opt/google-chrome && apt-get update && apt-get install sudo && sudo apt-get update
### 拷贝chrome 的离线安装包
COPY ./google-chrome-stable_current_amd64.deb /opt/google-chrome
### 拷贝项目运行时以来的包目录
COPY ./packages.txt /packages.txt

WORKDIR /opt/google-chrome

# RUN sudo apt-get install -y libappindicator1 fonts-liberation --fix-missing &&\
#     sudo apt-get -y install dbus-x11 xfonts-base xfonts-100dpi xfonts-75dpi xfonts-cyrillic xfonts-scalable --fix-missing &&\
#     apt-get -y install libxss1 lsb-release xdg-utils --fix-missing
## 前置安装chrome安装会以来的软件
RUN sudo apt-get install -y xdg-utils fonts-liberation libasound2 libgbm1 libnspr4 libnss3 wget
#     sudo apt-get -y install dbus-x11 xfonts-base xfonts-100dpi xfonts-75dpi xfonts-cyrillic xfonts-scalable --fix-missing &&\
#     apt-get -y install libxss1 lsb-release xdg-utils --fix-missing

# RUN add-apt-repository universe &&\
RUN sudo dpkg -i google-chrome-stable_current_amd64.deb &&\
    sudo apt-get install -y -f &&\
    sudo apt-get install -y google-chrome-stable &&\
    # alias chrome=
    sudo apt-get install -y python3 &&\
    sudo apt-get install -y python3-pip

WORKDIR /
### 安装项目整体需要的依赖包
RUN pip3 install -r packages.txt

### 设置chrome alias，开启socket bus
RUN alias chrome=/opt/google/chrome/chrome && sudo /etc/init.d/dbus start

# CMD [alias chrome=/opt/google/chrome/chrome, sudo /etc/init.d/dbus start]