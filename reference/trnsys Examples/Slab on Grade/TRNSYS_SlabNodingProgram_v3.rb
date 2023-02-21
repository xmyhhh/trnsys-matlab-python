#Thermal Energy System Specialists (TESS), Madison, WI.  All rights reserved.  

#This program is not to be copied, re-distributed, or re-engineered without the express written consent of 
#Thermal Energy System Specialists.  Use of this program requires a license to the TRNSYS 17 software package.

#This program, written for TRNSYS v17, "nodes" the horizontal surfaces of a building that are located 
#on the z=0 plane.  Small nodes are located near an edge and grow outward as they move away from the 
#edge.  The data files created by this program are used to model the heat transfer from multi-zone
#buildings to the ground using component models in TRNSYS that were written by TESS

#Version 3: JWT - Fixed a bug where the first DZ term was being set to zero for slabs without a footer.

#-------------------------------------------------------------------------
class RectangleMidPoint
	#require 'sketchup.rb'
	def initialize(x,y,z,bottomX,topX,bottomY,topY)
		@x = x
		@y = y
		@z = z
		@bottomX = bottomX
		@topX = topX
		@bottomY = bottomY
		@topY = topY
	end
end
#-------------------------------------------------------------------------
class FaceData #used to order faces by their position in the model
	#require 'sketchup.rb'
	#attr_reader :face, :lowX, :lowY 
	def initialize(face,lowX,lowY)
		@face = face
		@lowX = lowX
		@lowY = lowY
	end
	def face  
		@face  
	end
	def lowX  
		@lowX  
	end	
	def lowY  
		@lowY  
	end	
end
#-------------------------------------------------------------------------


require 'sketchup.rb'

def printZoneArea(face,zone,otherPoint,printZone)
	
	model = Sketchup.active_model
	entities = model.entities

	p = model.path
	model_filename = p.split("\\")
	model_filename = model_filename[model_filename.length-1].split(".")[0]
        filename = model_filename + "_Zone Areas.txt"
        output = File.new( filename.to_s, "a" )
	
	#get area
	area = format( "%.1f", face.area/1550.0031 )
	area_2dec = format( "%.2f", face.area/1550.0031 )
	
	#determine center - attempt one
	vertices = face.vertices
	
	#initialize
	point = vertices[0].position
	lowX = highX = point.x
	lowY = highY = point.y
	
	for v in vertices
		point = v.position
		
		if(lowX>point.x)
			lowX = point.x
		end
		if(highX<point.x)
			highX = point.x
		end
		if(lowY>point.y)
			lowY = point.y
		end
		if(highY<point.y)
			highY = point.y
		end
	end
	
	#get center and check to see if it is still on face
	center = Geom::Point3d.new((((lowX+highX)/2)-15).to_f, (((lowY+highY)/2)+15).to_f, 0.0)#the addition/subtraction of 15 inches is to compensate for the text
	if(face.classify_point(center)==1)
		if(printZone==6)#printZone==6 means the user clicked 'yes' when asked if they wanted to print the zone to the screen
			entities.add_text("Zone "+zone.to_s+"\n"+area.to_s+"m2", center) # print zone and area in center of face
		end
		output.print("Zone "+zone.to_s+": "+area_2dec.to_s+"m2")
		output.puts() #print newline
	#otherwise use other point
	else
		if(printZone==6)
			entities.add_text("Zone "+zone.to_s+"\n"+area.to_s+"m2", otherPoint) # print zone and area on other portion of face
		end
		output.print("Zone "+zone.to_s+": "+area_2dec.to_s+"m2")
		output.puts() #print newline
	end
	#print output
	
	output.close
	
end

#-------------------------------------------------------------------------

### Checks to see if all vectors in this model are orthogonal ###

