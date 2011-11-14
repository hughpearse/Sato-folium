#!/bin/bash
# 
# Developed by Fred Weinhaus 12/3/2007 .......... revised 5/17/10
# 
# USAGE: autotrim [-f fuzzval] [-c coords] [-a angle] [-l left] [-r right ] [-t top ] [-b bottom ] infile outfile
# USAGE: autotrim [-h or -help]
# 
# OPTIONS:
# 
# -f              fuzzval        fuzz value for determining border color;
#                                expressed as (float) percent 0 to 100; 
#                                default=0 (uniform color)
# -c              coords         pixel coordinate to extract color; may be 
#                                expressed as gravity value (NorthWest, etc)
#                                or as "x,y" value; default is NorthWest=(0,0)
# -a              angle          angle of rotation of image; default indicates 
#                                no rotation; angle=0 indicates to autocalculate;
#                                0<=angle<=45 degrees (float)
# -l              left           pixel shift of left edge; +/- is right/left
#                                default=0 (no change) 
# -r              right          pixel shift of right edge; +/- is right/left
#                                default=0 (no change) 
# -t              top            pixel shift of top edge; +/- is down/up
#                                default=0 (no change) 
# -b              bottom         pixel shift of bottom edge; +/- is down/up
#                                default=0 (no change) 
# -h or -help                    get help
# 
###
# 
# NAME: AUTOTRIM 
#  
# PURPOSE: To trim the background border around a normally oriented or rotated image 
# 
# DESCRIPTION: AUTOTRIM automatically trims a (nearly) uniform color border 
# around an image. If the image is rotated, one can trim to the bounding box 
# around the image area or alternately trim to the maximum central area that 
# contains no border pixels. The excess border does not have to completely 
# surround the image. It may be only on one side. However, one must identify 
# a coordinate within the border area for the algorithm to extract the base 
# border color and also specify a fuzz value when the border color is not 
# uniform. For simple border trimming of a normally oriented image or the 
# bounding box of a rotated image, you may err somewhat towards larger than 
# optimal fuzz values. For images that contain rotated picture data, when you 
# want to trim to the central area, you should choose the smallest fuzz value 
# that is appropriate. For images that contain rotated picture data, an 
# estimate of the rotation angle is needed for the algorithm to work. However, 
# setting the rotation angle to zero will let the algorithm determine the 
# rotation angle. The resulting trim is usually pretty good for angles >= 5 
# degrees. If the result is off a little, you may use the left/right/top/bottom 
# arguments to adjust the automatically determined trim region. 
# 
# 
# Arguments: 
# 
# -h or -help    ---  displays help information. 
# 
# -f fuzzval --- FUZZVAL is the fuzz amount specified as a percent 0 to 100 
# (without the % sign). The default is zero which indicates that border is a 
# uniform color. Larger values are needed when the border is not a uniform color.
# 
# -c coords --- COORDS is any location within the border area for the 
# algorithm to find the base border color. It may be specified in terms of 
# gravity parameters (NorthWest, North, NorthEast, East, SouthEast, South, 
# SouthWest or West) or as a pixel coordinate "x,y". The default is the 
# upper left corner = NorthWest = "0,0".
# 
# -a angle --- ANGLE is the rotation angle of the picture data within the image. 
# The default (no argument) indicates that either the image does not contain 
# rotated data or one simply wants to trim to the bounding box around the 
# rotated data. If the angle is specified as zero, then the algorithm will 
# automatically estimate the rotation angle which is needed when one wants 
# to trim to the maximum central area of the rotated data which contains no 
# border pixels. One may override the automatic determination and specify 
# your own value. Values are positive floats between 0 and 45 degrees. The 
# rotation direction is not important. Note that the algorithm cannot 
# determine other orientations. You will need to do a 90, 180, or 270 degree 
# rotation before or after using this script. 
# 
# -l left --- LEFT is the number of extra pixels to shift the trim of the left 
# edge of the image. The trim is shifted right/left for +/- integer values.
# The default=0.
# 
# -r right --- RIGHT is the number of extra pixels to shift the trim of the right 
# edge of the image. The trim is shifted right/left for +/- integer values.
# The default=0.
# 
# -t top --- TOP is the number of extra pixels to shift the trim of the top 
# edge of the image. The trim is shifted down/up for +/- integer values.
# The default=0.
# 
# -b bottom --- BOTTOM is the number of extra pixels to shift the trim of the 
# bottom edge of the image. The trim is shifted down/up for +/- integer values.
# The default=0.
# 
# CAVEAT: No guarantee that this script will work on all platforms, 
# nor that trapping of inconsistent parameters is complete and 
# foolproof. Use At Your Own Risk. 
# 
######
#
# set default values; 
fuzzval=0				# fuzz threshold
coords="NorthWest"		# coordinates to get color
pad=1					# border pad size
rotang=""				# rotation angle 0-45 or ""; 0 -- calc automatic; "" -- do not use
lt=0					# left edge shift of trim (+/- is right/left)
rt=0					# right edge shift of trim (+/- is right/left)
tp=0					# top edge shift of trim (+/- is down/up)
bm=0					# top bottom shift of trim (+/- is down/up)

