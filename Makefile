DOCKER_COMMAND=docker run -it --rm --name priority-sorter -v $(PWD):/usr/src/priority-sorter -v "${HOME}/.m2":/root/.m2 --env-file ./maven.env -w /usr/src/priority-sorter maven:3-jdk-8

MAVEN_ARGS?=-T 4

build: ## build priority sorter plugn
	$(DOCKER_COMMAND) mvn install ${MAVEN_ARGS}

test-coverage: clean ## package priority sorter plugin
	$(DOCKER_COMMAND) mvn -P enable-jacoco -Dmaven.spotbugs.skip=true test verify ${MAVEN_ARGS}

test: clean ## package priority sorter plugin
	$(DOCKER_COMMAND) mvn -Dmaven.spotbugs.skip=true test ${MAVEN_ARGS}

test-only: clean ## package priority sorter plugin
	$(DOCKER_COMMAND) mvn -Djava.util.logging.config.file=./src/test/resources/logging.properties -Dtest=$(TEST_NAME) -Dmaven.spotbugs.skip=true test ${MAVEN_ARGS}

fast-package: clean ## package priority sorter plugin
	$(DOCKER_COMMAND) mvn -P quick-build -Dmaven.spotbugs.skip=true -Dmaven.test.skip=true package ${MAVEN_ARGS}
	cat target/classes/META-INF/annotations/hudson.Extension.txt

package: clean ## package priority sorter plugin
	$(DOCKER_COMMAND) mvn package ${MAVEN_ARGS}
	cat target/classes/META-INF/annotations/hudson.Extension.txt

clean:
	# delete all target foldes except jenkins-for-test reduce test time by 80 seconds
	$(DOCKER_COMMAND) find /usr/src/priority-sorter/target/ -mindepth 1 -maxdepth 1 -type d -not -name 'jenkins-for-test' -exec rm -rfv '{}' \; || true
	$(DOCKER_COMMAND) find /usr/src/priority-sorter/target/ -maxdepth 1 -type f -not -name 'jenkins-for-test' -exec rm -rfv '{}' \; || true

spotbugs: ## package priority sorter plugin
	$(DOCKER_COMMAND) mvn -Dmaven.test.skip=true install spotbugs:check ${MAVEN_ARGS}
	#spotbugs:gui