def checkOrthogonal
    model = Sketchup.active_model
    flag = 0
    edges = []
    for ent in model.entities
        if( ent.is_a? Sketchup::Edge )
            edges.push(ent)
        end
    end
    for e in edges
        vector1 = e.line
        startPt = e.start #get starting vertex of line
        endPt = e.end #get ending vertex of line
        
	if (startPt.position.z ==0)&&(endPt.position.z == 0)
		for e1 in edges
			if  (e1.used_by? endPt) || (e1.used_by? startPt) #found a connection on the z-plane
				vector2 = e1.line
				startPt2 = e1.start 
				endPt2 = e1.end
				if (startPt2.position.z ==0)&&(endPt2.position.z == 0)				
					angle = vector1[1].angle_between vector2[1]
					angle = format( "%.4f", angle.to_f() )
					if(angle.to_f != 1.5708&&angle.to_f != 3.1416&&angle.to_f != 0.0000&&e!=e1)
						status = Sketchup.active_model.selection.add(e1)
						status = Sketchup.active_model.selection.add(e)
						flag = 1
					end
				end
			end
		end
	end
	
end

    if(flag==1)
        UI.messagebox "Some of the entities (see selected) in your model do not have orthogonal edges. Please correct and try again."
        exit
    end
end

### Output results to file ###

def TESS_SlabNodingProgram

    checkOrthogonal()
    model = Sketchup.active_model
    entities = model.entities
    p = model.path
    notFlat = false
    model_filename = p.split("\\")
    if(model_filename.length > 0 )

        model_filename = model_filename[model_filename.length-1].split(".")[0]
        filename = model_filename + "_XYDistances.txt"
        output = File.new( filename.to_s, "w" )

        verticesArray = []
        #Create an array of vertices arrays (thus a 2D array) for vertices of faces that are completely on the z plane
	for ent in model.entities
		if( ent.is_a? Sketchup::Face )
			for a in ent.vertices
				if a.position.z!=0
					notFlat = true
					break
				end
			end
			if(!notFlat)
				verticesArray = verticesArray + ent.vertices
			end
			notFlat = false
		end
        end
        xCoor = []
        yCoor = []
        delta_X = []
	delta_Y = []
        i=0
        for v in verticesArray
		point = v.position
		x_str = point.x.to_s
		y_str = point.y.to_s
		if(x_str[x_str.length-1]==34||x_str[x_str.length-1]==39||x_str[x_str.length-2]==109||x_str[x_str.length-2]==99) #measurement is NOT in meters; if condition tests characters '"mc respectively (for feet, inches, millimeters, and centimeters)
			UI.messagebox "Please convert the units of your SketchUp drawing to decimal meters, with at least 4 decimal places.\nThis can be done by going to:\n\n  - Window->Model Info\n  - Format ->Decimal, Meters"
			exit
		end
		#assuming units are correct, check decimal places
		arr = x_str.split('.')   
		decimal = arr[1].chop
		if(decimal.length<4)
			UI.messagebox "Please increase the measurement precision before continuing.\nGo to menu option:\n\n  Window -> Model Info -> Units -> Precision\n\nMake sure meters is accurate to at least 4 decimal places (0.0000)."
			exit
		end

            #get rid of preceeding tilda ~
            if (x_str[0]==126)
                xCoor[i] = x_str[2,x_str.length].chop.to_f
            else
                xCoor[i] = x_str.chop.to_f
            end

            if (y_str[0]==126)
                yCoor[i] = y_str[2,y_str.length].chop.to_f
            else
                yCoor[i] = y_str.chop.to_f
            end
            i+=1
        end
        xUnique = xCoor.uniq
        xCoor = xUnique.sort
        yUnique = yCoor.uniq
        yCoor = yUnique.sort

        # write delta report to output file
	i=0
	xDisplacement = xCoor[0] 
	
        for x in xCoor
            if(i<xCoor.size-1)
                deltaX = xCoor[i+1].to_f-x.to_f
                output.puts("deltaX "+(i+1).to_s+" is: "+deltaX.to_s)
                delta_X[i] = deltaX
            end
            i+=1
        end

        i=0
        output.puts("\n")

        yDisplacement = yCoor[0]
	for y in yCoor
            if(i<yCoor.size-1)
                deltaY = yCoor[i+1].to_f-y.to_f
                output.puts("deltaY "+(i+1).to_s+" is: "+deltaY.to_s)
		delta_Y[i] = deltaY
            end
            i+=1
        end
	
	output.puts() #print newline
	
        #Close the report file
        output.close
	
	printOutput(delta_X,delta_Y,xDisplacement,yDisplacement)
      
   else
        UI.messagebox "Please save the SketchUp file before calling the slab/soil noding program."
   end

