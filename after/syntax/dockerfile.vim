syntax clear dockerfileKeyword
syntax match dockerfileKeyword /\v^<(ONBUILD\s+)?<(ADD|ARG|CMD|COPY|ENTRYPOINT|ENV|EXPOSE|FROM|HEALTHCHECK|LABEL|MAINTAINER|RUN|SHELL|STOPSIGNAL|USER|VOLUME|WORKDIR)>/
syntax match dockerfileKeyword /\v<AS>/
