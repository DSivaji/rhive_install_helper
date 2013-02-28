txtrst=$(tput sgr0) # Text reset
txtred=$(tput setaf 1) # Red - See more at: http://kedar.nitty-witty.com/blog/how-to-echo-colored-text-in-shell-script#sthash.bt4a49xf.dpuf

echo “Welcome to ${txtred} kedar.nitty-witty.com ${txtrst}!”

update_profile "${DATANODES[@]}"
