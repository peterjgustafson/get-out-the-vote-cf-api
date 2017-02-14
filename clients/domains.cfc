<cfcomponent rest="true"
             restpath="/Domains">
  
  <cffunction name="getDomainsHandler"
              access="remote"
              httpmethod="GET"
              restpath="{clientId}"
              returntype="String" 
              produces="text/plain">
    
    <cfargument name="clientId"
                required="true"
                restargsource="Path"
                type="numeric"/>
    
    <cfset var domains = structNew() />
    <cftry>			
      <cfquery name="getDomains" datasource="GOTV">
        SELECT DomainName FROM Clients_DomainNames WHERE ClientId = #arguments.clientId#;
      </cfquery>
      <cfset var domainsArray = [] />

      <cfset var i = 0 />
      <cfoutput query="getDomains">
        <cfset i = i + 1 />
        <cfset domainsArray[i]["DomainName"] = "#DomainName#" />
      </cfoutput>

      <cfset domains.domains = domainsArray />


      <cfcatch type="any">
        <cfset domains.errorMsg = cfcatch.Detail />
      </cfcatch>
    </cftry>			

    <cfset var data = serializeJSON(domains) />	

    <cfif structKeyExists(url, "callback")>
      <cfset data = url.callback & "(" & data & ")" />
    </cfif>
        
    <cfreturn data />
  </cffunction>
  
  <cffunction name="postHandlerJSON"
              access="remote"
              httpmethod="POST"
              returntype="String"
              restpath="{clientId}"
              produces="text/plain">
    
    <cfargument name="clientId"
                required="true"
                restargsource="Path"
                type="numeric" />
    <cfset var clients = structNew() />
    <cftry>
      <cfquery name="createClient" datasource="GOTV">
        INSERT INTO [GOTV].[dbo].[Clients_DomainNames] ([ClientId], [DomainName])
        VALUES ('#arguments.clientId#', '#form.DomainName#')
      </cfquery>
      <cfset clients.success=true />
      <cfcatch type="any">
        <cfset clients.errorMsg = cfcatch.Detail />
      </cfcatch>
    </cftry>
    <cfset var data = serializeJSON(clients) />	
    <cfif structKeyExists(url, "callback")>
      <cfset data = url.callback & "(" & data & ")" />
    </cfif>
    <cfreturn data />
  </cffunction>
  
  <cffunction name="delHandler"
              access="remote"
              httpmethod="DELETE"
              returntype="String"
              restpath="{clientId}/{domainName}"
              produces="text/plain">
    <cfargument name="clientId"
                required="true"
                restargsource="Path"
                type="numeric" />
    <cfargument name="domainName"
                required="true"
                restargsource="Path"
                type="string" />
    
    <cfset var domains = structNew() />
    <cftry>
      <cfquery name="deleteDomain" datasource="GOTV">
        DELETE FROM Clients_DomainNames 
        WHERE ClientId = #arguments.clientId# AND DomainName = #arguments.domainName#
      </cfquery>
      <cfset var message = "record deleted" />
      <cfset domains.message = message />
	
      <cfcatch type="any">
        <cfset domains.errorMsg = cfcatch.Detail />
      </cfcatch>
    </cftry>
    <cfset var data = domains />
    <cfset data = serializeJSON(domains) />
    <cfif structKeyExists(url, "callback")>
      <cfset data = url.callback & "(" & data & ")">
    </cfif>

    <cfreturn data />
  </cffunction>
</cfcomponent>