# set directory for temporary files
dir="."    # suggestions are dir="." or dir="/tmp"
#
#
# set up functions to report Usage and Usage with Description
PROGNAME=`type $0 | awk '{print $3}'`  # search for executable on path
PROGDIR=`dirname $PROGNAME`            # extract directory of program
PROGNAME=`basename $PROGNAME`          # base name of program
usage1() 
	{
	echo >&2 ""
	echo >&2 "$PROGNAME:" "$@"
	sed >&2 -n '/^###/q;  /^#/!q;  s/^#//;  s/^ //;  4,$p' "$PROGDIR/$PROGNAME"
	}
usage2() 
	{
	echo >&2 ""
	echo >&2 "$PROGNAME:" "$@"
	sed >&2 -n '/^######/q;  /^#/!q;  s/^#*//;  s/^ //;  4,$p' "$PROGDIR/$PROGNAME"
	}
#
# function to report error messages
errMsg()
	{
	echo ""
	echo $1
	echo ""
	usage1
	exit 1
	}
#
# function to test for minus at start of value of second part of option 1 or 2
checkMinus()
	{
	test=`echo "$1" | grep -c '^-.*$'`   # returns 1 if match; 0 otherwise
    [ $test -eq 1 ] && errMsg "$errorMsg"
	}
#
#
# test for correct number of arguments and get values
if [ $# -eq 0 ]
	then
	# help information
	echo ""
	usage2
	exit 0
elif [ $# -eq 3 -o $# -eq 5 -o $# -eq 7 -o $# -eq 9 -o $# -eq 11 -o $# -eq 13 -o $# -eq 15 -o $# -gt 16 ]
	then
	errMsg "--- TOO MANY ARGUMENTS WERE PROVIDED ---"
else
	while [ $# -gt 0 ]
		do
		# get parameters
		case "$1" in
	  -h|-help)    # help information
				   echo ""
				   usage2
				   ;;
			-f)    # fuzzval
				   shift  # to get the next parameter - fuzzval
				   # test if parameter starts with minus sign 
				   errorMsg="--- INVALID FUZZVAL SPECIFICATION ---"
				   checkMinus "$1"
				   fuzzval=`expr "$1" : '\([.0-9]*\)'`
				   [ "$fuzzval" = "" ] && errMsg "--- FUZZVAL=$fuzzval MUST BE A NON-NEGATIVE FLOATING POINT VALUE (with no sign) ---"
				   fuzzvaltest=`echo "$fuzzval < 0" | bc`
				   [ $fuzzvaltest -eq 1 ] && errMsg "--- FUZZVAL=$fuzzval MUST BE A NON-NEGATIVE FLOATING POINT VALUE ---"
				   ;;
			-c)    # coords
				   shift  # to get the next parameter - coords
				   # test if parameter starts with minus sign 
				   errorMsg="--- INVALID COORDS SPECIFICATION ---"
				   checkMinus "$1"
				   coords=$1
				   # further testing done later
				   ;;
			-a)    # angle
				   shift  # to get the next parameter - angle
				   # test if parameter starts with minus sign 
				   errorMsg="--- INVALID ANGLE SPECIFICATION ---"
				   checkMinus "$1"
				   rotang=`expr "$1" : '\([.0-9]*\)'`
				   [ "$rotang" = "" ] && errMsg "--- ANGLE=$rotang MUST BE A NON-NEGATIVE FLOATING POINT VALUE (with no sign) ---"
				   rotangtestA=`echo "$rotang < 0" | bc`
				   rotangtestB=`echo "$rotang > 45" | bc`
				   [ $rotangtestA -eq 1 -a $rotangtestB -eq 1 ] && errMsg "--- ANGLE=$rotang MUST BE A NON-NEGATIVE FLOATING POINT VALUE LESS THAN OR EQUAL TO 45 ---"
				   ;;
			-l)    # left
				   shift  # to get the next parameter - left
				   lt=`expr "$1" : '\([0-9\-]*\)'`
				   [ "$lt" = "" ] && errMsg "--- LEFT=$lt MUST BE AN INTEGER VALUE (with no sign or minus sign) ---"
				   ;;
			-r)    # right
				   shift  # to get the next parameter - right
				   rt=`expr "$1" : '\([0-9\-]*\)'`
				   [ "$rt" = "" ] && errMsg "--- RIGHT=$rt MUST BE AN INTEGER VALUE (with no sign or minus sign) ---"
				   ;;
			-t)    # top
				   shift  # to get the next parameter - top
				   tp=`expr "$1" : '\([0-9\-]*\)'`
				   [ "$tp" = "" ] && errMsg "--- TOP=$tp MUST BE AN INTEGER VALUE (with no sign or minus sign) ---"
				   ;;
			-b)    # bottom
				   shift  # to get the next parameter - bottom
				   bm=`expr "$1" : '\([0-9\-]*\)'`
				   [ "$bm" = "" ] && errMsg "--- BOTTOM=$bm MUST BE AN INTEGER VALUE (with no sign or minus sign) ---"
				   ;;
			 -)    # STDIN and end of arguments
				   break
				   ;;
			-*)    # any other - argument
				   errMsg "--- UNKNOWN OPTION ---"
				   ;;
			*)     # end of arguments
				   break
				   ;;
		esac
		shift   # next option
	done
	#
	# get infile and outfile
	infile=$1
	outfile=$2
