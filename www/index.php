<?php

// Path to the index.html file
$file_path = 'index.html';

// Check if the file exists
if (file_exists($file_path)) {
    // Output the content of index.html
    readfile($file_path);
} else {
    echo "Error: File not found.";
}