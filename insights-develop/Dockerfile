# syntax=docker/dockerfile:1

FROM frappe/bench:latest

USER root

COPY --chown=frappe:frappe docker/init.sh /workspace/init.sh
RUN chmod 0755 /workspace/init.sh

USER frappe
WORKDIR /home/frappe

ENTRYPOINT ["/workspace/init.sh"]