fi


# test that infile provided
[ "$infile" = "" ] && errMsg "NO INPUT FILE SPECIFIED"

# test that outfile provided
[ "$outfile" = "" ] && errMsg "NO OUTPUT FILE SPECIFIED"


# setup temporary images and auto delete upon exit
# use mpc/cache to hold input image temporarily in memory
tmpA="$dir/autotrim_$$.mpc"
tmpB="$dir/autotrim_$$.cache"
tmp00="$dir/autotrim_00_$$.png"
tmp0="$dir/autotrim_0_$$.png"
tmp1="$dir/autotrim_1_$$.png"
tmp2="$dir/autotrim_2_$$.png"
tmp3="$dir/autotrim_3_$$.png"
trap "rm -f $tmpA $tmpB $tmp00 $tmp0 $tmp1 $tmp2 $tmp3; exit 0" 0
trap "rm -f $tmpA $tmpB $tmp00 $tmp0 $tmp1 $tmp2 $tmp3; exit 1" 1 2 3 15


if convert -quiet -regard-warnings "$infile" +repage "$tmpA"
	then
	: ' do nothing '
else
	errMsg "--- FILE $infile DOES NOT EXIST OR IS NOT AN ORDINARY FILE, NOT READABLE OR HAS ZERO SIZE ---"
fi

# function to get dimensions
dimensions()
	{
	width=`identify -format %w $1`
	height=`identify -format %h $1`
	widthm1=`expr $width - 1`
	heightm1=`expr $height - 1`
	midwidth=`echo "scale=0; $width / 2" | bc`
	midheight=`echo "scale=0; $height / 2" | bc`
	widthmp=`expr $width - 2 \* $pad`
	heightmp=`expr $height - 2 \* $pad`
	}

# function to get color at user specified location
getColor()
	{
	dimensions $tmpA
	case "$coords" in
		NorthWest|Northwest|northwest)	coords="0,0"
										;;
						  North|north)	coords="$midwidth,0"
										;;
		NorthEast|Northeast|northeast)	coords="$widthm1,0"
										;;
							East|east)	coords="$widthm1,$midheight"
										;;
		SouthEast|Southeast|southeast)	coords="$widthm1,$heightm1"
										;;
						  South|south)	coords="$midwidth,$heightm1"
										;;
		SouthWest|Southwest|southwest)	coords="0,$heightm1"
										;;
							West|west)	coords="0,$midheight"
										;;
						[0-9]*,[0-9]*)	coords=$coords
										;;
									*)	errMsg "--- INVALID COORDS ---"
										;;
	esac
	color=`convert $tmpA -format "%[pixel:u.p{$coords}]" info:`
	}
	
# function to pad and extract binary image
paddedBinary()
	{
	# reset coords to 0,0
	coords="0,0"

	# pad image with border of color found at original coords
	convert $tmpA -bordercolor $color -border ${pad}x${pad} $tmpA
	
	# get dimensions of padded image
	dimensions $tmpA
	
	# make exterior transparent and inside white
	convert $tmpA -fuzz $fuzzval% -fill none \
		-draw "matte $coords floodfill" -fill white +opaque none $tmp0
	
	# make exterior black and inside white	
	convert \( -size ${width}x${height} xc:black \) $tmp0 -composite $tmp1
	}

# function to get black to white transition location along row or column
# specify arguments 1D image of data, dimension=width,height,widthm1 or heightm1, and direction=inc or dec
getTransition()
	{
	img1D=$1
	dim=$2
	dir=$3
	rowcol=`convert $img1D -compress None -depth 8 txt:-`
	vals=`echo "$rowcol" | sed -n 's/^[0-9]*,[0-9]*: [(].*[)]  #...... \(.*\)$/\1/p'`
	vals_Array=($vals)
	if [ "$dir" = "inc" ]
		then
		i=0
		while [ $i -lt $dim ]
			do
			[ "${vals_Array[$i]}" = "white" ] && break
			i=`expr $i + 1`
		done
		location=$i
	elif [ "$dir" = "dec" ]
		then
		i=$dim
		while [ $i -ge 0 ]
			do
			[ "${vals_Array[$i]}" = "white" ] && break
			i=`expr $i - 1`
		done
		location=$i
	fi
	}
	
