Class dc.login.CypherUtil
{

ClassMethod DoAESCBCEncrypt(plaintext As %String) As %String
{
    // convert to utf-8
    Set text=$ZCONVERT(plaintext,"O","UTF8") 
   
    // set a secret key
    Set secretkey = $system.Util.GetEnviron("SECRETKEY")
    Set IV = $system.Util.GetEnviron("SECRETKEY")
   
    // encrypt a text
    Set text = $SYSTEM.Encryption.AESCBCEncrypt(text, secretkey, IV)
    Set ciphertext = $SYSTEM.Encryption.Base64Encode(text)
   
    Return ciphertext
}

ClassMethod DoAESCBCDecrypt(ciphertext As %String) As %String
{
    // set a secret key
    Set secretkey = $system.Util.GetEnviron("SECRETKEY")
    Set IV = $system.Util.GetEnviron("SECRETKEY")
    
    // decrypt a text
    Set text=$SYSTEM.Encryption.Base64Decode(ciphertext)
    Set text=$SYSTEM.Encryption.AESCBCDecrypt(text,secretkey,IV)
   
    Set plaintext=$ZCONVERT(text,"I","UTF8")
    
    Return plaintext
}

}
