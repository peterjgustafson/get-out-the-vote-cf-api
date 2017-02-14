<!--- Get the clients sender address, and postmark api credentials --->
<!---Build this later --->

<!---Get upcoming election for the current state --->
<cfquery name="getUpcomingElection" datasource="GOTV">	
SELECT TOP 1 ElectionName, ABEndDate, ElectionDate
FROM         dbo.Elections
WHERE State = '#stateAbbr#';
</cfquery>

<cfmail from="gotv@prosperitypac.com" subject="Absentee Ballot application" to="#url.Email#" remove="true" server="smtp.postmarkapp.com" username="43a619df-47a9-45f0-83e6-9f003a81fe2b" password="43a619df-47a9-45f0-83e6-9f003a81fe2b" >
				<cfmailparam file="#attachmentPath#" disposition="attachment">
				<cfmailpart type="text" wraptext="74">
			        Thank you for requesting your absentee ballot! 
					
					<cfif isDefined("formattedAddress")><p>Your mailing address is:
					#formattedAddress#
					
					</cfif>Please make sure that after you print this application, you sign the application and mail it to your County Clerk office. 
					
					<cfif getUpcomingElection.recordCount>The application must be received by your County Clerk by 5pm on Thursday, #dateFormat(getUpcomingElection.ABEndDate, "mmmm d")# to apply to vote by mail for the #dateFormat(getUpcomingElection.ElectionDate, "mmmm d, yyyy")# Election.</cfif> 
					
					With all that's at stake, your support will make a difference in this election. Encourage your family and friends to request their absentee ballot at http://gotv.prosperitypac.com/#stateAbbr#/absentee/. 
					
					Thanks again!
			    </cfmailpart>
			    <cfmailpart type="html">
				<cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
				<html style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
				    <head>
				        <meta name="viewport" content="width=device-width" />     <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				        <title>Prosperity Action</title>
				    </head>
				    <body bgcolor="##FFFFFF" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; -webkit-font-smoothing: antialiased; -webkit-text-size-adjust: none; width: 100% !important; height: 100%; margin: 0; padding: 0;">
				        <table style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; width: 100%; margin: 0; padding: 0;">
				            <tbody>
				                <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
				                    <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; margin: 0; padding: 0;"></td>
				                    <td bgcolor="##FFFFFF" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; display: block !important; max-width: 600px !important; clear: both !important; margin: 0 auto; padding: 0;">
				                    <div style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; max-width: 600px; display: block; margin: 0 auto; padding: 15px;">
				                    <table style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; width: 100%; margin: 0; padding: 0;">
				                        <tbody>
				                          
				                            <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
				                                <td style="margin: 0px; padding: 0px;">
				                                <p align="center" style="font-family: 'Helvetica Neue', Helvetica, Helvetica, Arial, sans-serif; text-align: center; font-weight: normal; font-size: 14px; line-height: 1.6; margin: 0px 0px 10px; padding: 0px;"><span style="font-family: Arial;"><span style="font-size: 14px;" /></span></p>
				                                <div>
				                                <div style="text-align: center;"><img width="336" height="70" border="0" alt="" spname="ProsperityActionLogo_65px" name="ProsperityActionLogo_65px" contentid="3a838ce3-1478942569f-b9e6bcd68d4fb511170ab3fcff55179d" xt="SPIMAGE" src="http://contentz.mkt5241.com/ra/2014/13925/07/21210030/ProsperityActionLogo_65px.jpe" /></div>
				                                <p>Thank you for requesting your absentee ballot! </p>
												<p><b>Your mailing address is:</b><br>#formReturnData.ThankYou.MailingAddress#</p>
				                                <p>Please make sure that after you print this application, you sign the application and mail it to your municipal clerk's office.</p>
				                                <cfif getUpcomingElection.recordCount><p>The application must be received by your County Clerk by 5pm on Thursday, #dateFormat(getUpcomingElection.ABEndDate, "mmmm d")# to apply to vote by mail for the #dateFormat(getUpcomingElection.ElectionDate, "mmmm d, yyyy")# Election.</p></cfif> 
				                                <p>With all that's at stake, your support will make a difference in this election. Encourage your family and friends to request their absentee ballot at <a href="http://gotv.prosperitypac.com/#stateAbbr#/absentee/">http://gotv.prosperitypac.com/#stateAbbr#/absentee/</a>. </p>
				                                <p>Thanks again! </p>
				                                <p>Team Prosperity<br />
				                                  <br />
				                                  <br />
				                                  <br />
				                                  <br />
				                                </p>
				                            
				                           
				                              </td>
				                            </tr>
				                            <tr style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
				                                <td align="center" style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
				                                <div style="display: block; width: 50%; font-size: 10px; font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; margin: 0 auto; padding: 10px; border: 1px solid ##626061;">Paid for by Prosperity Action, Inc.<br style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; margin: 0; padding: 0;" />
				                                Not Authorized by any candidate or candidate's committee.<br style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; margin: 0; padding: 0;" />
				                                <br style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; margin: 0; padding: 0;" />
				                                1006 Pendleton Street<br style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; margin: 0; padding: 0;" />
				                                Alexandria, VA 22314<br style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; margin: 0; padding: 0;" />
				                                www.prosperitypac.com</div>
												<img width="1" height="1" alt="" src="http://bcp.crwdcntrl.net/5/c=1879/b=17192673" name="Cont_6" />
				                                </td>
				                            </tr>
				                        </tbody>
				                    </table>
				                    </div>
				                    </td>
				                    <td style="font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif; margin: 0; padding: 0;"></td>
				                </tr>
				            </tbody>
				        </table>
				        
				        <p></p>
				    </body>
				</html></cfoutput>
			    </cfmailpart>
			</cfmail>