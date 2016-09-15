/**
 * 
 * Validates your Email-Address
 * 
 * @author Torsten Härtel, Less Rain (torsten@lessrain.com)
 * @since Flash Player 8
 */
class lessrain.lib.utils.EmailValidator
{
	public function EmailValidator() 
	{
	}
	
	/**
	 * Validates an Email-Address
	 * 
	 * @param	yourEmailAddress String
	 * @return	isValid Boolean
	 */
	 public static function checkEmailAddress(email:String) :Boolean
	 {
	 	if ((email.length<6) || (email.indexOf(",")>=0) || (email.indexOf(";")>=0) || (email.indexOf(":")>=0) || (email.indexOf("/")>=0) || (email.indexOf(" ")>=0) || (email.indexOf("@")<=0) || (email.indexOf("@") != email.lastIndexOf("@")) || (email.lastIndexOf(".")<email.indexOf("@")) || ((email.lastIndexOf(".")+3)>email.length)) 
		{
			return false;
		}	 	
	 	return true;
	 }
	
}