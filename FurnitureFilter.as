import gfx.events.EventDispatcher;
import skyui.util.GlobalFunctions;
import skyui.filter.IFilter;

class FurnitureFilter implements skyui.filter.IFilter
{
  /* PROPERTIES */
  
	public var nameAttribute: String = "type";
	public var nameAttribute2: String = "name";
  

	private var _filterText: String = "";

	public function get filterText(): String
	{
		return _filterText;
	}

	public function set filterText(a_filterText: String)
	{
		a_filterText = a_filterText.toLowerCase();

		if (a_filterText == _filterText)
			return;
			
		_filterText = a_filterText;
		dispatchEvent({type:"filterChange"});
	}
	
	
  /* CONSTRUCTORS */
	
	public function FurnitureFilter()
	{
		EventDispatcher.initialize(this);
	}
	

  /* PUBLIC FUNCTIONS */

	// @override skyui.IFilter
	public function applyFilter(a_filteredList:Array): Void
	{
		trace("applyFilter: " + _filterText + ", " + a_filteredList.length);
		if (_filterText == undefined || _filterText == "")
			return;

		for (var i = 0; i < a_filteredList.length; i++) {
			if (!isMatch(a_filteredList[i])) {
				a_filteredList.splice(i,1);
				i--;
			}
		}
	}
  
	// @mixin by gfx.events.EventDispatcher
	public var dispatchEvent: Function;
	public var dispatchQueue: Function;
	public var hasEventListener: Function;
	public var addEventListener: Function;
	public var removeEventListener: Function;
	public var removeAllEventListeners: Function;
	public var cleanUpEvents: Function;


  /* PRIVATE FUNCTIONS */

	private function isMatch(a_entry: Object): Boolean
	{
		var searchStr = a_entry[nameAttribute].toLowerCase();
		var searchStr2 = a_entry[nameAttribute2].toLowerCase();

		var ret = isMatchImpl(a_entry, searchStr) || isMatchImpl(a_entry, searchStr2);
		trace("isMatch: " + searchStr + ", " + searchStr2 + ", " + _filterText + ", " + ret);
		return ret;
	}

	private function isMatchImpl(a_entry: Object, searchStr: String): Boolean
	{
		var seekIndex = 0;
		var seek = false;

		for (var i = 0; i < searchStr.length; i++) {
			var charCode = GlobalFunctions.mapUnicodeChar(_filterText.charCodeAt(seekIndex));
			
			if (searchStr.charCodeAt(i) == charCode) {
				if (!seek)
					seek = true;
					
				seekIndex++;

				if (seekIndex >= _filterText.length)
					return true;
					
			} else if (seek) {
				seek = false;
				seekIndex = 0;
			}
		}
		return false;
	}

}