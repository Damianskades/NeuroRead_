[app]

# (str) Title of your application
title = NeuroRead

# (str) Package name
package.name = neuroread

# (str) Package domain (needed for android/ios packaging)
package.domain = org.damianskades

# (str) Source code where the main.py live
source.dir = .

# (list) Source files to include (let empty to include all the files)
source.include_exts = py,png,jpg,txt,ttf,kv

# (list) List of inclusions using pattern matching
source.include_patterns = assets/*,data/libros/*

# (list) List of directory to exclude (let empty to not exclude anything)
source.exclude_dirs = .venv,venv,backups,bin,.buildozer,.git,.vscode,.claude,__pycache__

# (str) Application versioning (method 1)
version = 0.1

# (list) Application requirements
requirements = python3,kivy==2.3.1

# (str) Icon of the application
#icon.filename = %(source.dir)s/assets/icono.png

# (str) Presplash of the application
#presplash.filename = %(source.dir)s/assets/presplash.png

# (list) Supported orientations
orientation = portrait

# (bool) Indicate if the application should be fullscreen or not
fullscreen = 0

# (list) Permissions
#android.permissions =

# (int) Target Android API, should be as high as possible.
android.api = 34

# (int) Minimum API your APK / AAB will support.
android.minapi = 24

# (list) The Android archs to build for
android.archs = arm64-v8a, armeabi-v7a

# (bool) enables Android auto backup feature (Android API >=23)
android.allow_backup = True


[buildozer]

# (int) Log level (0 = error only, 1 = info, 2 = debug (with command output))
log_level = 2

# (int) Display warning if buildozer is run as root (0 = False, 1 = True)
warn_on_root = 1