end
#-------------------------------------------------------------------------

### Node_SmalltoSmall ###

 def Node_SmalltoSmall(delta,smallNodeSize,multiplier)
	 
    max_nodes = 1000
    outputArray = []
    nodeArray = []
    found = false
    error = false
    left = 0
    nodes = 0
    sum = 0
    count = 0
    index = 0

    for d in delta
	temp = []
	1.upto(max_nodes) do |i|
		temp[i] = smallNodeSize.to_f*multiplier.to_f**(i-1)

		if (sum.to_f+temp[i].to_f)>=(((d.to_f)/2)-0.0005) 
			left = d.to_f/2 - sum.to_f 
			
			if (left.to_f*2)<temp[i].to_f 
				nodes=2*(i-1)+1
				temp[i]=left.to_f*2 
			else
				nodes=2*i 
				temp[i]=left.to_f 
			end
			found = true
			
		elsif i < max_nodes
			sum = sum.to_f + temp[i].to_f #first pass: sum = .2
	
		else
			error = true
		end
		if(found) # fill up temp[] until the sum of the nodes created thus far plus the next node is greater than half of the delta
			break
		end
	end
	
	(
	found = true # 5
		
		if ((nodes % 2) == 0) #continue if even
			1.upto(nodes/2-1) do |i| 
				if(temp[i] > temp[i+1]) 
					found = false
					sum = 0
					n=i
					n.upto(nodes/2) do |n|
						sum = sum.to_f+temp[n].to_f
					end
					n=i
					n.upto(nodes/2) do |n|
						temp[n]=sum.to_f/(nodes/2-i+1)
						
					end #upto
				end #if
			end #upto
		else
			
			1.upto(((nodes+1)/2)-1) do |i| #continue if odd
				if(temp[i].to_f>temp[i+1].to_f)
					
					found=false
					sum=0
					m=0

					n=i 
					n.upto((nodes+1)/2) do |n|
						if(n==(nodes+1)/2)
							sum=sum.to_f+temp[n].to_f 
							m=m+1
						else
							sum=sum.to_f+2*temp[n].to_f 
							m=m+2
						end#if
					end#upto
					n=i
					n.upto((nodes+1)/2) do |n|
						temp[n]=sum.to_f/m.to_f 
					end#upto
				end#if
			end#upto
		end#else
		if(found)
			break
		end
	)while(true)
	
	i=1
	
	size = []
	while(i<=(nodes+1)/2)
		size[i]=temp[i].to_f
		size[1+nodes-i]=temp[i].to_f
		i+=1
	end
	
	
	i=0
	#store size in permanent output array
	for s in size
		if(i!=0)#skip first element because fortran is 1-based but ruby is 0-based
			outputArray[count] = s.to_s
			count+=1
		end
		i+=1
        end
	
	#The nodeArray is the number of nodes in a particular delta
	nodeArray[index] = nodes
	index+=1
        
	# reset for next for loop
	found = false
	sum = 0
	left = 0
	nodes = 0
end#for

outputArray[outputArray.length] = nodeArray #append the nodeArray to the last element in the outputArray
return outputArray

end

