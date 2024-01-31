<map version="freeplane 1.9.13">
<!--To view this file, download free mind mapping software Freeplane from https://www.freeplane.org -->
<node TEXT="Linux System Monitoring" LOCALIZED_STYLE_REF="AutomaticLayout.level.root" FOLDED="false" ID="ID_1090958577" CREATED="1409300609620" MODIFIED="1706689169030" LINK="https://github.com/XceptN/work-track/issues/4"><hook NAME="MapStyle" background="#2e3440">
    <properties show_icon_for_attributes="true" edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff" show_note_icons="true" associatedTemplateLocation="template:/dark_nord_template.mm" followedTemplateLocation="template:/dark_nord_template.mm" followedMapLastTime="1667767402000" fit_to_viewport="false"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ID="ID_671184412" ICON_SIZE="12 pt" FORMAT_AS_HYPERLINK="false" COLOR="#484747" BACKGROUND_COLOR="#eceff4" STYLE="bubble" SHAPE_HORIZONTAL_MARGIN="8 pt" SHAPE_VERTICAL_MARGIN="5 pt" BORDER_WIDTH_LIKE_EDGE="false" BORDER_WIDTH="1.9 px" BORDER_COLOR_LIKE_EDGE="true" BORDER_COLOR="#f0f0f0" BORDER_DASH_LIKE_EDGE="true" BORDER_DASH="SOLID">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#88c0d0" WIDTH="2" TRANSPARENCY="255" DASH="" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_671184412" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<font NAME="SansSerif" SIZE="11" BOLD="false" STRIKETHROUGH="false" ITALIC="false"/>
