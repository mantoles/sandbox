<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="16008000">
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Controls" Type="Folder">
			<Item Name="Parse-(X,Y).ctl" Type="VI" URL="../Controls/Parse-(X,Y).ctl"/>
			<Item Name="Scan_Data.ctl" Type="VI" URL="../Controls/Scan_Data.ctl"/>
			<Item Name="Scan_Values.ctl" Type="VI" URL="../Controls/Scan_Values.ctl"/>
			<Item Name="Split_Color.ctl" Type="VI" URL="../Controls/Split_Color.ctl"/>
			<Item Name="TileColor.ctl" Type="VI" URL="../Controls/TileColor.ctl"/>
			<Item Name="Wall Data.ctl" Type="VI" URL="../Controls/Wall Data.ctl"/>
		</Item>
		<Item Name="Image Parsing" Type="Folder">
			<Property Name="NI.SortType" Type="Int">3</Property>
			<Item Name="Functions" Type="Folder">
				<Item Name="Parse-Find_Initial_Corner.vi" Type="VI" URL="../Image Parser/Parse-Find_Initial_Corner.vi"/>
				<Item Name="Parse-Scan_Maze.vi" Type="VI" URL="../Image Parser/Parse-Scan_Maze.vi"/>
				<Item Name="Parse-Wall_Tunneling.vi" Type="VI" URL="../Image Parser/Parse-Wall_Tunneling.vi"/>
				<Item Name="Parse-Add_Scans.vi" Type="VI" URL="../Image Parser/Parse-Add_Scans.vi"/>
				<Item Name="Parse-Build_Tile_Array.vi" Type="VI" URL="../Image Parser/Parse-Build_Tile_Array.vi"/>
			</Item>
			<Item Name="Utilities" Type="Folder">
				<Item Name="Parse-Clean_Grid.vi" Type="VI" URL="../Image Parser/Parse-Clean_Grid.vi"/>
				<Item Name="Import-RGB_to_HSV.vi" Type="VI" URL="../Image Parser/Import-RGB_to_HSV.vi"/>
				<Item Name="Parse-Is_White.vi" Type="VI" URL="../Image Parser/Parse-Is_White.vi"/>
				<Item Name="Parse-Create_New_Line.vi" Type="VI" URL="../Image Parser/Parse-Create_New_Line.vi"/>
				<Item Name="Parse-Most_Common_Tile.vi" Type="VI" URL="../Image Parser/Parse-Most_Common_Tile.vi"/>
				<Item Name="Parse-Filter_Scanned_Indices.vi" Type="VI" URL="../Image Parser/Parse-Filter_Scanned_Indices.vi"/>
			</Item>
			<Item Name="Binary" Type="Folder">
				<Item Name="Wall_Tunneling.vi" Type="VI" URL="../Binary/Wall_Tunneling.vi"/>
				<Item Name="Filter_Indices.vi" Type="VI" URL="../Binary/Filter_Indices.vi"/>
				<Item Name="Thoughts.vi" Type="VI" URL="../Binary/Thoughts.vi"/>
				<Item Name="Clean_Scanned_Indices.vi" Type="VI" URL="../Binary/Clean_Scanned_Indices.vi"/>
				<Item Name="Clean_Barrier.vi" Type="VI" URL="../Binary/Clean_Barrier.vi"/>
				<Item Name="Image_To_Maze_Array.vi" Type="VI" URL="../Binary/Image_To_Maze_Array.vi"/>
				<Item Name="Pather.vi" Type="VI" URL="../Pathfinder/Pather.vi"/>
			</Item>
		</Item>
		<Item Name="Pathfinder" Type="Folder">
			<Item Name="Path-Find_Closest_Tile.vi" Type="VI" URL="../Pathfinder/Path-Find_Closest_Tile.vi"/>
			<Item Name="Path-Find_Start_Finish.vi" Type="VI" URL="../Pathfinder/Path-Find_Start_Finish.vi"/>
			<Item Name="Path-Move.vi" Type="VI" URL="../Pathfinder/Path-Move.vi"/>
			<Item Name="Path-Pick_Next_Tile.vi" Type="VI" URL="../Pathfinder/Path-Pick_Next_Tile.vi"/>
			<Item Name="Path-White_Tiles.vi" Type="VI" URL="../Pathfinder/Path-White_Tiles.vi"/>
		</Item>
		<Item Name="Main-Maze_Solver.vi" Type="VI" URL="../Main-Maze_Solver.vi"/>
		<Item Name="Old-Main.vi" Type="VI" URL="../Binary/Old-Main.vi"/>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="Check Path.vi" Type="VI" URL="/&lt;vilib&gt;/picture/jpeg.llb/Check Path.vi"/>
				<Item Name="Color to RGB.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/colorconv.llb/Color to RGB.vi"/>
				<Item Name="Directory of Top Level VI.vi" Type="VI" URL="/&lt;vilib&gt;/picture/jpeg.llb/Directory of Top Level VI.vi"/>
				<Item Name="Error Cluster From Error Code.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Cluster From Error Code.vi"/>
				<Item Name="imagedata.ctl" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/imagedata.ctl"/>
				<Item Name="Read JPEG File.vi" Type="VI" URL="/&lt;vilib&gt;/picture/jpeg.llb/Read JPEG File.vi"/>
				<Item Name="Unflatten Pixmap.vi" Type="VI" URL="/&lt;vilib&gt;/picture/pixmap.llb/Unflatten Pixmap.vi"/>
			</Item>
		</Item>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
