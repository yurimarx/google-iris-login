Class dc.login.GoogleLogin Extends %CSP.Login
{

ClassMethod OnLoginPage() As %Status
{
	// text strings 
	Set ConfigName = $P($zu(86),"*",2)
	// get key, lookup in localization global
	Set tLang = $$$SessionLanguage
	Set tTitle = $$FormatText^%occMessages($$$GetSysMessage(tLang,..#DOMAIN,"logintitle","Login %1"),ConfigName)
	Set tPrompt = $$$GetSysMessage(tLang,..#DOMAIN,"loginenter","Please login")
	Set tUserName = $$$GetSysMessage(tLang,..#DOMAIN,"loginusername","User Name")
	Set tPassword = $$$GetSysMessage(tLang,..#DOMAIN,"loginpassword","Password")
	Set tLogin = $$$GetSysMessage(tLang,..#DOMAIN,"login","LOGIN")
	Set envClientId = ##class(%SYSTEM.Util).GetEnviron("CLIENT_ID")
	Set envLoginURI = ##class(%SYSTEM.Util).GetEnviron("LOGIN_URI")
	Set OtherAutheEnabled = $$OtherAuthEnabled^%SYS.cspServer(%request)
	&html<<html>>
	Do ..DrawHEAD(tTitle)

	&html<
		<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="pageLoad();">
		<script src="https://accounts.google.com/gsi/client" async defer></script>
        <div id="content">>
 
	Do ..DrawTitle(tTitle)

 	&html<
 	<div style="background-color:#FBFBFB;">
 	<table border="0" cellpadding="10" align="center" class="LayoutTable">
 	<tr>
	<td align="center">
 	<table border="0" width="100%" cellpadding="5" cellspacing="0">>
 	&html<<tr><td style="height:90px;"><br/></td></tr>>
 	
 	&html<<tr><td><center>>

  If OtherAutheEnabled = 1 {
	// Show standard login form

	&html<

    <div id="g_id_onload"
     data-client_id="#(envClientId)#"
     data-context="signin"
     data-ux_mode="popup"
	 data-callback="handleCredentialResponse"
     data-login_uri="#(envLoginURI)#"
     data-auto_prompt="false">
    </div>

    <div class="g_id_signin"
     data-type="standard"
     data-shape="rectangular"
     data-theme="outline"
     data-text="signin_with"
     data-size="large"
	 data-onsuccess="onSignIn" 
     data-logo_alignment="left">
    </div>
	
	<form name="Login" method="post" action="#($ZConvert($G(%request.Data("Error:FullURL",1)),"O","HTML"))#" autocomplete="off">>

	Write ..InsertHiddenFields($ZConvert($G(%request.Data("Error:URL",1)),"O","HTML"))

	&html<
	<table class="login" border="0" cellspacing="10" cellpadding="10" >
	<tr valign="bottom">
	<td nowrap class="loginCaption">#(tUserName)#</td>
	<td>
		<input type="text" size="30" name="IRISUsername" autocomplete="off" value="#($ZCVT($get(%request.Data("IRISUsername",1)),"O","HTML"))#"/>
	</td>
 	</tr>
	<tr valign="bottom">
	<td nowrap class="loginCaption">#(tPassword)#</td>
	<td><input type="password" size="30" name="IRISPassword" autocomplete="off"/>
	</td>
	</tr>
	<tr><td>&nbsp;</td>
	 <td style="text-align:right"><input type="submit" name="IRISLogin" class="button" value="#(tLogin)#" style="width:120px;"></td>
	</tr>
	</table>
	</form></center></div>>

  }  // End OtherAutheEnabled = 1 block
  Else {
	
	// This is accessed when IRIS is installed with minimum security and user clicked Logout.
	Set msg1 = $$$GetSysMessage(tLang,..#DOMAIN,"loginclickhere","Please click here to log in.")
	Do 
	Set tLink = ..Link("/csp/sys/UtilHome.csp")
	
	&html<
	<a href="#(tLink)#" class="loginlink">#(msg1)#</a><br>
	<a href="javascript:newSession();" class="loginlink">New Login</a> 
	</center>
	</td>
	</tr>
	</table>
	>
  }

 	// test for error
 	Set tMsg = $Get(%request.Data("Error:ErrorCode",1))
 	If ((tMsg'="")&&($SYSTEM.Status.GetErrorCodes(tMsg)'[$$$ERRORCODE($$$RequireAuthentication))) {
 		&html<<tr><td><center>>
 		Do ShowError^%apiCSP(tMsg)
 		&html<</center></td></tr>>
 	}

 	&html<</td></tr><tr><td style="height:180px;"><br/></td></tr></table></div></div></body></html>>

 	Quit $$$OK
}

ClassMethod DrawHEAD(pTitle = "")
{
	&html<<head>
	<title>#(pTitle)#</title>>

	// link in stylesheet specified by parameter
	If (..#STYLESHEET '= "") {
		&html<<link rel="stylesheet" type="text/css" href="#(..Link(..#STYLESHEET))#">>
	}
	If (..#FAVORITEICON '= "") {
		&html<<link rel="icon" type="image/ico" href="#(..Link(..#FAVORITEICON))#">>
	}
	// js functions
	&html<<script language="javascript">

	function setCookie(name,value,days) {
		var expires = "";
		if (days) {
			var date = new Date();
			date.setTime(date.getTime() + (days*24*60*60*1000));
			expires = "; expires=" + date.toUTCString();
		}
		document.cookie = name + "=" + (value || "")  + expires + "; path=/";
	}

	function newSession() {
		eraseCookie('email');
		window.location.reload();
	}

	function eraseCookie(name) {
		// This function will attempt to remove a cookie from all paths.
		var pathBits = location.pathname.split('/');
		var pathCurrent = ' path=';

		// do a simple pathless delete first.
		document.cookie = name + '=; expires=Thu, 01-Jan-1970 00:00:01 GMT;';

		for (var i = 0; i < pathBits.length; i++) {
			pathCurrent += ((pathCurrent.substr(-1) != '/') ? '/' : '') + pathBits[i];
			document.cookie = name + '=; expires=Thu, 01-Jan-1970 00:00:01 GMT;' + pathCurrent + ';';
		}
	}


	function deleteAllCookies() {
    	const cookies = document.cookie.split(";");

		for (let i = 0; i < cookies.length; i++) {
			const cookie = cookies[i];
			const eqPos = cookie.indexOf("=");
			const name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;
			document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
		}
	}


	// called when page is loaded
	function pageLoad()
	{
		// see if we can give focus to the UserName field:
		if (self.document.Login && self.document.Login.IRISUsername) {
			self.document.Login.IRISUsername.focus();
			self.document.Login.IRISUsername.select();
		}

		return true;
	}

	function decodeJwtResponse(token) {
		var base64Url = token.split('.')[1];
		var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
		var jsonPayload = decodeURIComponent(window.atob(base64).split('').map(function(c) {
			return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
		}).join(''));

		return JSON.parse(jsonPayload);
	}

	function handleCredentialResponse(response) {

		const responsePayload = decodeJwtResponse(response.credential);

		console.log("ID: " + responsePayload.sub);
		console.log('Full Name: ' + responsePayload.name);
		console.log('Given Name: ' + responsePayload.given_name);
		console.log('Family Name: ' + responsePayload.family_name);
		console.log("Image URL: " + responsePayload.picture);
		console.log("Email: " + responsePayload.email);
		
		setCookie('email', responsePayload.email);
		setCookie('googleToken', response.credential);

        if(responsePayload.email !== null) {
            document.getElementsByName('Login')[0].submit();
        }
	}

	</script>>
	If ##class(%ZEN.Utils).%BrowserSupportsHTML5(%request.UserAgent) {
		Do ..DrawCSS3STYLE()
	}
	Else {
		Do ..DrawSTYLE()
	}
	&html<</head>>
}

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	If '$$UseCSRFtoken^%SYS.cspServer(%request.AppData) RETURN 1
	Set token=##class(%OAuth2.Utils).Base64UrlEncode($system.Encryption.GenCryptRand(12))
	Set %response.Context("IRISSessionToken")=token
	Set cookiepath=%session.CookiePath
	If $extract(cookiepath,*)'="/" Set cookiepath=cookiepath_"/"
	Set sameSite=$$$GetCookieScopeString(%session.SessionScope)
	Do %response.SetCookie("IRISSessionToken",token,,$zcvt($zcvt(cookiepath,"O","UTF8"),"O","URL"),,%request.Secure,1,sameSite)
	RETURN 1
}

}
