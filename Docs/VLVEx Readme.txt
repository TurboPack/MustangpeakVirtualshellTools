VirtualExplorerListviewEx:

Software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,
either express or implied.
The initial developer of this code is Robert Lee.


Requirements:
  - Mike Lischke's Virtual Treeview (VT)
    http://www.lischke-online.de/VirtualTreeview/VT.html
  - Jim Kuenaman's Virtual Shell Tools (VSTools)
    http://groups.yahoo.com/group/VirtualExplorerTree


Credits:
  Special thanks to Mike Lischke (VT) and Jim Kuenaman (VSTools) for the
  magnificent components they made available to the Delphi community.
  Thanks to (in alphabetical order):
    Aaron, Adem Baba (all around helper), Bill Miller (HyperVirtualExplorer),
    Werner Lehmann (Thumbs Cache), Milan Vandrovec (memory leaks hunter),
    Philip Wand, Troy Wolbrink (Unicode support).


Installation:
  Compile the runtime package VirtualExplorerListviewExDx.dpk in your VSTools folder.
  Compile and install the designtime package VirtualExplorerListviewExDxD.dpk.
  Where x is the Delphi version.

How to use:
  VirtualExplorerListviewEx introduces new properties and events to VirtualExplorerListview:

Properties
==========
- ViewStyle: view style of the Listview, including Thumbnails.

- ThumbOptions: general thumbnail options, like size, spacing, highlight color, etc.
  Special options are:
  + BorderOnFiles: when true it shows borders on all the files and folders, otherwise 
    it shows borders only on image files.
  + CacheOptions: thumbnail cache and compression options.
  + Details: allows to show file and image properties below the thumbnail.
    More details could be painted increasing/decreasing ThumbDetailsHeight property and 
    painting them in the OnThumbsDrawAfter event.
  + LoadAllAtOnce: loads all the thumbnails at once, when the dir is changed.
  + Stretch: stretches the thumb images to fit the thumbnail size.

