export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/j2ee.jar
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/appserv-rt.jar
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/javaee.jar
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/j2ee-svc.jar
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/appserv-ee.jar
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/activation.jar
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/dbschema.jar 
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/appserv-admin.jar 
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/install/applications/jmsra/imqjmx.jar   
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/install/applications/jmsra/imqjmsra.jar

jruby Threadpools


jruby -J-server -J-Djruby.thread.pooling=true myscript.rb



README