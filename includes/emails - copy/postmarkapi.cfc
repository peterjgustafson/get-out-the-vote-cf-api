<!---
    Author      :   Chuck Grimes
    Date        :   November 12th 2013
    Description :   This component extends earlier work by Jonathan Lane, and is backward-compatible with his app (https://github.com/wildbit/postmark-coldfusion).
                    Props also to Robert Rawlins for his PostBox component (http://postbox.riaforge.org/).
                    
    Requirements:   A PostMarkApp (http://postmarkapp.com/) Account & API Key.

    PostMarkApp :   PostMarkApp (http://postmarkapp.com/) is a web service based email provider. Rather than sending emails 
                    using standard SMTP protocols, you make a REST request to their API. Each mail is then assigned a message_id,
                    which you can then use with their bounce back API's and webhooks to track mail delivery.
                    
    Install     :   Simply replace references to the standard MailService in your application so they point at the PostMarkAPI
                    plugin rather than the <cfmail> tag. An example file is provided in the zip.
                                     
    Caveats     :   Emails sent through this service are NOT spooled. As such the user will have to wait while each email is sent,
                    for emails which have attachments, this may take some time. A spool routine is needed. Maybe in the next version. 

                    The mime-typing has all the well-known limitations of the ColdFusion/Java platform. Basically, if CF/Java can determine the mime type it handles it. 
                    If not, it defaults to octet-stream.

    V2.0 - multiple file attachments and on-the-fly mime-typing

--->

<cfcomponent name="PostMarkAPI" hint="I send messages using the Postmarkapp.com API">
    <cffunction name="sendMail" access="public" returntype="string" description="Assembles JSON packet and sends it to Postmarkapp">

        <!--- Expected individual arguments. Attachments are handled using the argumentCollection property of <cfinvoke> --->
        <!--- Recipient, from and subject are required parameters. Also the API key. --->
        <cfargument name="mailTo" required="yes" type="string" displayname="Recipient of the message" />
        <cfargument name="mailFrom" required="yes" type="string" displayname="Sender of the message" />
        <cfargument name="mailSubject" required="yes" type="string" displayname="Subject of the message" />
        <cfargument name="apiKey" required="yes" type="string" displayname="API key, or server token">
        <!--- These are all optional --->
        <cfargument name="mailReply" required="no" type="string" displayname="Reply-to Address (if applicable)" />
        <cfargument name="mailCC" required="no" type="string" displayname="CC recipients (if applicable)" />
        <cfargument name="mailBCC" required="no" type="string" displayname="BCC recipients (if applicable)" />
        <cfargument name="mailHTML" required="no" type="string" displayname="HTML body of the message" />
        <cfargument name="mailTxt" required="no" type="string" displayname="Plain text body of the message" />


            <!--- Create a local struct.--->
            <cfset var local = structNew() />
            <!--- Create a default return struct and an array for the error handler. --->
            <cfset local.pmaStruct = structNew() />
            <cfset local.pmaStruct.errorArray = arrayNew(1) />     

            <!--- Format the argument strings --->
            <cfset local.mailto = #JSStringFormat(arguments.mailTo)# />
            <cfset local.mailFrom = #JSStringFormat(arguments.mailFrom)#>
            <cfset local.mailSubject = #JSStringFormat(arguments.mailSubject)# />

            <cfif IsDefined("arguments.mailCC") AND #arguments.mailCC# NEQ "">
                    <cfset local.mailCC = #JSStringFormat(arguments.mailCC)# />
            </cfif>
            <cfif IsDefined("arguments.mailBCC") AND #arguments.mailBCC# NEQ "">
                    <cfset local.mailBCC = #JSStringFormat(arguments.mailBCC)# />
            </cfif>                
            <cfif IsDefined("arguments.mailHTML") AND #arguments.mailHTML# NEQ "">
                    <cfset local.mailHTML = #JSStringFormat(arguments.mailHTML)# />
            </cfif>
            <cfif IsDefined("arguments.mailTxt") AND #arguments.mailTxt# NEQ "">
                    <cfset local.mailTxt = #JSStringFormat(arguments.mailTxt)# />
            </cfif>
            <cfif IsDefined("arguments.mailReply") AND #arguments.mailReply# NEQ "">
                    <cfset local.mailReply = #JSStringFormat(arguments.mailReply)# />
            </cfif>

            <!--- Assemble the JSON packet to send to Postmarkapp --->
            <cfsavecontent variable="local.jsonPacket">
                    <cfprocessingdirective suppressWhiteSpace="yes">
                            <cfoutput>
                            {
                                    "From" : "#local.mailFrom#",
                                    "To" : "#local.mailTo#",
                                    <cfif IsDefined("local.mailCC")>"CC" : "#local.mailCC#",</cfif>
                                    <cfif IsDefined("local.mailBCC")>"BCC" : "#local.mailBCC#",</cfif>
                                    "Subject" : "#local.mailSubject#"
                                    <cfif IsDefined("local.mailHTML")>, "HTMLBody" : "#local.mailHTML#"</cfif>
                                    <cfif IsDefined("local.mailTxt")>, "TextBody" : "#local.mailTxt#"</cfif>
                                    <cfif IsDefined("local.mailReply")>, "ReplyTo" : "#local.mailReply#"</cfif>

                                    <!--- find & count attachments --->
                                    <cfset local.objArgs = StructNew() />
                                    <cfset local.attachmentCount = 0>

                                        <cfloop item="local.Key" collection="#arguments#">                            
                                            <cfif (local.Key CONTAINS "_attachment")>
                                                <cfset local.objArgs[StructCount(local.objArgs) + 1] = local.Key />
                                            </cfif>
                                        </cfloop>

                                    <cfset local.attachmentCount = StructCount(local.objArgs)/>

                                    <!--- If there are any attachments, process them --->
                                    <cfif local.attachmentCount GTE 1> ,"Attachments": [</cfif>                        

                                    <cfset local.loopcount = 0>

                                    <!--- loop over the ARGUMENTS scope and find all '_attachment' references--->
                                    <cfloop item="LOCAL.Key" collection="#arguments#">

                                        <cfif (local.Key CONTAINS "_attachment")>

                                            <cfif StructKeyExists(arguments, local.Key)>

                                                <!---  found one, set a reference to the current attachment --->
                                                <cfset local.currFile = #arguments[local.Key]#>

                                                <!--- read file contents into RAM --->
                                                <cffile action="readbinary" file="#local.currFile#" variable="local.currFileBinary"/>    

                                                    <!--- get/set file mime-type --->                                       
                                                    <cfset local.currFileMimeType = getFileMimeType(local.currFile) /> 

                                                    <!--- mime type unrecognized, default to octet-stream --->
                                                    <cfif NOT isDefined("local.currFileMimeType")>
                                                           <cfset local.currFileMimeType = "application/octet-stream" />  
                                                    </cfif>
                                                    
                                                    <!--- convert to base64 --->
                                                    <cfset local.currfileBase64 = toBase64(local.currFileBinary) />

                                                        <!--- compose attachment string for PostMarkApp API --->
                                                        <cfif IsDefined("local.currFile")>{"Name" :"#JSStringFormat(local.currFile)#","Content" :"#JSStringFormat(local.currFileBase64)#","ContentType": "#JSStringFormat(local.currFileMimeType)#"}</cfif>
                                                   
                                                    <!--- update loopcount, set comma if needed --->
                                                    <cfset local.loopcount = local.loopcount + 1>
                                                <cfif local.loopcount LT local.attachmentCount>,</cfif>

                                            </cfif>
                                        </cfif>
                                    </cfloop>

                                <!--- close attachment struct --->
                                <cfif local.attachmentCount GTE 1> ]</cfif>
                            }
                            </cfoutput>
                    </cfprocessingdirective>        
            </cfsavecontent>

            <!--- Send the E-mail to Postmarkapp --->            
            <cftry>   
                    
                <cfhttp url="http://api.postmarkapp.com/email" method="post">
                    <cfhttpparam type="header" name="Accept" value="application/json" />
                    <cfhttpparam type="header" name="Content-type" value="application/json" />
                    <cfhttpparam type="header" name="X-Postmark-Server-Token" value="#arguments.apiKey#" />
                    <cfhttpparam type="body" encoded="no" value="#local.jsonPacket#" />
                </cfhttp>
           
                    <!--- Catch exceptions --->
                    <cfcatch type="any">                        
                        <!--- create & return error struct, this aborts processing on error --->
                        <cfset arrayAppend(local.pmaStruct.errorArray,"Error sending mail: #cfcatch.message# : #cfcatch.detail# : #cfcatch.stackTrace#") />
                        <cfreturn local.pmaStruct />
                    </cfcatch>
            </cftry>

        <!--- else return the PostMarkApp status code for the sent message--->
        <cfset local.pmaStruct.pmCode = #cfhttp.statusCode# /> 
        <cfreturn #local.pmaStruct.pmCode# />

    </cffunction>

    <cffunction name="getFileMimeType" access="private" returntype="string" output="false" hint="I determine the MIME type of a target file.">  

        <cfargument name="filePath" type="string" required="true" hint="I'm the path to the file to be tested." />
        <!--- Return the mime type of target file (Java). --->
        <cfreturn getPageContext().getServletContext().getMimeType(arguments.filePath) />

    </cffunction>  

</cfcomponent>



  