def printOutput(delta_X,delta_Y,xDisp,yDisp)
	model = Sketchup.active_model
	entities = model.entities
	p = model.path
	model_filename = p.split("\\")
	model_filename = model_filename[model_filename.length-1].split(".")[0]
        filename = model_filename + "_Soil Noding File.dat"
	x = 0
	y = 0
	gotPoint = false
	beginning = []
	ending = []
	
	#set status bar
	Sketchup::set_status_text("Gathering information, please wait.", SB_PROMPT) 
	
	##Get user input

	UI.messagebox "TESS Soil & Slab Noding Program for TRNSYS 17.  All rights reserved.\n"
	
	UI.messagebox "How far from the edge of the building, in the horizontal direction, is the temperature of the soil assumed to be unaffected by the building (default=10)?\n"
        prompt = ["Please enter the horizontal far field distance (in meters) "]
        results = inputbox(prompt,[],"Horizontal Far Field")
	
        if (results)
            hFF = results[0]
        else
		UI.messagebox "This parameter is required to complete the soil noding program.  The program will now be stopped."
		exit
        end
	
	UI.messagebox "What is the depth of the footer below the bottom of the slab (default=1)? For monolithic slabs (slabs without a footer) enter a value of zero.\n"
        prompt = ["Please enter the footer depth (in meters)  "]
        results = inputbox(prompt,[],"Footer depth")
	
        if (results)
            footer = results[0]
        else
		UI.messagebox "This parameter is required to complete the soil noding program.  The program will now be stopped."
		exit
	  end

      UI.messagebox "How far beneath the bottom of the footer, in the vertical direction, is the soil temperature assumed to be unaffected by the building (default=10)?\n"
        prompt = ["Please enter the vertical far field distance (in meters)  "]
        results = inputbox(prompt,[],"vertical far field")
	
        if (results)
            vFF = results[0]
        else
		UI.messagebox "This parameter is required to complete the soil noding program.  The program will now be stopped."
		exit
        end

      UI.messagebox "What should be the smallest node size used in the soil noding algorithm (default=0.1)?\n"
	  prompt = ["Please enter the size of the smallest node (in meters)  "]
	  results = inputbox(prompt,[],"Smallest node")
	
	  if (results)
		smallNodeSize = results[0]
	  else
		UI.messagebox "This parameter is required. Exiting the program without generating the noding file."
		exit
	  end

      UI.messagebox "At what rate (multiplier) should the nodal sizes grow as they expand away from an edge (default = 2)?\n"
	  prompt = ["Please enter the multiplier for the node sizes "]
	  results = inputbox(prompt,[],"Node size multiplier")
	
	  if (results)
		multiplier = results[0]
	  else
		UI.messagebox "This parameter is required. Exiting the program without generating the noding file."
		exit
	  end

	
	printZone = UI.messagebox "Would you like the zone number and slab area to be printed on your Sketchup model? ", MB_YESNO
	
	#set beginning and ending far field data (note: beginning is inverted)
	ending = Node_SmalltoLarge(hFF,smallNodeSize,multiplier,0)
	a = ending.length-1
	b = 0
	a.downto(0) do |a|
		beginning[b] = ending[a]
		b+=1
	end
	
	footerArray = [footer]
	
	midX = Node_SmalltoSmall(delta_X,smallNodeSize,multiplier) 
	nodeX = midX.pop #nodalArray was appended to last index of outputArray (returned by SmalltoSmall), so remove last element of midX and place it in nodeX
	midY = Node_SmalltoSmall(delta_Y,smallNodeSize,multiplier)
	nodeY = midY.pop
	
	outX = beginning + midX+ ending
	outY = beginning + midY + ending

	#create file
	output = File.new( filename.to_s, "w" )
	
	begLength = beginning.length
	xLength = outX.length
	yLength = outY.length
	
      for f in footerArray
	  if(f.to_f<=0)
	    z2 = Node_SmalltoLarge((vFF.to_f-footer.to_f),smallNodeSize,multiplier,0)
	    outZ =  z2 

	   #line 1
	   output.print(xLength.to_s+" "+yLength.to_s+" "+outZ.length.to_s+" 0 "+smallNodeSize+" "+multiplier+" "+footer+" "+vFF)
	   output.puts() #print newline
	
	  else
	    z1 = Node_SmalltoSmall(footerArray,smallNodeSize,multiplier)
	    z1.pop
	    z2 = Node_SmalltoLarge((vFF.to_f-footer.to_f),smallNodeSize,multiplier,0)
	    outZ =  z1 + z2 

	   #line 1
	   output.print(xLength.to_s+" "+yLength.to_s+" "+outZ.length.to_s+" "+z1.length.to_s+" "+smallNodeSize+" "+multiplier+" "+footer+" "+vFF)
	   output.puts() #print newline

        end
      end
          
	#line2	
	for o in outX
		
		output.print(o.to_s+" ")
	end
	output.puts() #print newline
	
	#line3	
	for o in outY
		
		output.print(o.to_s+" ")
	end
	output.puts() #print newline
	
	#line4
	for o in outZ
		output.print(o.to_s+" ")
	end
	output.puts() #print newline
	
	#initialize graph of data
	x = 0
	y = 0	
	array = twoDemArray(xLength.to_i,yLength.to_i)
	x.upto(xLength.to_i-1) do |x|
		y.upto(yLength.to_i-1) do |y| 
			array[x][y] = 0 #initialize every value to zero
		end
		y=0
	end
	
	#Create an array of the faces in the model
	faces = []
	i=0 
	notFlat = false
	for ent in entities
		if( ent.is_a? Sketchup::Face )
			for a in ent.vertices
				if a.position.z!=0
					notFlat = true
					break
				end
			end
			if(!notFlat)
				faces[i] = ent
				i+=1
			end
			notFlat = false
		end
	end
	
	#cumDeltaX is an array of the cumulative length from the start of the first X delta to the current delta in meters (note: the length is measured from the start of the first X delta, not the x-axis).
	
	cumDeltaX = []
	cumDeltaY = []
	i = 0
	sum = 0
	for a in delta_X
		cumDeltaX[i] = sum + a
		sum = cumDeltaX[i]
		i+=1
	end
	
	i = 0
	sum = 0
	for b in delta_Y
		cumDeltaY[i] = sum + b
		sum = cumDeltaY[i]
		i+=1
	end
	
	
	#cumNodeX is an array of the the cumulative number of nodes from the start of the first x delta to the start of each delta
	
	sum = begLength #start at the length of the number of nodes from the far field to the start of the first delta
	cumNodeX = []
	cumNodeY = []
	cumNodeX[0] = begLength #note: cumNode will be one longer than delta because the array includes beginning + delta

	1.upto(delta_X.length) do |dx|
		cumNodeX[dx] = sum + nodeX[dx-1]
		sum = cumNodeX[dx]
	end
	
	sum = begLength
	cumNodeY[0] = begLength #note: cumNode will be one longer than delta because the array includes beginning + delta
	1.upto(delta_Y.length) do |dy| 
		cumNodeY[dy] = sum + nodeY[dy-1]
		sum = cumNodeY[dy]
	end
	
		
	#array of vertices of the middle point of every rectangle in the model formed by the intersection of delta lines
	count = 0
	middleVertices = []
	yDisp = yDisp*39.37 # must convert from meters to inches so the classify_point function will work properly
	xDisp = xDisp*39.37
	
	
	0.upto(cumDeltaX.length-1) do |dx|
		if (dx==0)
			midX = (delta_X[0]/2)*39.37
			xNodeStart = cumNodeX[0]
			xNodeEnd = cumNodeX[1]
		else
			midX = (cumDeltaX[dx-1] + delta_X[dx]/2)*39.37 
			xNodeStart = cumNodeX[dx]
			xNodeEnd = cumNodeX[dx+1]
		end
		
		0.upto(cumDeltaY.length-1) do |dy|
			if (dy==0)
				midY = (delta_Y[0]/2)*39.37
				yNodeStart = cumNodeY[0]
				yNodeEnd = cumNodeY[1]
			else
				midY = (cumDeltaY[dy-1] + delta_Y[dy]/2)*39.37
				yNodeStart = cumNodeY[dy]
				yNodeEnd = cumNodeY[dy+1]
			end
			middleVertices[count] = RectangleMidPoint.new((midX+xDisp),(midY+yDisp),0,xNodeStart,xNodeEnd,yNodeStart,yNodeEnd)
			count+=1
		end
	end	
	
	#Order faces
	count = 0
	faceArray=[]
	facesSorted=[]
	for f in faces
		faceVerts = f.vertices
		p = faceVerts[0].position
		lowX = p.x
		lowY = p.y
		for v in faceVerts
			p = v.position
			if(p.x < lowX)
				lowX=p.x
			end
			if(p.y < lowY)
				lowY=p.y
			end
		end
		faceArray[count] = FaceData.new(f,lowX,lowY)
		count+=1
	end
	#UI.messagebox "Before sorting. 1: "+faceArray[0].lowX.to_s+" 2: "+faceArray[1].lowX.to_s+" 3: "+faceArray[2].lowX.to_s+" 4: "+faceArray[3].lowX.to_s+" 5: "+faceArray[4].lowX.to_s
	faceArray = faceArray.sort_by { |a| [a.lowX, a.lowY] } #sort by lowest x first, then lowest y
	#UI.messagebox "After sorting. 1: "+faceArray[0].lowX.to_s+" 2: "+faceArray[1].lowX.to_s+" 3: "+faceArray[2].lowX.to_s+" 4: "+faceArray[3].lowX.to_s+" 5: "+faceArray[4].lowX.to_s
	
	#faceArray.sort_by { |a| a['lowX'] }

	count = 0
	for f in faceArray
		facesSorted[count] = f.face
		count+=1
	end
	
	
	
	zone = 1 #start with zone 1 and face 1, and loop through all of the faces
	for f in facesSorted
		for v in middleVertices
			point = Geom::Point3d.new(v.instance_variable_get(:@x).to_f, v.instance_variable_get(:@y).to_f, 0.0)
			
			if((result=f.classify_point(point))==1) #check to see if point is on this face
				
				if(gotPoint==false) #used for printZoneArea function
					otherPoint = point
					gotPoint = true
				end
				
				startX = v.instance_variable_get(:@bottomX)
				endX = v.instance_variable_get(:@topX)-1 #do not want ends to be inclusive
				startY = v.instance_variable_get(:@bottomY)
				endY = v.instance_variable_get(:@topY)-1 #do not want ends to be inclusive
				startX.upto(endX) do |x| 
					startY.upto(endY) do |y|
						array[x][y] = zone
					end
				end
			end
		end
		
		printZoneArea(f,zone,otherPoint,printZone) #print zones to file possibly to screen as well
		gotPoint = false #reset for next loop
		zone+=1 #change zones for the next face
	end
	
	
	#invert y values so they show up correctly in output
	x = 0
	y = 0
	tempY = []
	x.upto(xLength.to_i-1) do |x|
		y.upto(yLength.to_i-1) do |y|
			tempY[y] = array[x][yLength-1-y]
		end
		array[x] = tempY
		tempY = []
		y=0
	end
		
	x = 0
	y = 0
	#Print graph of numerical data to file
	y.upto(yLength.to_i-1) do |y|
		x.upto(xLength.to_i-1) do |x|
			output.print(array[x][y].to_s+" ")
		end
		x=0
		output.puts() #print newline
	end
	
	output.close
	#set status bar
	Sketchup::set_status_text("Finished.", SB_PROMPT) 
	UI.messagebox "Report successfully saved as " + filename
