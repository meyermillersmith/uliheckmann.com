import lessrain.lib.components.mediaplayer07.controls.BufferingDisplay;
import lessrain.lib.components.mediaplayer07.controls.Button;
import lessrain.lib.components.mediaplayer07.controls.ControlPanel;
import lessrain.lib.components.mediaplayer07.controls.Slider;
import lessrain.lib.components.mediaplayer07.controls.Switch;
import lessrain.lib.components.mediaplayer07.controls.TextField;
import lessrain.lib.components.mediaplayer07.display.DisplayPanel;
import lessrain.lib.components.mediaplayer07.display.IViewUIBuilder;
import lessrain.lib.components.mediaplayer07.display.View;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
import lessrain.lib.layout.GridData;
import lessrain.lib.layout.GridLayout;

/**
 * Default UIBuilder for the media player view. It creates a view with display
 * panel as the top most element and a control panel underneath. The control
 * panel with adjusts to the display panel width.
 * 
 * Use this class as a reference to create custom media player layouts.
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.display.DefaultViewUIBuilder implements IViewUIBuilder {
	
	private var _view:View;
	private var _skinFactory:ISkinFactory;
	
	/**
	 * @see IViewBuilder#buildUI 
	 */
	public function buildUI(view_:View, skinFactory_:ISkinFactory):Void {
		_view = view_;
		_skinFactory = skinFactory_;
		
		/*
		 * Create player main layout: We use a GridLayout with one column only
		 * to make the items fill the available space
		 * 
		 * @see GridData#grabExcessHorizontalSpace
		 * @see GridData#grabExcessVerticalSpace
		 * @see GridData#horizontalAlignment
		 * @see GridData#verticalAlignment
		 */
		var layout:GridLayout = new GridLayout(1, GridLayout.TOP_DOWN);
		layout.marginHeight = 
		layout.marginWidth = 
		layout.marginTop = 
		layout.marginRight = 
		layout.marginBottom = 
		layout.marginLeft = 0;
		layout.verticalSpacing = 1;
		_view.setLayout(layout);
		
		/*
		 * Create the display panel (the area that is used to display the media)
		 * and assign a GridData instance. By setting GridData's minimumWidth 
		 * and minimumHeight properties to the media size, the player will
		 * be at least as big as the media (normal mode). To make it fill the
		 * full screen, we use GridData.FILL_BOTH
		 * 
		 * @see GridData
		 */
		var displayPanel:DisplayPanel = new DisplayPanel(_skinFactory.createDisplayPanelSkin(), _view);
		_view.addChild(displayPanel);
		var data:GridData = new GridData(GridData.FILL_BOTH);
		data.minimumWidth = 640;
		data.minimumHeight = 468;		displayPanel.setLayoutData(data);
		
		/*
		 * Create the control panel and let it fill the available horizontal 
		 * space (GridData.FILL_HORIZONTAL)
		 * Adding the control elements to the control panel is done by
		 * <code>populateControlPanel()</code>
		 */
		var controlPanel:ControlPanel = new ControlPanel(_skinFactory.createControlPanelSkin(), _view);
		_view.addChild(controlPanel);
		populateControlPanel(controlPanel);
		var controlPanelLayoutData:GridData = new GridData(GridData.FILL_HORIZONTAL | GridData.VERTICAL_ALIGN_CENTER);
		controlPanel.setLayoutData(controlPanelLayoutData);
	}
	
	/**
	 * Fill the control panel
	 */
	private function populateControlPanel(controlPanel_:ControlPanel):Void {
		// TogglePlayButton
		var togglePlayButton:Switch = new Switch(_skinFactory.createTogglePlayButtonSkin());
		if(controlPanel_.setTogglePlayButton(togglePlayButton, Key.SPACE)) {
			controlPanel_.addChild(togglePlayButton);
		}
		
		// StopButton
		var stopButton:Button = new Button(_skinFactory.createStopButtonSkin());
		if(controlPanel_.setStopButton(stopButton, "s")) {
			controlPanel_.addChild(stopButton);
		}

		// PrevButton
		var prevButton:Button = new Button(_skinFactory.createPrevButtonSkin());
		if(controlPanel_.setPrevButton(prevButton, Key.PGDN)) {
			controlPanel_.addChild(prevButton);
		}
		
		// NextButton
		var nextButton:Button = new Button(_skinFactory.createNextButtonSkin());
		if(controlPanel_.setNextButton(nextButton, Key.PGUP)) {
			controlPanel_.addChild(nextButton);
		}
		
		// TimeTextField
		var timeTextField:TextField = new TextField(_skinFactory.createTimeTextFieldSkin());
		if(controlPanel_.setTimeTextfield(timeTextField)) {
			controlPanel_.addChild(timeTextField);
		}
		
		// ProgressBar
		var progressBar:Slider = new Slider(_skinFactory.createProgressBarSkin());
		if(controlPanel_.setProgressBar(progressBar, Key.RIGHT, Key.LEFT)) {
			progressBar.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
			controlPanel_.addChild(progressBar);
		}
		
		// Buffernig / Loading display
		var bufferingDisplay:BufferingDisplay = new BufferingDisplay(_skinFactory.createBufferingDisplaySkin());
		if(controlPanel_.setBufferingDisplay(bufferingDisplay) || controlPanel_.setLoadingDisplay(bufferingDisplay)) {
			controlPanel_.addChild(bufferingDisplay);
		}
		
		// Mute Button
		var muteButton:Switch = new Switch(_skinFactory.createMuteButtonSkin());
		if(controlPanel_.setMuteButton(muteButton, "m")) {
			controlPanel_.addChild(muteButton);
		}
		
		// VolumeController
		var volumeController:Slider = new Slider(_skinFactory.createVolumeControllerSkin());
		if(controlPanel_.setVolumeController(volumeController, Key.UP, Key.DOWN)) {
			controlPanel_.addChild(volumeController);
		}
		
		// FullscreenButton
		var fullscreenButton:Switch = new Switch(_skinFactory.createFullscreenButtonSkin());
		if(controlPanel_.setFullscreenButton(fullscreenButton, "f")) {
			controlPanel_.addChild(fullscreenButton);
		}
		
		/*
		 * Now that all controls have been added to the ControlPanel, assign a 
		 * GridLayout to the ControlPanel layout host
		 */
		var layout:GridLayout = new GridLayout(controlPanel_.getChildren().length);
		layout.marginHeight = 12;
		layout.marginWidth = layout.horizontalSpacing = 16;
		controlPanel_.setLayout(layout);
	}
}