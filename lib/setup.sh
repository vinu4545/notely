#!/bin/bash

echo "🚀 Creating Notely Project Structure..."

# ===========================
# Go to Project Root
# ===========================

cd ..

# ===========================
# Assets
# ===========================

mkdir -p assets

touch assets/logo.png
touch assets/logo_dark.png
touch assets/logo_white.png
touch assets/app_icon.png
touch assets/splash_logo.png
touch assets/onboarding_1.png
touch assets/onboarding_2.png
touch assets/onboarding_3.png
touch assets/profile_placeholder.png
touch assets/empty_notes.png
touch assets/empty_search.png
touch assets/empty_archive.png
touch assets/empty_trash.png
touch assets/google_font_license.txt

# ===========================
# Back to lib
# ===========================

cd lib

# ===========================
# APP
# ===========================

mkdir -p app/router
mkdir -p app/theme

touch app/app.dart
touch app/router/app_router.dart
touch app/router/app_routes.dart
touch app/theme/app_colors.dart
touch app/theme/app_theme.dart
touch app/theme/app_text_theme.dart

# ===========================
# CORE
# ===========================

mkdir -p core/constants
mkdir -p core/database
mkdir -p core/services
mkdir -p core/utils
mkdir -p core/animations

touch core/constants/app_constants.dart

touch core/database/database_helper.dart
touch core/database/database_service.dart

touch core/services/navigation_service.dart
touch core/services/snackbar_service.dart

touch core/utils/date_utils.dart
touch core/utils/string_utils.dart
touch core/utils/validators.dart

touch core/animations/fade_animation.dart
touch core/animations/scale_animation.dart
touch core/animations/slide_animation.dart
touch core/animations/page_transition.dart

# ===========================
# SHARED
# ===========================

mkdir -p shared/widgets
mkdir -p shared/components
mkdir -p shared/extensions

touch shared/extensions/context_extensions.dart

touch shared/widgets/gradient_button.dart
touch shared/widgets/glass_card.dart
touch shared/widgets/custom_app_bar.dart
touch shared/widgets/loading_indicator.dart
touch shared/widgets/gradient_background.dart

touch shared/components/custom_dialog.dart
touch shared/components/custom_bottom_sheet.dart
touch shared/components/empty_state.dart

# ===========================
# FEATURES
# ===========================

features=(
"splash"
"onboarding"
"home"
"notes"
"editor"
"search"
"archive"
"trash"
"settings"
"profile"
)

for feature in "${features[@]}"
do

mkdir -p features/$feature/models
mkdir -p features/$feature/providers
mkdir -p features/$feature/repositories
mkdir -p features/$feature/screens
mkdir -p features/$feature/widgets

touch features/$feature/models/.gitkeep
touch features/$feature/providers/.gitkeep
touch features/$feature/repositories/.gitkeep
touch features/$feature/widgets/.gitkeep

done

# ===========================
# SPLASH
# ===========================

touch features/splash/screens/splash_screen.dart

# ===========================
# ONBOARDING
# ===========================

touch features/onboarding/screens/onboarding_screen.dart

# ===========================
# HOME
# ===========================

touch features/home/screens/home_screen.dart

# ===========================
# NOTES
# ===========================

touch features/notes/models/note_model.dart
touch features/notes/providers/note_provider.dart
touch features/notes/repositories/note_repository.dart
touch features/notes/screens/note_list_screen.dart
touch features/notes/widgets/note_card.dart

# ===========================
# EDITOR
# ===========================

touch features/editor/screens/editor_screen.dart

# ===========================
# SEARCH
# ===========================

touch features/search/screens/search_screen.dart

# ===========================
# ARCHIVE
# ===========================

touch features/archive/screens/archive_screen.dart

# ===========================
# TRASH
# ===========================

touch features/trash/screens/trash_screen.dart

# ===========================
# SETTINGS
# ===========================

touch features/settings/screens/settings_screen.dart

# ===========================
# PROFILE
# ===========================

touch features/profile/screens/profile_screen.dart

# ===========================
# ROOT FILES
# ===========================

touch main.dart

echo ""
echo "✅ Notely Project Structure Created Successfully!"
echo ""
echo "📂 Ready for Development 🚀"