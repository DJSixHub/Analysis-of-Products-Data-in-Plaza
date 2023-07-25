#!/bin/bash

# Change directory to the folder containing the Jupyter notebook
# Get the path of the directory containing the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PARENT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PARENT_DIR"

if [ "$1" == "run" ]; then
  # Execute the Jupyter notebook
  jupyter nbconvert --execute Proyecto.ipynb
elif [ "$1" == "report" ]; then
  # Change directory to the folder containing the LaTeX file
  cd "$PARENT_DIR/Informe"

  # Compile the LaTeX file into a PDF
  pdflatex Informe.tex

  elif [ "$1" == "show_slide" ]; then
  # Change directory to the folder containing the LaTeX file
  cd "$PARENT_DIR/Informe"

  # Compile the LaTeX file into a PDF
  pdflatex Informe.tex

  # Open the PDF file with the specified tool, or the default tool if no tool is specified
  if [ $# -eq 2 ] && [ "$2" == "evince" ]; then
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
      evince Informe.pdf
    else
      echo "Error: evince is not available on this platform."
    fi
  else
    case "$OSTYPE" in
      darwin*)
        # macOS
        open -a "Preview" Informe.pdf ;;
      linux-gnu)
        # Linux
        if command -v xdg-open >/dev/null; then
          xdg-open Informe.pdf
        elif command -v gnome-open >/dev/null; then
          gnome-open Informe.pdf
        elif command -v kde-open >/dev/null; then
          kde-open Informe.pdf
        else
          echo "Error: no PDF viewer found on this platform."
        fi
        ;;
      msys*|cygwin*)
        # Windows
        start Informe.pdf ;;
      *)
    esac
  fi

elif [ "$1" == "show_report" ]; then

  cd "$PARENT_DIR/Informe"

  pdflatex Informe.tex

  case "$OSTYPE" in
    darwin*)
      # macOS
      open report.pdf ;;
    linux-gnu)
      # Linux
      xdg-open report.pdf ;;
    msys*|cygwin*)
      # Windows
      start report.pdf ;;
    *)
 esac

elif [ "$1" == "-clean" ]; then
  find "$PARENT_DIR" -name "*.aux" -type f -delete
  find "$PARENT_DIR" -name "*.log" -type f -delete
  find "$PARENT_DIR" -name "*.out" -type f -delete
  find "$PARENT_DIR" -name "*.toc" -type f -delete
  rm "$PARENT_DIR/Informe/Informe.pdf" "$PARENT_DIR/Informe/report.pdf"
fi