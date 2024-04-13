#!/bin/bash

# current date in the format DDMMYY
current_date_step4=$(date +"%d%m%y")

# current date in the format YYYY_MM_DD
current_date_steps12=$(date +"%Y_%m_%d")

# Function to process LP directory
process_LP() {
    cd /opt/volume/dataupload/catalog/LP

    # Constructed the filename pattern with the current date
    filename="LP_FULL_OOS_retail_delta_inventory_${current_date_steps12}*"  # Use curly braces for variable expansion

    # Find and process the latest file matching the filename pattern
    latest_file=$(ls -1t "$filename" | head -n1)
    
    if [ -n "$latest_file" ]; then
        ls -lrt "$latest_file"
        zcat "$latest_file" | awk -F '"' '{print $4}' > /opt/volume/scripts/envioAutomaticoDelta/archivos/lp.txt

         # Give all permissions to lp.txt
        chmod 777 /opt/volume/scripts/envioAutomaticoDelta/archivos/lp.txt

        # Validate LP file contents
        tail -3 /opt/volume/scripts/envioAutomaticoDelta/archivos/lp.txt

        # Run the corresponding script for LP
        ./envioLp.sh /opt/volume/scripts/envioAutomaticoDelta/archivos/lp.txt "enviolp${current_date_step4}"
    else
        echo "No matching file found for today's date in LP directory."
    fi
}

# Function to process SB directory
process_SB() {
    cd /opt/volume/dataupload/catalog/SB

    # Construct the filename pattern with the current date
    filename="SB_FULL_OOS_retail_delta_inventory_${current_date_steps12}*"  # Use curly braces for variable expansion

    # Find and process the latest file matching the filename pattern
    latest_file=$(ls -1t "$filename" | head -n1)
    
    if [ -n "$latest_file" ]; then
        ls -lrt "$latest_file"
        zcat "$latest_file" | awk -F '"' '{print $4}' > /opt/volume/scripts/envioAutomaticoDelta/archivos/sb.txt

        # Give all permissions to sb.txt
        chmod 777 /opt/volume/scripts/envioAutomaticoDelta/archivos/sb.txt

        # Validate SB file contents
        tail -3 /opt/volume/scripts/envioAutomaticoDelta/archivos/sb.txt

        # Run the corresponding script for SB
        ./envioSb.sh /opt/volume/scripts/envioAutomaticoDelta/archivos/sb.txt "enviosb${current_date_step4}"
    else
        echo "No matching file found for today's date in SB directory."
    fi
}

# Function to process PB directory
process_PB() {
    cd /opt/volume/dataupload/catalog/PB

    # Construct the filename pattern with the current date
    filename="PB_FULL_OOS_retail_delta_inventory_${current_date_steps12}*"  # Use curly braces for variable expansion

    # Find and process the latest file matching the filename pattern
    latest_file=$(ls -1t "$filename" | head -n1)
    
    if [ -n "$latest_file" ]; then
        ls -lrt "$latest_file"
        zcat "$latest_file" | awk -F '"' '{print $4}' > /opt/volume/scripts/envioAutomaticoDelta/archivos/pb.txt

        # Give all permissions to pb.txt
        chmod 777 /opt/volume/scripts/envioAutomaticoDelta/archivos/pb.txt

        # Validate PB file contents
        tail -3 /opt/volume/scripts/envioAutomaticoDelta/archivos/pb.txt

         # Run the corresponding script for PB
        ./envioPb.sh /opt/volume/scripts/envioAutomaticoDelta/archivos/pb.txt "enviopb${current_date_step4}"
    else
        echo "No matching file found for today's date in PB directory."
    fi
}

# Execute the functions for LP, SB, and PB
process_LP
process_SB
process_PB

# Continue with the rest of the script
# Step 3: Run the editTxt.sh Shell Script
cd /opt/volume/scripts/envioAutomaticoDelta
./editTxt.sh

# Step 4: Send the Delta for OOS
./enviolp${current_date_step4}.sh
./enviosb${current_date_step4}.sh
./enviopb${current_date_step4}.sh

# Step 5: Clean Up Temporary Files
rm -rf /opt/volume/scripts/envioAutomaticoDelta/archivos/*

