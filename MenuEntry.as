import skyui.components.list.BasicListEntry;
import skyui.components.list.BasicList;
import skyui.components.list.ListState;

import com.greensock.*;
import com.greensock.easing.*;

class MenuEntry extends skyui.components.list.BasicListEntry
{
	/* STAGE */
	public var backgorund:MovieClip;
	public var selectIndicator:MovieClip;
	public var typeName:TextField;
	public var itemName:MovieClip;

	/* VARIABLES */
	private var __width;
	private var __height;

	/* INITIALIZE */
	public function MenuEntry() {
		// selectIndicator._alpha = 50;
	}
	
	// This is called after the object is added to the stage since the constructor does not accept any parameters.
	public function initialize(a_index: Number, a_list: BasicList): Void
	{
		// Do nothing.
	}
	
	// @abstract
	public function setEntry(a_entryObject: Object, a_state: ListState): Void
	{
		// enabled = a_entryObject.enabled
		var selected = a_entryObject == a_state.list.selectedEntry
		selectIndicator._visible = selected;
		typeName.text = a_entryObject.type;
		itemName.text = a_entryObject.name;
		if (selected) {
			_alpha = 90;

			_width = __width;
			_height = __height;
			TweenLite.to(this,0.2,{_width:__width + 2, _height:__height + 2});
		} else {
			_alpha = 45;
			TweenLite.to(this,0.2,{_width:__width, _height:__height});
		}
	}

}
