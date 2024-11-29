#!/bin/bash

report_file="system_report.txt"

current_date_time=$(date '+%Y-%m-%d %H:%M:%S')

current_user=$(whoami)

hostname=$(hostname)

# Get internal IP address
default_interface=$(route -n get default | awk '/interface:/{print $2}')
internal_ip=$(ipconfig getifaddr "$default_interface")

external_ip=$(curl -s ifconfig.me)

# Get name and version of macOS
os_name=$(sw_vers -productName)
os_version=$(sw_vers -productVersion)

# Get system uptime
system_uptime=$(uptime | sed 's/.*up \([^,]*\), .*/\1/')

disk_usage=$(df -h / | awk 'NR==2{printf "Used: %s, Free: %s", $3, $4}')

# Get information about total and free RAM
mem_total=$(sysctl -n hw.memsize)
# Convert total memory to GB
mem_total_gb=$(echo "scale=2; $mem_total/1024/1024/1024" | bc)

# Get free memory pages and calculate free memory in bytes
mem_free_pages=$(vm_stat | grep "Pages free" | awk '{print $3}' | tr -d '.')
mem_inactive_pages=$(vm_stat | grep "Pages inactive" | awk '{print $3}' | tr -d '.')
mem_speculative_pages=$(vm_stat | grep "Pages speculative" | awk '{print $3}' | tr -d '.')

# Page size in bytes
page_size=$(vm_stat | grep "page size of" | awk '{print $8}' | tr -d '.')

if [ -z "$page_size" ]; then
    page_size=4096  # Default page size in bytes
fi

# Calculate total free memory in bytes
mem_free_bytes=$(( (mem_free_pages + mem_inactive_pages + mem_speculative_pages) * page_size ))
# Convert free memory to GB
mem_free_gb=$(echo "scale=2; $mem_free_bytes/1024/1024/1024" | bc)

ram_info="Total: ${mem_total_gb} GB, Free: ${mem_free_gb} GB"

# Get number of CPU cores
cpu_cores=$(sysctl -n hw.ncpu)

# Get CPU frequency in Hz and convert to MHz
cpu_frequency_hz=$(sysctl -n hw.cpufrequency)
cpu_frequency_mhz=$(echo "scale=2; $cpu_frequency_hz/1000000" | bc)
cpu_frequency="${cpu_frequency_mhz} MHz"

# Generate report
cat << EOF > "$report_file"
System Report
=============

Date and Time       : $current_date_time
User                : $current_user

Hostname            : $hostname
Internal IP Address : $internal_ip
External IP Address : $external_ip

OS Name             : $os_name
OS Version          : $os_version

System Uptime       : $system_uptime

Disk Usage (/)      : $disk_usage

RAM Information     : $ram_info

CPU Cores           : $cpu_cores
CPU Frequency       : $cpu_frequency

EOF

echo "Report generated and saved to '$report_file'."

