#!/bin/bash
# Railway startup script for ATS application

set -e  # Exit on error

echo "🚀 Starting ATS Application..."
echo "================================"
echo "✓ Python version: $(python3 --version)"
echo "✓ DATABASE_URL: ${DATABASE_URL:0:30}..."
echo "✓ PORT: ${PORT:-8080}"
echo "✓ FLASK_ENV: ${FLASK_ENV:-development}"

# Check critical environment variables
if [ -z "$DATABASE_URL" ]; then
    echo "⚠ WARNING: DATABASE_URL not set, using default SQLite"
fi

if [ -z "$FLASK_SECRET_KEY" ] || [ "$FLASK_SECRET_KEY" = "dev-secret" ]; then
    echo ""
    echo "⚠ WARNING: FLASK_SECRET_KEY not set, using default (INSECURE!)"
fi

# Test app import
echo ""
echo "Testing app import..."
python3 -c "from app import app; print('✓ App import successful')" || {
    echo "❌ App import failed!"
    exit 1
}

# Start application with gunicorn
echo ""
echo "Starting gunicorn..."
echo "================================"

exec gunicorn app:app \
    --bind 0.0.0.0:${PORT:-8080} \
    --workers 4 \
    --timeout 120 \
    --log-level info \
    --access-logfile - \
    --error-logfile -