- ExtensionsList: stringlist of valid image extensions for thumbnails creation.
  You must have a TGraphic descendant that handles the kind of images of the 
  extensions you add, like Anders Melander's TGifImage for gifs 
  (http://www.melander.dk/delphi/gifimage),  or a complete image library like 
  Mike Lischke's GraphicEx (http://www.lischke-online.de/Graphics.html).
  Just use it like this:
    VLVEx.ExtensionsList.Add('.gif');
    VLVEx.ExtensionsList.Remove('.png');

  Currently VirtualExplorerListviewEx automatically supports the following 
  image libraries:
  * GraphicEx (http://www.lischke-online.de/Graphics.html): 
    In VET\Include\VSToolsAddIns.inc uncomment this line {$DEFINE USEGRAPHICEX}

  * ImageEn (http://www.hicomponents.com): 
    In VET\Include\VSToolsAddIns.inc uncomment this line {$DEFINE USEIMAGEEN}

  * Envision Image Library (http://www.intervalsoftware.com): 
    In VET\Include\VSToolsAddIns.inc uncomment this line {$DEFINE USEENVISION}

Events
======

- OnThumbsCacheItemAdd: a thumbnail is about to be added to the cache after it was processed.
  This event could be used to store the thumbnail in an external database.

- OnThumbsCacheItemRead: a thumbnail must be read from the cache.
  This event could be used to provide the thumbnail from an external database.

- OnThumbsCacheItemLoad: a thumbnail was loaded from the cache.
  This event could be used to reload or change the loaded thumbnail.

- OnThumbsCacheItemProcessing: a thumbnail must be created.
  This event could be used to override the default thumbnail creation.

- OnThumbsCacheLoad: the cache was loaded from file.
  This event could be used to load the cache from an external database.

- OnThumbsCacheSave: the cache is about to be saved.
  This event could be used to save the cache to an external database.

- OnThumbsDrawBefore: triggered before the thumbnail is painted.
  Typically used to paint the background of the thumbnail.

- OnThumbsDrawAfter: triggered after the thumbnail is painted.
  Typically used to paint borders or text on top of the drawed thumbnail.

Public Methods
==============
- ValidateThumbnail: validates and returns the thumbnail data of a Node.

- ValidateListItem: validates and returns a TListItem associated to a Node, 
  The obtained ListItem gives you access to its properties and methods,
  which will be sensible to use only when the ViewStyle is not in vsxReport,
  for example:
    var
      L: TListItem;
    begin
      if LVEx.ValidateListItem(LVEx.FocusedNode, L) then
        L.MakeVisible(false);

- IsImageFile: checks if a filename is a supported image file.

- GetThumbDrawingBounds: gets the drawing portion of a thumbnail.

ExplorerListviewEx will take care of the synchronization between the child
VCL Listview and the VET Listview, however if you need to force it you
should use:
- SyncInvalidate: invalidates the Listview canvas.

- SyncItemsCount: will sync the items, and will force a repaint of the Listview

- SyncOptions: syncs the Options properties between the two Listviews.

- SyncSelectedItems: syncs selected and focused items.


Compression Tests
=================
VirtualExplorerListviewEx uses a cache system that has on-the-fly compression
for the thumbnail images.
It uses JPEG compression because it's the most effective compression method
for images, the drawback is that there's a loss of quality in the thumbnails.
Here are some tests on a folder with 200 images (120 x 120 thumbnails)
No compression: 7205 Kb, 0% compressed
ZLib: 5002 Kb, 30% compressed
JPEG: 441 Kb, 94% compressed


History
=======

20 December 2003 - version 1.4
  - Compatible with VT 4.0.16 and VSTools 1.1.12c
  - Changed the Cache StreamVersion, previous cache files will be reloaded.
  - Fixed Drag&Drop synchronization, the OLE drop is disabled by setting off
    toAcceptOLEDrop.
  - Fixed incorrect focus painting.
  - Fixed DetailedHints inconsistence.
  - Fixed TCacheList problem with some exotic folder names.
  - Fixed another VCL TListview bug, the edit control was not correctly showed
    when using large fonts in vsxList and vsxSmallIcons ViewStyles, thanks to
    Boris for reporting this.
  - Adem Baba added support for the ImageMagick graphic library (http://www.imagemagick.org)
    using Nils Haeck Delphi wrapper: http://www.simdesign.nl/components/imagemagick.html
  - Added ImageLibrary property to get the image library type that is being used.
  - Added HideCaptions option to hide the thumbnails captions.
  - Updated demo.
  - New SpeedTest demo.

16 October 2003 - version 1.3.5
  - Fixed incorrect selection synchronization when the Listview loses focus.
  - Fixed drag and drop synchronization, it now correctly fires OnStartDrag,
    OnEndDrag, OnDragDrop when the ViewStyle <> vsxReport.
  - ThumbsCache.Compressed is now defaulted to False, it improves the rendering
    speed performance when the cache is not saved.
  - Added full unicode support for ImageEn lib.
  - LoadGraphic now has support for ImageEn lib.
  - Added ShowXLIcons option to show XL-Icons in vsxThumbs mode (it will only
    work on WinXP).
  - Added ShellExtractExtensionsList to selectively load shell supported
    thumbnails.
    Suppose you only want images + html thumbnails, then you should turn off
    UseShellExtract to disable the extraction of additional shell supported
    files (doc, xls, etc) and then add '.html' to the ShellExtractExtensionsList.
  - Mouse wheel will now scroll by thumbnail height.
  - New IDE component palette icon.
  - Updated Demo.

21 August 2003 - version 1.3.4
  - Fixed incorrect icon arrangement on vsxList mode.
  - Fixed incorrect thumbnail reloading method.

19 June 2003 - version 1.3.3
  - Changed the DefaultStreamVersion of the cache.

18 June 2003 - version 1.3.2
  - Fixed AV when the RootFolder is renamed and the cache saving is activated.
  - Added UseSubsampling property to resize the thumbnails smoothly without loss
    of image quality.
  - Added Compressed property to the Cache options, it activates the on-the-fly
    cache compression system. VELVEx uses JPEG compression because it's the most
    effective compression method for images, the drawback is that there's a loss
    of quality in the thumbnails, if you are looking for the highest quality
    rendering deactivate this property and set UseSubsampling to true.
    Here are some tests on a folder with 200 images (120 x 120 thumbnails):
      No compression: 7205 Kb, 0% compressed
      ZLib: 5002 Kb, 30% compressed
      JPEG: 441 Kb, 94% compressed
  - Lossless Compression for small images.
  - Greatly improved thumbnails rendering speed.
  - Reduced flicker when scrolling.
  - Updated Demo.

23 May 2003 - version 1.3.1
  - Fixed an AV on WinXP, changed SupportsShellExtract.

20 May 2003 - version 1.3
  - Added Stretch property to the thumbnail options, it stretches the thumb
    images to fit the thumbnail size.
  - Fixed incorrect drag image offset, thanks to Jim.
  - Fixed drag images not showing on WinXP, thanks to Jim.
  - Fixed incorrect mouse state when opening the context menu, thanks to Jim.
  - Fixed thumbnail renaming bug, when the file extension was changed the
    thumbnail was not refreshed.
  - Made a workaround of a TListview bug, when the Listview is small enough to
    not fit 2 fully visible items the PageUp/PageDown buttons don't work.
  - Fixed thumbnail creation bug, the images were shrinked if the thumb size was
    higher than the image size.
  - SyncItemsCount was not called when the items were deleted.
  - Fixed Details drawing in Win9x.
  - Fixed a bug in MakeThumbFromFile, TJPEGImage doesn't accepts images with
    1 pixel width or heigth, the minimum size of the thumbnails is now set to 2.
  - Fixed a bug in ValidateListItem, it didn't work for the first node in the
    list.
  - Fixed a bug in the Drag&Drop mechanism, it now doesn't allow to drop in
    the dragged item unless the right button is used for the drag operation
    or when Ctrl, Alt, Shift keys are being pressed.
    The same goes for dropping in the background.
  - Fixed a bug in the Drag&Drop mechanism, it didn't accept items outside
    the listview unless Ctrl, Alt or Shift keys was pressed.
  - Fixed a bug in the thumbnails cache saving mechanism, thanks to Eric Fookes
    for pointing this out.

7 April 2003 - version 1.2
  - The cache is automatically updated when loaded. If an image file was
    changed the thumbnail will be reloaded.
  - Added DetailedHints property to the thumbnail options to show a hint
    including file name, size, date, type, image size, and
    shell icon. ShowHint must be true.
  - Added OnThumbsGetDetails event to set a customized string for the hints
    and thumbnails details.
  - Fixed mem leak in MakeThumbFromFile for using StretchDraw, which is not
    thread safe.
  - Fixed a bug in the Drag&Drop mechanism, now it doesn't allow to drop a file
    if the shell doesn't support it.
  - Fixed the drawing of the multiple Drag&Drop bitmap.
  - Fixed a TListview bug, in virtual mode when the icon arrangement is iaLeft
    the arrow key press are scrambled.
  - The Bevel and Border properties are now correctly synched.
  - Demo updated.

27 February 2003 - version 1.1
  - Added OnThumbThreadClass event, to replace the thumbnail thread with a
    custom one, thanks to Jim for implementing this.
  - Added a new demo to showcase how to create a custom thumbnail thread.
  - Fixed an incorrect parameter in OnThumbsCacheAdd event.

17 February 2003 - version 1.0
  - Added UseShellExtraction property, it is used to let the shell extract and
    create the thumbnail. Jim added support for IExtractImage in the Thumbnails
    thread. HTML files, and most image files and any other format that is
    supported by windows or a shell extension is shown as a thumbnail!
    VELVEx will try to create the thumbnails with the image library, if that
    fails and UseShellExtraction is enabled it will try with the Shell
    IExtractImage interface.
    I decided to leave the image files to the default image library based on
    some tests:
    With a folder of 180 jpg files:
      Windows Explorer (IExtractImage): ~20 secs.
      ACDSee: ~10 secs.
      VELVEx: ~5 secs.
    Cache file size:
      Windows Explorer: ~1000 KB
      ACDSee: unknown
      VELVEx: ~270 KB
  - Regrouped the thumbnails properties into ThumbOptions property
  - Added ValidateListItem public method to get a valid TListitem associated with
    a Node. The obtained ListItem gives you access to its properties and methods,
    which will be sensible to use only when the ViewStyle is not in vsxReport,
    for example:
    var
      L: TListItem;
    begin
      if LVEx.ValidateListItem(LVEx.FocusedNode, L) then
        L.MakeVisible(false);
    end;
  - Added LoadAllAtOnce property to load all the thumbnails at once, like ACDSee.
  - Added ExtensionsExcludeList public property, is a list that contains the
    file extensions that should be excluded from creating the thumbnails.
    This could be helpfull when you don't want the shell to create thumbnails
    for a specific file extension.
  - Added BorderSize property to set the thumbnails border width.
  - Added ShowSmallIcon property to show the file small icon on the top-right border
    of the thumbnails.
  - OnEnter and OnExit events are now triggered correctly.
  - Fixed a bug in the cache deleting method, when AutoLoad was true and the
    thumbnail was reloaded, the cache was getting scrambled.
  - Fixed a bug in the editing method, in Win9x if the Delete key was pressed an
    AV was raised.
  - Fixed a bug in the editing method, when an item was reselected after the
    control was unfocused the item enters in edit mode.
    It's a classic TListview bug.
  - Minor bug fixes.
  - Demo updated.

29 December 2002 - version 0.9.9
  - Fixed minor selection and focus issues, thanks to Boris.

19 December 2002 - version 0.9.8
  - Added a chance to change the items caption via DoGetVETText, thanks to Jim
    for implementing this.
  - Added ThumbsHighlight, ThumbsHighlightColor properties to control the image
    files highlighting.
  - Fixed a bug in TExtensionsList, it was not filled correctly in Delphi 5.
  - Fixed a bug in CreateNewFolder, it was giving an AV when the ViewStyle was
    not vsxReport.
  - Fixed a bug in the painting method, items were not properly blended and cut
    items were not ghosted.
  - Fixed a bug when Align and Constraints were setted at runtime and the
    ViewStyle wasn't vsxReport it didn't worked as expected.

7 December 2002 - version 0.9.7
  - Reworked the cache mechanism, improved thumbnails creation and painting speed.
  - Added new public method for cache cleaning, ThumbsCacheOptions.ClearCache
  - Added new public method for cache item reload, ThumbsCacheOptions.Reload
  - Added new property, ThumbsCacheOptions.CompressionQuality, to control the
    thumbnail compression, default value of 60 (1..100, 1 highest compression
    but lowest quality, 100 lowest compression but highest quality).
  - Updated demo.

1 December 2002 - version 0.9.6
  - Added support for ImageEn (http://www.hicomponents.com) and
    Envision (http://www.intervalsoftware.com) image libraries.

30 November 2002 - version 0.9.5
  - Three new events added:
    OnThumbsCacheAdd: fired when a thumbnail is added to the cache.
    OnThumbsCacheRead: fired when a thumbnail must be read from the cache.
    OnThumbsCacheProcessing: fired when a thumbnail is about to be processed.

11 November 2002 - version 0.9.4
  - Reworked the thumbnail cache to support unicode path names.
  - Reworked the thumbnails creation mechanism to support unicode path names.
    VLVEx can now browse through unicode folders and create the correct
    thumbnails, it is now one of the few thumbnail creation components that
    has full unicode support.

7 November 2002 - version 0.9.3
  - The cache file is now compressed and the size is reduced by 10 times,
    thanks to Gerald Koeder for the tip.
  - Improved the cache management, introduced a new property ThumbsCacheOptions.
  - The cache will now be automatically loaded/saved when
    ThumbsCacheOptions.AutoLoad/AutoSave is true.
  - ThumbWidth and ThumbHeight now reflect the real pixel size of the thumbnail.
  - Updated the demo.

7 October 2002 - version 0.9.2c
  - Hidden files where not ghosted when ViewStyle was not vsxReport.
  - ShellContextSubMenu now works when ViewStyle is not vsxReport.

5 October 2002 - version 0.9.2
  - Fixed a MS Listview control Shift-selection bug.

23 September 2002 - version 0.9.1
  - Improved the thumbnails cache to support comments.

20 September 2002 - version 0.9
  - Implemented a new threading system, thanks to Jim.
  - The thumbnails cache can now be loaded and saved to disk, improved demo to
    show this.

8 September 2002 - version 0.8.3
  - GraphicEx support, thanks to Jim.
  - Fixed a bug in TListview not throwing a Change event when Shift selecting a
    block of items, thanks to Jim.

4 September 2002 - version 0.8.2
  - Fixed a thread bug in D7, thanks to Jim and Gerald.
  - Fixed OnClick and OnDblClick not triggering, thanks to Matthias.

25 August 2002 - version 0.8
  - Greatly improved Listview custom drawing method and fixed all WinXP painting
    issues, thanks to Jim and Bill.
  - Fixed icon arrangement issues.
  - Improved drag image.
  - Improved demo.

17 August 2002 - version 0.7.3
  - Fixed incorrect item column arrangement when the ViewStyle is vsxList or
    vsxSmallIcon, thanks to Jim.
  - Fixed painting issues in WinXP, thanks to Bill Miller.
  - Fixed canvas not invalidated when resizing in WinXP.

12 August 2002 - version 0.7.2
  - Added 2 new properties that allows to show file and image properties in
    vsxThumbs ViewStyle: ThumbDetails and ThumbDetailsHeight.
  - Added ThumbsOnlyBorder property, when true it shows borders only in valid
    image thumbnails when vsxThumbs ViewStyle, otherwise it shows borders for
    all the files and folders.
  - Fixed items arrangement bug in vsxThumbs ViewStyle.
  - Fixed visibility problem when OnEnumFolder is assigned.
  - Fixed no editing mode on mouse click, thanks to Jim.
  - Improved demo.
  - Readme file created for version history, installation and basic user guide.

11 August 2002 - version 0.7.1
  - Fixed no captions in W9x, thanks to Jim,
  - Fixed no captions when the handle is recreated.
  - VirtualExplorerListviewEx doesn't work with ThemeManager version lower
    than 1.9, please download the new version at:
    http://www.delphi-gems.com/ThemeManager.html

9 August 2002 - version 0.7
  - Added unicode support, thanks to Troy Wolbrink:
    http://home.ccci.org/wolbrink/tntmpd/delphi_unicode_controls_project.htm
  - Fixed a positional bug in the child Listview Popupmenu, added ContextMenu
    events notifications, thanks to Jim.
  - Added VETColors support for file caption colors.
  - Improved browse and selection speed (2000 files drag selection in Icon
    viewstyle 30 sec, before it was 55 sec. Win Explorer gets the job done
    in 10 sec... grrr. The problem lies in the CustomDrawing of the M$ Listview,
    it slows everything down, don't know how the heck Win Explorer manages this
    behavior).
19 July 2002 - version 0.6 (Jim Kueneman)
  - Added the long awaited Drag and Drop Support.  Please be careful with this
    as it seems ok but if you delete you hard drive I take no responsibility
    The drag image sucks but I spent all the time on TListview I am going to
    trying to get it to create a better drag image, it won't because of the
    custom draw and no image lists assiged to the control (don't try to assign
    a image list with custom draw either!)
  - Fixed bug with the new FNodeArray when the VT structure change was detected
    and VLVEx called SyncItemsCount.  This method would change the number of
    items in the Listview but did not check to see if FNodeArray was big enough

14 July 2002 - version 0.5.1
  - Fixed Listview visibility bug, thanks to Aaron

4 July 2002 - version 0.5
  - Jim Kuenaman adapted the VET Icon thread, thanks Jim.
  - Implemented a Thumbnails cache to save bitmap handles, thanks to Werner Lehmann.
  - Fixed clipboard, key and mouse sync, thanks to Bill Miller.

30 April 2002 - version 0.4.4
  - Fixed memory leak in DummyImageList creation, thanks to Milan Vandrovec.
  - Added Focus sync, thanks to Bill Miller.

28 April 2002 - version 0.4.2
  - Fixed painting issues in the child VCL Listview on WinXP, woohoo.

16 April 2002 - version 0.4.1
  - Fixed Thread race condition.
  - Fixed file deletion synch.

15 April 2002 - version 0.4
  - Unit and Class name changes to support VSTools RC 1.
  - Created a base class with unpublished properties: TCustomVirtualExplorerListviewEx.
  - Need to lock the canvas of the bitmap in MakeThumbFromFile, odd.

1 April 2002 - version 0.3
  - Improved thread speed, and fixed some bugs.
  - Fixed flicker when changing viewstyles.
  - Added ThumbBorders.
  - Added OnThumbsDrawBefore and OnThumbsDrawAfter event properties.
  - Added SyncRepaint method to force repaint in the child VCL Listview
  - Added GetThumbDrawingBounds method to get the real thumbs drawing bounds,
    instead of the Imagelib size.
  - Removed OnThumbsFilter and added ExtensionsList instead, to improve speed.
  - ThumbSpaceWidth and ThumbSpaceHeight properties now represent the true pixel
    space between thumbnails.

30 March 2002 - version 0.2.1
  - Corrected a bug that caused a lot of flicker when changing dirs.
  - Added BorderStyle, Color, Ctrl3D, Cursor, and Font synchronizing, thanks to
    Bill Miller.
  - Corrected Delphi 4 and 5 package issues, thanks to Jim Kueneman.
  - Corrected Delphi 4 and 5 problems with FListview.SelectAll, thanks to
    Jim Kueneman.

27 March 2002 - version 0.2
  - Corrected Delphi 4 and 5 package issues, thanks to Jim Kueneman.
  - Constraints assignment bug fixed, thanks to Milan Vandrovec.
  - F5, Ctrl+C, Ctrl+V, Ctrl+X and Delete keys implemented.

24 March 2002 - version 0.1
  - Thumbnails implemented.
  - OnDataFind implemented, key navigation for the Listview.
  - Ghosted items painted correctly now.
  - Edit handling implemented, unicode not supported.