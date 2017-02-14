<cfquery name="saveVoter" datasource="GOTV">
	IF NOT EXISTS (SELECT Email FROM Voters WHERE Email = '#url.email#' AND gotv = 'Reg')
		BEGIN
			INSERT INTO [Voters]
			([email]
			,[rsta]
			,[gotv]
			<cfif isDefined("clientId")>,[client_id]</cfif>
			<cfif isDefined("voter.fname")>,[fname]</cfif>
			<cfif isDefined("voter.mname")>,[mname]</cfif>
			<cfif isDefined("voter.lname")>,[lname]</cfif>
			<cfif isDefined("voter.sfx")>,[sfx]</cfif>
			<cfif isDefined("voter.dobyear") AND isNumeric(voter.dobyear)>,[dobyear]</cfif>
			<cfif isDefined("voter.dobmonth") AND isNumeric(voter.dobmonth)>,[dobmonth]</cfif>
			<cfif isDefined("voter.dobday") AND isNumeric(voter.dobday)>,[dobday]</cfif>
			<cfif isDefined("voter.telhomearea")>,[tel_area]</cfif>
			<cfif isDefined("voter.telhomenumber")>,[tel_num]</cfif>
			<cfif isDefined("voter.raddr1")>,[raddr1]</cfif>
			<cfif isDefined("voter.raddr2")>,[raddr2]</cfif>
			<cfif isDefined("voter.rcity")>,[rcity]<cfelseif isDefined("voter.city")>,[rcity]</cfif>
			<cfif isDefined("voter.rzip5")>,[rzip5]</cfif>
			<cfif isDefined("voter.maddr1")>,[maddr1]</cfif>
			<cfif isDefined("voter.maddr2")>,[maddr2]</cfif>
			<cfif isDefined("voter.mcity")>,[mcity]</cfif>
			<cfif isDefined("voter.msta")>,[msta]</cfif>
			<cfif isDefined("voter.mzip5")>,[mzip5]</cfif>
			<cfif isDefined("voter.race")>,[race]</cfif>)
			VALUES
			('#url.email#'
			,'#saveState#'
			,'Reg'
			<cfif isDefined("clientId")>,#clientId#</cfif>
			<cfif isDefined("voter.fname")>,'#voter.fname#'</cfif>
			<cfif isDefined("voter.mname")>,'#voter.mname#'</cfif>
			<cfif isDefined("voter.lname")>,'#voter.lname#'</cfif>
			<cfif isDefined("voter.sfx")>,'#voter.sfx#'</cfif>
			<cfif isDefined("voter.dobyear") AND isNumeric(voter.dobyear)>,#voter.dobyear#</cfif>
			<cfif isDefined("voter.dobmonth") AND isNumeric(voter.dobmonth)>,#voter.dobmonth#</cfif>
			<cfif isDefined("voter.dobday") AND isNumeric(voter.dobday)>,#voter.dobday#</cfif>
			<cfif isDefined("voter.telhomearea")>,'#voter.telhomearea#'</cfif>
			<cfif isDefined("voter.telhomenumber")>,'#voter.telhomenumber#'</cfif>
			<cfif isDefined("voter.raddr1")>,'#voter.raddr1#'</cfif>
			<cfif isDefined("voter.raddr2")>,'#voter.raddr2#'</cfif>
			<cfif isDefined("voter.rcity")>,'#voter.rcity#'<cfelseif isDefined("voter.city")>,'#voter.city#'</cfif>
			<cfif isDefined("voter.rzip5")>,'#voter.rzip5#'</cfif>
			<cfif isDefined("voter.maddr1")>,'#voter.maddr1#'</cfif>
			<cfif isDefined("voter.maddr2")>,'#voter.maddr2#'</cfif>
			<cfif isDefined("voter.mcity")>,'#voter.mcity#'</cfif>
			<cfif isDefined("voter.msta")>,'#voter.msta#'</cfif>
			<cfif isDefined("voter.mzip5")>,'#voter.mzip5#'</cfif>
			<cfif isDefined("voter.race")>,'#voter.race#'</cfif>)
		END
</cfquery>