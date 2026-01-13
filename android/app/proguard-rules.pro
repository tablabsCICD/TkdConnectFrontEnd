# Keep Flutter classes
-keep class io.flutter.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Razorpay
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# SMS Autofill / Telephony (if used)
-keep class com.google.android.gms.auth.api.phone.** { *; }
-dontwarn com.google.android.gms.auth.api.phone.**

# General rules
-dontwarn okhttp3.**
-dontwarn retrofit2.**

