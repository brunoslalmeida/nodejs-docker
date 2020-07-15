FROM node:12
EXPOSE 8001

COPY bootstrap.sh /etc/bootstrap.sh
CMD [ "bash", "/etc/bootstrap.sh" ] 