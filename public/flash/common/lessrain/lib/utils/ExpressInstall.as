/**
 * ExpressInstall class v0.91 - http://blog.deconcept.com/flashobject/
 * 
 * 08-12-2005 (c) 2005 Geoff Stearns and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Use this class to invoke the Macromedia Flash Player Express Install functionality
 * This file is intended for use with the FlashObject embed script. You can download FlashObject 
 * and this class here: http://blog.deconcept.com/flashobject/
 *
 * Usage: Place this file in your AS2 class path.
 *        on the first frame of your Flash movie, place this line of code:
 *        
 *        ExpressInstall.init();
 *        
 *        You should not place any other code on the first frame of your movie, as the first frame
 *        needs to be playable in the Flash player v. 6.0.65.
 *
 */

class lessrain.lib.utils.ExpressInstall {

   private var updater:MovieClip;
   private var hold:MovieClip;
   private static var instance:ExpressInstall;

   function ExpressInstall() {}

   public static function init():Boolean {
      // if MMplayerType is not set, the var was not passed in
      // from the FlashObject embed, so the upgrade is not needed
      if (_root.MMplayerType == undefined) {
         return false;
      }
      ExpressInstall.getInstance().loadUpdater();
      return true;
   }

   public static function getInstance():ExpressInstall {
      if (instance == null) {
         instance = new ExpressInstall();
      }
   return instance;
   }

   private function loadUpdater():Void {
      System.security.allowDomain("fpdownload.macromedia.com");

      // hope that nothing is at a depth of 10000000, you can change this depth if needed, but you want
      // it to be on top of your content if you have any stuff on the first frame
      this.updater = _root.createEmptyMovieClip("expressInstallHolder", 10000000);
      // register the callback so we know if they cancel or there is an error
      this.updater.installStatus = this.installStatus;
      this.hold = this.updater.createEmptyMovieClip("hold", 1);

      // can't use movieClipLoader because it has to work in 6.0.65
      this.updater.onEnterFrame = function() {
         if (typeof MovieClip(this).hold.startUpdate == 'function') {
            ExpressInstall.getInstance().loadInit();
            delete MovieClip(this).onEnterFrame;
         }
      };

      var cacheBuster:Number = Math.random();
      this.hold.loadMovie("http://fpdownload.macromedia.com/pub/flashplayer/update/current/swf/autoUpdater.swf?"+ cacheBuster);
   }

   public function loadInit() {
      this.hold.redirectURL = _root.MMredirectURL;
      this.hold.MMplayerType = _root.MMplayerType;
      this.hold.MMdoctitle = _root.MMdoctitle;
      this.hold.startUpdate();
   }

   public function installStatus(statusValue:String):Void {
      if (statusValue == "Download.Complete") {
         // Installation is complete. In most cases the browser window that this SWF 
         // is hosted in will be closed by the installer or manually by the end user
      } else if (statusValue == "Download.Cancelled") {
         // The end user chose "NO" when prompted to install the new player
         // by default no User Interface is presented in this case. It is left up to 
         // the developer to provide an alternate experience in this case

         // feel free to change this to whatever you want, js errors are sufficient for this example
         getURL("javascript:alert('This content requires a more recent version of the Macromedia Flash Player.')");
      } else if (statusValue == "Download.Failed") {
         // The end user failed to download the installer due to a network failure
         // by default no User Interface is presented in this case. It is left up to 
         // the developer to provide an alternate experience in this case

         // feel free to change this to whatever you want, js errors are sufficient for this example
         getURL("javascript:alert('There was an error in downloading the Flash Player update. Please try again later, or visit macrmedia.com to download the latest version of the Flash plugin.')");
      }
   }
}