end#printOutput

#-------------------------------------------------------------------------

def twoDemArray(width,height)
	array = Array.new(width)
	array.map! { Array.new(height) }
	return array
end 
		

#-------------------------------------------------------------------------


def Node_SmalltoLarge(length,smallNode,multiplier,start)
	
	#initialize variables
	max_nodes = 1000
	error = 0
	sum=0
	nodes=0
	found=false
	temp = []
	size = []
	
	#Check the length provided
	if(length.to_f<=0)
		return size
	end
	
	#set the size of the near field
	1.upto(max_nodes) do |i|
		temp[i]=smallNode.to_f*(multiplier.to_f**(i-1))
		#check if boundary is crossed
		if((sum.to_f+temp[i])>=length.to_f)
			temp[i]=length.to_f-sum.to_f
			found=true
		elsif((i+start-1)<max_nodes)
			sum=sum.to_f+temp[i]
		else
			error=1
		end
		
		nodes=i
		if(found)
			break
		end
	end
	#don't leave a small node on the end
	sum=temp[nodes]
	
	i=nodes-1
	i.downto(1) do |i|
		if(temp[i]>temp[nodes])
			sum=sum.to_f+temp[i]
			n=nodes-i+1
			1.upto(n) do |m|
				temp[nodes+1-m]=sum.to_f/n.to_f
			end
		end
	end
	
	#set the nodal sizes
	1.upto(nodes) do |i|
		size[i+start-1]=temp[i]
	end
	return size
end



### Add to SketchUp Plugins Menue ###

#---------------------------------------------------------------------------
unless file_loaded?("TESS_SlabNodingProgram.rb")
    UI.menu("Plugins").add_item("TESS Slab Noding Program") { TESS_SlabNodingProgram() }
end

file_loaded("TESS_SlabNodingProgram.rb")