<edge STYLE="bezier" COLOR="#81a1c1" WIDTH="3" DASH="SOLID"/>
<richcontent CONTENT-TYPE="plain/auto" TYPE="DETAILS"/>
<richcontent TYPE="NOTE" CONTENT-TYPE="plain/auto"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details" BORDER_WIDTH="1.9 px">
<edge STYLE="bezier" COLOR="#81a1c1" WIDTH="3"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#000000" BACKGROUND_COLOR="#ebcb8b">
<icon BUILTIN="clock2"/>
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.floating" COLOR="#484747">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.selection" COLOR="#e5e9f0" BACKGROUND_COLOR="#5e81ac" BORDER_COLOR_LIKE_EDGE="false" BORDER_COLOR="#5e81ac"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="styles.important" ID="ID_779275544" BORDER_COLOR_LIKE_EDGE="false" BORDER_COLOR="#bf616a">
<icon BUILTIN="yes"/>
<arrowlink COLOR="#bf616a" TRANSPARENCY="255" DESTINATION="ID_779275544"/>
<font SIZE="14"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#ffffff" BACKGROUND_COLOR="#484747" STYLE="bubble" SHAPE_HORIZONTAL_MARGIN="10 pt" SHAPE_VERTICAL_MARGIN="10 pt">
<font NAME="Ubuntu" SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#eceff4" BACKGROUND_COLOR="#d08770" STYLE="bubble" SHAPE_HORIZONTAL_MARGIN="8 pt" SHAPE_VERTICAL_MARGIN="5 pt">
<font NAME="Ubuntu" SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#3b4252" BACKGROUND_COLOR="#ebcb8b">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#2e3440" BACKGROUND_COLOR="#a3be8c">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#2e3440" BACKGROUND_COLOR="#b48ead">
<font SIZE="11"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,5" BACKGROUND_COLOR="#81a1c1">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,6" BACKGROUND_COLOR="#88c0d0">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,7" BACKGROUND_COLOR="#8fbcbb">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,8" BACKGROUND_COLOR="#d8dee9">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,9" BACKGROUND_COLOR="#e5e9f0">
<font SIZE="9"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,10" BACKGROUND_COLOR="#eceff4">
<font SIZE="9"/>
</stylenode>
</stylenode>
</stylenode>
</map_styles>
</hook>
<hook NAME="accessories/plugins/AutomaticLayout.properties" VALUE="ALL"/>
<font BOLD="true"/>
<node TEXT="Require env where pcp is available" POSITION="right" ID="ID_1258114593" CREATED="1705661857250" MODIFIED="1705661869517"/>
<node TEXT="Configure pcp" POSITION="right" ID="ID_437397818" CREATED="1705661869946" MODIFIED="1705661874639"/>
<node TEXT="Maybe configure with Grafana" POSITION="right" ID="ID_212149912" CREATED="1705661875089" MODIFIED="1705661884884"/>
<node TEXT="Collect data in CSV format and send to vispeahen" POSITION="right" ID="ID_1206489466" CREATED="1705661885217" MODIFIED="1705661918857"/>
<node TEXT="https://github.com/XceptN/work-track/issues/4" POSITION="left" ID="ID_1552310232" CREATED="1706088042188" MODIFIED="1706689166670" LINK="https://github.com/XceptN/work-track/issues/4"/>
<node TEXT="PCP availability on various distros" POSITION="left" ID="ID_255219827" CREATED="1706690522622" MODIFIED="1706690532680">
<node TEXT="All RHEL compatible ones" ID="ID_284427916" CREATED="1706690534631" MODIFIED="1706690541410"/>
<node TEXT="Ubuntu" ID="ID_311863314" CREATED="1706690541829" MODIFIED="1706690546130"/>
<node TEXT="Debian" ID="ID_1230709484" CREATED="1706690882760" MODIFIED="1706690885110"/>
</node>
<node TEXT="What to Log with PCP" POSITION="left" ID="ID_1289951742" CREATED="1706691168762" MODIFIED="1706691173715">
<node TEXT="CPU" ID="ID_908336688" CREATED="1706691225346" MODIFIED="1706691226182">
<node TEXT="kernel.cpu.util.user" ID="ID_637030391" CREATED="1706691211040" MODIFIED="1706691215791"/>
<node TEXT="kernel.cpu.util.sys" ID="ID_510725285" CREATED="1706691211041" MODIFIED="1706691218190"/>
<node TEXT="kernel.cpu.util.wait" ID="ID_1871221202" CREATED="1706691211043" MODIFIED="1706691220350"/>
<node TEXT="kernel.cpu.util.idle" ID="ID_47052643" CREATED="1706691211044" MODIFIED="1706691222615"/>
<node TEXT="Loadavg" ID="ID_1856317363" CREATED="1706691392779" MODIFIED="1706691396310">
<node TEXT="Compare with Core/Thread count" ID="ID_1338796" CREATED="1706691443621" MODIFIED="1706691454672"/>
</node>
</node>
<node TEXT="Memory" ID="ID_1319295949" CREATED="1706691245771" MODIFIED="1706691247471">
<node TEXT="Virtual Memory" ID="ID_264199300" CREATED="1706691293171" MODIFIED="1706691295071">
<node TEXT="Compare with overall RAM" ID="ID_1405297216" CREATED="1706691458437" MODIFIED="1706691462336"/>
<node TEXT="file buffers" ID="ID_1384594908" CREATED="1706691468860" MODIFIED="1706691471696"/>
<node TEXT="Pagetables" ID="ID_996068389" CREATED="1706691499229" MODIFIED="1706691502655"/>
<node TEXT="cached" ID="ID_1606141735" CREATED="1706691472157" MODIFIED="1706691473795"/>
<node TEXT="Swap" ID="ID_74122135" CREATED="1706691465829" MODIFIED="1706691467697">
<node TEXT="SwapTotal" ID="ID_1083895203" CREATED="1706691508129" MODIFIED="1706691511512"/>
<node TEXT="SwapFree" ID="ID_3883742" CREATED="1706691511892" MODIFIED="1706691513937"/>
</node>
</node>
<node TEXT="SLAB/SLUB" ID="ID_1707196138" CREATED="1706691295368" MODIFIED="1706691307845">
<node TEXT="are these really needed?" ID="ID_284496462" CREATED="1706694632525" MODIFIED="1706694637431"/>
<node TEXT="Not really at first." ID="ID_528623894" CREATED="1706694637948" MODIFIED="1706694641146"/>
</node>
</node>
<node TEXT="I/O" ID="ID_1500765514" CREATED="1706691229699" MODIFIED="1706691231108">
<node TEXT="Free disk spaces" ID="ID_567072272" CREATED="1706691284874" MODIFIED="1706691290208"/>
<node TEXT="I/O rates" ID="ID_525417360" CREATED="1706694702894" MODIFIED="1706694711072">
<node TEXT="r/s" ID="ID_1558105594" CREATED="1706694746185" MODIFIED="1706694749138"/>
<node TEXT="rKB/s" ID="ID_205948518" CREATED="1706694752991" MODIFIED="1706694755445"/>
<node TEXT="w/s" ID="ID_285247805" CREATED="1706694764682" MODIFIED="1706694766414"/>
<node TEXT="wKB/s" ID="ID_1548747837" CREATED="1706694779890" MODIFIED="1706694781564"/>
<node TEXT="%util" ID="ID_917315985" CREATED="1706694782020" MODIFIED="1706694788850"/>
<node TEXT="overall/per-disk" ID="ID_54768485" CREATED="1706694792821" MODIFIED="1706694798218"/>
</node>
</node>
<node TEXT="Network" ID="ID_1396212895" CREATED="1706691235739" MODIFIED="1706691237311">
<node TEXT="Bandwidth Usage" ID="ID_91567600" CREATED="1706691346000" MODIFIED="1706691351487">
<node TEXT="Overall" ID="ID_496068986" CREATED="1706691368675" MODIFIED="1706691371535"/>
<node TEXT="Per interface" ID="ID_319467177" CREATED="1706691365026" MODIFIED="1706691368282"/>
</node>
<node TEXT="Error percentage" ID="ID_1281248416" CREATED="1706691352515" MODIFIED="1706691361576">
<node TEXT="Overall" ID="ID_1300586757" CREATED="1706691368675" MODIFIED="1706691371535"/>
<node TEXT="Per interface" ID="ID_91506490" CREATED="1706691365026" MODIFIED="1706691368282"/>
</node>
</node>
</node>
</node>
</map>
