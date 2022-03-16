FROM maven:3.5-jdk-8 as BUILD1
 
COPY ./user-storage-telekom/src /usr/src/app/src
COPY ./user-storage-telekom/pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean package

FROM registry.redhat.io/rh-sso-7/sso75-openshift-rhel8:latest

COPY ./extensions/ojdbc8.jar /opt/eap/extensions/
COPY ./extensions/postconfigure.sh /opt/eap/extensions/
COPY ./extensions/actions.cli /opt/eap/extensions/
COPY --from=BUILD1 /usr/src/app/target/keycloak-user-storage-telekom-7.4.0.GA.jar /opt/eap/standalone/deployments/
USER root
RUN chmod 774 /opt/eap/extensions/*.sh
USER jboss
CMD ["/opt/eap/bin/openshift-launch.sh"]
#CMD ["/bin/bash"]

