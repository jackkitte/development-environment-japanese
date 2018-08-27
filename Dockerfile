FROM ubuntu:latest
LABEL maintainer="tamash"

# パッケージのインストールとアップデート
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install build-essential
RUN apt-get -y install git vim curl wget zsh sudo lsof
RUN apt-get -y install language-pack-ja-base language-pack-ja
RUN apt-get -y install mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8
RUN apt-get -y install zlib1g-dev \
libssl-dev \
libreadline-dev \
libyaml-dev \
libxml2-dev \
libxslt-dev \
libncurses5-dev \
libncursesw5-dev 

# 日本語化
RUN update-locale LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV LC_CTYPE ja_JP.UTF-8

# ユーザーの追加
RUN useradd -m -d /home/tamash -s /bin/zsh -G sudo tamash
RUN echo 'root:root' | chpasswd
RUN echo 'tamash:tamash' | chpasswd
RUN echo 'tamash ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
ENV HOME /home/tamash
ADD --chown=tamash:tamash .zshrc /home/tamash
USER tamash
WORKDIR /home/tamash
ADD --chown=tamash:tamash .vimrc /home/tamash
ADD --chown=tamash:tamash .vim /home/tamash/.vim
RUN curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
RUN sh ./installer.sh ~/.cache/dein
RUN rm installer.sh

RUN mkdir /home/tamash/work
WORKDIR /home/tamash/work
ENTRYPOINT [ "/bin/zsh" ]