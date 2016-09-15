	// get our flash movie object
	function init()
	{
		if (document.getElementById) flashMovie = document.getElementById(flashID);
	}
	/*
	
	Automatically adds rollover effects to image links.
	The function should be called 
	- on load of the body (<body onload="prepareRollOvers()">...</body>)
	- or tied to the window.onLoad event (window.onload = prepareRollOvers;)
	
	It assumes the following:
	- The image tag is marked with class="imgRollOver" (<img src="img.gif" class="imgRollOver" />)
	- The hover image file is named with the suffix "_h", i.e. "image.gif" has the hover graphic "image_h.gif"
	- The highlighted image file ("emphasized") is named with the suffix "_em", i.e. "image.gif" has the highlighted graphic "image_em.gif"
	
	Full example:
	<img src="/images/toolbar/add_comment.gif" class="imgRollOver" width="102" height="18" alt="Add comment" title="Add comment" />
	
	*/
	function prepareRollOvers()
	{
		var rollOverImgs = document.getElementsByTagName("img");
		for (var i=0; i<rollOverImgs.length; i++)
		{
			if (hasClass(rollOverImgs[i], "imgRollOver"))
			{
				var img = rollOverImgs[i];
				var imgSrc = img.src;
				
				var hoverImg = new Image();
				var hoverSrc;
				
				var imgPath = imgSrc.substr( 0, imgSrc.lastIndexOf(".") );
				
				// if the normal image contains the suffix "_em" it's a highlighted one, so we have to do special stuff to get the correct _h filename...
				if (imgPath.substr( imgPath.length - 3 ) == "_em") hoverSrc = imgPath.substr( 0, imgPath.length - 3 ) + "_h" + imgSrc.substr( imgSrc.lastIndexOf(".") );
				// otherwise we only need to appen "_h" before the file-suffix
				else hoverSrc = imgPath + "_h" + imgSrc.substr( imgSrc.lastIndexOf(".") );
				
				hoverImg.src = hoverSrc;
				
				rollOverImgs[i].hoverSrc = hoverSrc;
				rollOverImgs[i].imgSrc = imgSrc;
				
				rollOverImgs[i].onmouseover = function ()
				{
					this.src = this.hoverSrc;
				}
				
				rollOverImgs[i].onmouseout = function ()
				{
					this.src = this.imgSrc;
				}
			}
		}
	}

	/*
	Helper function that checks if a given element has a certain class assigned to it.
	returns true/false
	*/
	function hasClass(element, className)
	{
		var classes = element.className.split(" ");
		for (var i=classes.length-1; i>=0; i--) if (classes[i]==className) return true;
		return false;
	}
