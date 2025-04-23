#!/bin/bash
#!/bin/bash
set -e

# Check if Git is installed
if ! command -v git &> /dev/null; then
  echo "Git is not installed. Please install it first."
  exit 1
fi

# Move to /tmp safely
cd /tmp || exit 1

# Remove existing repo if it exists
if [ -d "roboshop-shell" ]; then
  rm -rf roboshop-shell
fi

# Clone the repository
git clone https://github.com/yesdani490/roboshop-shell.git
cd roboshop-shell

# Run mongodb.sh if it exists
if [ -f "mongodb.sh" ]; then
  chmod +x mongodb.sh
  ./mongodb.sh
else
  echo "mongodb.sh not found!"
  exit 1
fi


