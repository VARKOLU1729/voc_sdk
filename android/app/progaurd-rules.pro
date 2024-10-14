#-dontwarn com.google.firebase.messaging.**
#-dontwarn org.joda.convert.**
#-dontwarn org.joda.time.**
#-keep class org.joda.time.** { *; }
#-keep interface org.joda.time.** { *; }
#-dontwarn org.webrtc.**
#-keep class org.webrtc.** { *; }
#-keepnames class com.amazonaws.** { *; }
#-dontwarn com.amazonaws.**
#-keep public class org.slf4j.** { *; }
#-keep public class ch.** { *; }
#
#


-dontwarn com.google.firebase.messaging.**
-dontwarn org.joda.convert.**
-dontwarn org.joda.time.**
-keep class org.joda.time.** { *; }
-keep interface org.joda.time.** { *;}
-dontwarn org.webrtc.**
-keep class org.webrtc.** { *; }
-keepnames class com.amazonaws.** { *; }
-dontwarn com.amazonaws.**
-keep public class org.slf4j.** { *; }
-keep public class ch.** { *; }
-dontwarn java.awt.**
-dontwarn java.beans.Beans
-dontwarn javax.security.**
-keep class javamail.** {*;}
-keep class javax.mail.** {*;}
-keep class javax.activation.** {*;}
-keep class com.sun.mail.dsn.** {*;}
-keep class com.sun.mail.handlers.** {*;}
-keep class com.sun.mail.smtp.** {*;}
-keep class com.sun.mail.util.** {*;}
-keep class mailcap.** {*;}
-keep class mimetypes.** {*;}
-keep class myjava.awt.datatransfer.** {*;}
-keep class org.apache.harmony.awt.** {*;}
-keep class org.apache.harmony.misc.** {*;}