# function to process binary to get cropped image
cropImage()
	{
	trim=$1
	angle=$2
	if [ "$angle" = "" ]
		then
		thresh=1
		normalize=""
	elif [ `echo "($angle >= 0) && ($angle <= 45)" | bc` -eq 1 ]
		then
		# threshold relation to angle determined empirically and seems to be reasonably good, 
		# but not perfect probably due to quantization of boundary in binarized image
		if [ `echo "$angle <= 5" | bc` -eq 1 ]
			then
			thresh=`echo "scale=1; (99 - (1.0 * $angle)) / 1" | bc`
		else
			thresh=`echo "scale=1; (99 - (1.07 * $angle)) / 1" | bc`
		fi
		thresh=$thresh%
		normalize="-normalize"
	else
		errMsg "--- INVALID ANGLE VALUE ---"
	fi

	# average to one row and one column
	convert $tmp1 -filter box -resize 1x${height}! $normalize -threshold $thresh $tmp2
	convert $tmp1 -filter box -resize ${width}x1! $normalize -threshold $thresh $tmp3
	
	# get top and bottom by locating first occurence of value=white from top and bottom of column
	getTransition $tmp2 $height "inc"
	top=$location

	getTransition $tmp2 $heightm1 "dec"
	bottom=$location
		
	# get left and right by locating first occurence of value=white from left and right of row
	getTransition $tmp3 $width "inc"
	left=$location
	
	getTransition $tmp3 $widthm1 "dec"
	right=$location
		
	#compute start x and y and width and height
	if [ "$trim" = "" ]
		then
		new_x=$left
		new_y=$top
		new_width=`expr $right - $left + 1`
		new_height=`expr $bottom - $top + 1`
	else
		new_x=`expr $left + $lt`
		new_y=`expr $top + $tp`
		new_width=`expr $right - $left - $lt + $rt + 1`
		new_height=`expr $bottom - $top - $tp + $bm + 1`
	fi

	#crop image
	convert $tmpA[${new_width}x${new_height}+${new_x}+${new_y}] +repage $tmpA
	}

# function to compute rotation angle
computeRotation()
	{
	# start with image already cropped to outside bounds of rotated image
	
	# get new dimension
	dimensions $tmpA
	
	# get padded bindary image
	paddedBinary
		
	# trim off pad (repage to clear page offsets)
	convert $tmp1[${widthmp}x${heightmp}+1+1] +repage $tmp1

	# get rotation angle
	# get coord of 1st white pixel in left column
	getTransition $tmp1[1x${height}+0+0] $height "inc"
	p1x=1
	p1y=$location
	
	# get coord of 1st white pixel in top row
	getTransition $tmp1[${width}x1+0+0] $width "inc"
	p2x=$location
	p2y=1
	
	# compute slope and angle (reverse sign of dely as y increases downward)
	delx=`expr $p2x - $p1x`
	dely=`expr $p1y - $p2y`
	if [ $delx -eq 0 ]
		then
		rotang=2
	else
		pi=`echo "scale=10; 4*a(1)" | bc -l`
		angle=`echo "scale=5; (180/$pi) * a($dely / $delx)" | bc -l`
		if [ `echo "$angle > 45" | bc` -eq 1 ]
			then
			rotang=`echo "scale=2; (90 - $angle) / 1" | bc`
		else
			rotang=`echo "scale=2; $angle / 1" | bc`
		fi
	fi
	echo ""
	echo "Rotation Angle=$rotang"
	echo ""
	}


# start processing 

# get color at user specified location
getColor

if [ "$rotang" = "" ]
	# do processing to get simple bounding box
	then
	# crop out any border to get bounding box
	paddedBinary  $fuzzval
	# process to trim (no rotation)
	cropImage "trim" ""

else
	# alternately do processing to get inscribed, non-padded image area of rotated image
	# crop out any border to get bounding box
	paddedBinary  $fuzzval
	cropImage "" ""
	# get rotation angle if appropriate
	if [ `echo "$rotang == 0" | bc` -eq 1 ]
		then
		computeRotation
	fi
	# process to trim according to rotation angle
	paddedBinary
	cropImage "" $rotang

	# repeat second time (needed for non-square "true/unrotated" image area)
	# seredipidously found that it seemed to work
	# process to trim according to rotation angle
	paddedBinary
	cropImage "trim" $rotang
fi
convert $tmpA $outfile
