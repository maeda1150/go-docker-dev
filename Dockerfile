FROM golang:latest
MAINTAINER Michele Bertasi

ADD fs/ /

# install pagkages
RUN apt-get update                                                      && \
    apt-get install -y ncurses-dev libtolua-dev exuberant-ctags         && \
    ln -s /usr/include/lua5.2/ /usr/include/lua                         && \
    ln -s /usr/lib/x86_64-linux-gnu/liblua5.2.so /usr/lib/liblua.so     && \
    cd /tmp                                                             && \
# build and install vim
    git clone https://github.com/vim/vim.git                            && \
    cd vim                                                              && \
    ./configure --with-features=huge --enable-luainterp                    \
        --enable-gui=no --without-x --prefix=/usr                       && \
    make VIMRUNTIMEDIR=/usr/share/vim/vim80                             && \
    make install                                                        && \
# get go tools
    go get golang.org/x/tools/cmd/godoc                                 && \
    go get github.com/nsf/gocode                                        && \
    go get golang.org/x/tools/cmd/goimports                             && \
    go get github.com/rogpeppe/godef                                    && \
    go get golang.org/x/tools/cmd/gorename                              && \
    go get github.com/golang/lint/golint                                && \
    go get github.com/kisielk/errcheck                                  && \
    go get github.com/jstemmer/gotags                                   && \
    go get github.com/tools/godep                                       && \
    go get github.com/derekparker/delve/cmd/dlv                         && \
    go get github.com/zmb3/gogetdoc                                     && \
    go get golang.org/x/tools/cmd/guru                                  && \
    go get github.com/davidrjenni/reftools/cmd/fillstruct               && \
    go get github.com/fatih/motion                                      && \
    go get github.com/josharian/impl                                    && \
    go get github.com/fatih/gomodifytags                                && \
    go get github.com/dominikh/go-tools/cmd/keyify                      && \
    go get github.com/klauspost/asmfmt/cmd/asmfmt                       && \
    go get github.com/alecthomas/gometalinter                           && \
    go get github.com/zmb3/gogetdoc                                     && \
    mv /go/bin/* /usr/local/go/bin                                      && \
# add dev user
    adduser dev --disabled-password --gecos ""                          && \
    echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers     && \
    chown -R dev:dev /home/dev /go                                      && \
# cleanup
    rm -rf /go/src/* /go/pkg                                            && \
    apt-get remove -y ncurses-dev                                       && \
    apt-get autoremove -y                                               && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER dev
ENV HOME /home/dev

# install vim plugins
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    vim +PlugInstall +qall
