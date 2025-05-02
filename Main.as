import skyui.components.list.BasicEnumeration;
import skyui.components.list.FilteredEnumeration;
import skyui.components.list.BasicList;

import skyui.util.Translator;
import com.greensock.*;
import com.greensock.easing.*;
import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import mx.utils.Delegate;

class Main extends MovieClip
{
	/* STAGE */
	public var backgorund:MovieClip;
	public var searchBar:MovieClip;
	public var list:MovieClip;

	/* VARIABLES */
	private var _furnitureFilter: FurnitureFilter;

	/* INITIALIZE */
	public function Main() {
		super();
		_global.gfxExtensions = true;
		FocusHandler.instance.setFocus(this, 0);

		_alpha = 0;
	}

	public function onLoad()
	{
		_furnitureFilter = new FurnitureFilter();
		_furnitureFilter.addEventListener("filterChange", this, "onFilterChange");

		list.listEnumeration = new FilteredEnumeration(list.entryList);
		list.listEnumeration.addFilter(_furnitureFilter);
		list.addEventListener("itemPress", this, "onItemPress");

		searchBar.addEventListener("inputStart", this, "onSearchInputStart");
		searchBar.addEventListener("inputEnd", this, "onSearchInputEnd");
		searchBar.addEventListener("inputChange", this, "onSearchInputChange");

		// loadList(
		// 	{ name: "Name 1", type: "Type 1" },
		// 	{ name: "Name 2", type: "Type 3" },
		// 	{ name: "Name 3", type: "Type 1" },
		// 	{ name: "Name 4", type: "Type 2" },
		// 	{ name: "Name 5", type: "Type 2" },
		// 	{ name: "Name 6", type: "Type 3" },
		// 	{ name: "Name 7", type: "Type 1" },
		// 	{ name: "Name 8", type: "Type 5" },
		// 	{ name: "Name 9", type: "Type 1" },
		// 	{ name: "Name 10", type: "Type 7" }
		// );
	}

	public function loadList()
	{
		list.clearList();
		for (var i = 0; i < arguments.length; i++) {
			list.entryList.push(arguments[i]);
		}
		list.InvalidateData();
		list.selectDefaultIndex(true);
		TweenLite.to(this, 0.5, { _alpha: 100, ease: Strong.easeOut });
	}
	
	public function SetSelection(idx: Number): Void {}	// Overriden by .dll

	/* GFX */
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if (_alpha < 10)
			return false;

		if (GlobalFunc.IsKeyPressed(details)) {
			if (details.code == 57 || details.code == 32) { // Space
				searchBar.startInput();
				return true;
			}

			if (searchBar.isActive) {
				return searchBar.handleInput(details, pathToFocus);
			}

			if (list.handleInput(details, pathToFocus))
				return true;

			if (details.navEquivalent == NavigationCode.TAB || 
					details.navEquivalent == NavigationCode.SHIFT_TAB || 
					details.navEquivalent == NavigationCode.GAMEPAD_BACK ||
					details.navEquivalent == NavigationCode.ESCAPE) {
				closeMenu()
				return true;
			}
		}

		var nextClip = pathToFocus.shift();
		return nextClip.handleInput(details, pathToFocus);
	}

	/* PRIVATE */
	private function onItemPress(event:Object): Void
	{
		var selectedEntry = event.entry;
		if (selectedEntry != undefined) {
			SetSelection(selectedEntry.index);
		}
		closeMenu();
	}

	private function onFilterChange(): Void
	{
		list.requestInvalidate();
	}
	
	private function onSearchInputStart(event: Object): Void
	{
		list.disableSelection = list.disableInput = true
		TweenLite.to(list, 0.5, { _alpha: 60, ease: Strong.easeOut });
		_furnitureFilter.filterText = "";
	}

	private function onSearchInputChange(event: Object)
	{
		_furnitureFilter.filterText = event.data;
	}

	private function onSearchInputEnd(event: Object)
	{
		TweenLite.to(list, 0.5, { _alpha: 100, ease: Strong.easeOut });
		list.disableSelection = list.disableInput = false;
		_furnitureFilter.filterText = event.data;
	}

	private function closeMenu(): Void
	{
		TweenLite.to(this, 0.5, { _alpha: 0, ease: Strong.easeOut, onComplete: skse.CloseMenu, onCompleteParams: ["SLSelectionMenu"] });
	}
}
