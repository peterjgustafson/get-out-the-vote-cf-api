<cfif isDefined("fileUpload")>
  <cffile action="upload"
     fileField="fileUpload"
     destination="C:\Inetpub\wwwroot\AK" nameconflict="overwrite">
     <p>Thankyou, your file has been uploaded.</p>
</cfif>
<form enctype="multipart/form-data" method="post">
<input type="file" name="fileUpload" /><br />
<input type="submit" value="Upload File" />
</form>