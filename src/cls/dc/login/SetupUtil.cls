Class dc.login.SetupUtil
{

Parameter GN = "^%ZAPM.AppsDelegate";

/// write ##class(dc.login.SetupUtil).Apply("/csp/sys")
ClassMethod Apply(app = "/csp/sys", user = "", pass = "", mode = "0")
{
	Quit:app="" $$$OK
	New $NAMESPACE
	If $NAMESPACE'="%SYS" {
		Write !,""
		If $$EXIST^%R("ZAUTHENTICATE.mac","%SYS") {
			Set msg="Routine ZAUTHENTICATE.mac in %SYS already installed"
			Write !,msg
			If mode=1 Quit $$$OK
			If mode=2 Quit $$$ERROR($$$GeneralError,msg)
		}
		Set tempFile = ##class(%File).TempFilename("xml")
		Set list("ZAUTHENTICATE.MAC")=""
		Set list("dc.login.GoogleLogin.CLS")=""
		Set list("dc.login.SetupUtil.CLS")=""
		Set st=$SYSTEM.OBJ.Export(.list, tempFile)
		Set $NAMESPACE="%SYS"
		Set st = $SYSTEM.OBJ.Load(tempFile, "c")
		If 'st {
			Set msg=$SYSTEM.Status.GetErrorText(st) Write !,msg 
			Quit $$$ERROR($$$GeneralError,msg)
		}
	}
 	Set $NAMESPACE="%SYS"

	Set:app="" app= $SYSTEM.Util.GetEnviron("ISC_app")
	Set:app="" app="/csp/sys"
	
	// Edit Security Authentication/Web Session Options
	Set ss=##class(Security.System).%OpenId("SYSTEM")
	If '$ZBOOLEAN(ss.AutheEnabled, $$$AutheDelegated, 1) {
		Set ss.AutheEnabled = ss.AutheEnabled + $$$AutheDelegated
	}
	Set st=ss.%Save()
	If 'st Quit st
	
	If app="*" {
		Set result=##CLASS(%ResultSet).%New("%DynamicQuery:SQL")
		Set tSC=result.Prepare("select Name FROM Security.Applications")
		Set:tSC tSC=result.Execute()
		If '$$$ISOK(tSC) {
			Set text="Application setup error :"_$SYSTEM.Status.GetErrorText(tSC)  
			Write !,text 
			Quit $$$ERROR(text)
		}
		Else {
			While result.Next() {
				Set CSP=result.Data("Name")
				Set csp=$ZCONVERT(CSP,"L")
				Set st=..AddDelegate(csp,user,pass)
			}
		Write !,"OK"
		}	
	}
	ElseIf app["," {
		Set a=""
		For i=1:1:$LENGTH(app,",") { Set a=$PIECE(app,",",i)
			Continue:a=""
			Set st=..AddDelegate(a,$PIECE(user,",",i),$PIECE(pass,",",i))
		}
	}
	Else {
		Set st=..AddDelegate(app,user,pass)
	}
	Quit $$$OK
}

ClassMethod AddDelegate(app, user = "", pass = "")
{
	Set st=##class(Security.Applications).Get(app,.par)
	If st {
		If par("AutheEnabled")=$$$AutheUnauthenticated Quit $$$OK
		// Remove unauthenticated and add delegated
		If $ZBOOLEAN(par("AutheEnabled"), $$$AutheUnauthenticated, 1) {
			Set par("AutheEnabled") = par("AutheEnabled") - $$$AutheUnauthenticated
		}
		If '$ZBOOLEAN(par("AutheEnabled"), $$$AutheDelegated, 1) {
			Set par("AutheEnabled") = par("AutheEnabled") + $$$AutheDelegated
		}
		Set par("LoginPage") = "dc.login.GoogleLogin.cls"
		Set st=##class(Security.Applications).Modify(app,.par)
		If st {
			Set acc=""
			If user'="" Set acc=$LISTBUILD(user,pass)
			If $EXTRACT(app,*)'="/" Set app=app_"/"
			Set @..#GN@(app)=acc
		}
	}
	Quit st
}

}
