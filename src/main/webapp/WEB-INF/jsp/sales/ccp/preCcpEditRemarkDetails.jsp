<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    _editor_area = "editorArea";
    _editor_url = "<c:url value='${pageContext.request.contextPath}/resources/htmlarea3.0/'/>";
</script>
<script type="text/javascript" src="<c:url value='${pageContext.request.contextPath}/resources/htmlarea3.0/htmlarea.js'/>"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>

<script>

$(function(){

	HTMLArea.Config = function () {
	    this.version = "3.0";

	    this.width = "auto";
	    this.height = "auto";

	    this.statusBar = false;

	    this.htmlareaPaste = false;

	    this.undoSteps = 20;

	    this.undoTimeout = 500;

	    this.sizeIncludesToolbar = true;

	    this.fullPage = false;

	    this.pageStyle = "";

	    this.killWordOnPaste = true;

	    this.makeLinkShowsTarget = true;

	    this.baseURL = document.baseURI || document.URL;
	    if (this.baseURL && this.baseURL.match(/(.*)\/([^\/]+)/))
	        this.baseURL = RegExp.$1 + "/";

	    this.imgURL = "images/";
	    this.popupURL = "popups/";

	    this.htmlRemoveTags = null;

	    this.toolbar = [
	        [ "fontname", "space",
	          "fontsize", "space",
	          "formatblock", "space",
	          "bold", "italic", "underline", "strikethrough", "separator",
	          "subscript", "superscript", "separator",
	          "copy", "cut", "paste", "space", "undo", "redo", "space", "removeformat" ],


	          [ "justifyleft", "justifycenter", "justifyright", "justifyfull", "separator",
	            "lefttoright", "righttoleft", "separator",
	            "orderedlist", "unorderedlist", "outdent", "indent", "separator",
	            "forecolor", "hilitecolor", "separator"]
	    ];

	    this.fontname = {
	            "굴림":               "굴림, 굴림체",
	            "돋움":               "돋움, 돋움체",
	            "바탕":               "바탕, 바탕체",
	            "궁서":               "궁서, 궁서체",
	        "&mdash; font &mdash;":         '',
	        "Arial":       'arial,helvetica,sans-serif',
	        "Courier New":     'courier new,courier,monospace',
	        "Georgia":     'georgia,times new roman,times,serif',
	        "Tahoma":      'tahoma,arial,helvetica,sans-serif',
	        "Times New Roman": 'times new roman,times,serif',
	        "Verdana":     'verdana,arial,helvetica,sans-serif',
	        "impact":      'impact',
	        "WingDings":       'wingdings'
	    };

	    this.fontsize = {
	        "&mdash; size &mdash;"  : "",
	        "1 (8 pt)" : "1",
	        "2 (10 pt)": "2",
	        "3 (12 pt)": "3",
	        "4 (14 pt)": "4",
	        "5 (18 pt)": "5",
	        "6 (24 pt)": "6",
	        "7 (36 pt)": "7"
	    };

	    this.formatblock = {
	        "&mdash; format &mdash;"  : "",
	        "Heading 1": "h1",
	        "Heading 2": "h2",
	        "Heading 3": "h3",
	        "Heading 4": "h4",
	        "Heading 5": "h5",
	        "Heading 6": "h6",
	        "Normal"   : "p",
	        "Address"  : "address",
	        "Formatted": "pre"
	    };

	    this.customSelects = {};

	    function cut_copy_paste(e, cmd, obj) {
	        e.execCommand(cmd);
	    };

	    this.debug = true;

	    this.btnList = {
	        bold: [ "굵게", "ed_format_bold.gif", false, function(e) {e.execCommand("bold");} ],
	        italic: [ "기울임꼴", "ed_format_italic.gif", false, function(e) {e.execCommand("italic");} ],
	        underline: [ "밑줄", "ed_format_underline.gif", false, function(e) {e.execCommand("underline");} ],
	        strikethrough: [ "취소선", "ed_format_strike.gif", false, function(e) {e.execCommand("strikethrough");} ],
	        subscript: [ "아래로 기입", "ed_format_sub.gif", false, function(e) {e.execCommand("subscript");} ],
	        superscript: [ "위로 기입", "ed_format_sup.gif", false, function(e) {e.execCommand("superscript");} ],
	        justifyleft: [ "텍스트 왼쪽 맞춤", "ed_align_left.gif", false, function(e) {e.execCommand("justifyleft");} ],
	        justifycenter: [ "가운데 맞춤", "ed_align_center.gif", false, function(e) {e.execCommand("justifycenter");} ],
	        justifyright: [ "텍스트 오른쪽 맞춤", "ed_align_right.gif", false, function(e) {e.execCommand("justifyright");} ],
	        justifyfull: [ "양쪽 맞춤", "ed_align_justify.gif", false, function(e) {e.execCommand("justifyfull");} ],
	        orderedlist: [ "번호 매기기", "ed_list_num.gif", false, function(e) {e.execCommand("insertorderedlist");} ],
	        unorderedlist: [ "글머리 기호", "ed_list_bullet.gif", false, function(e) {e.execCommand("insertunorderedlist");} ],
	        outdent: [ "내어쓰기", "ed_indent_less.gif", false, function(e) {e.execCommand("outdent");} ],
	        indent: [ "들여쓰기", "ed_indent_more.gif", false, function(e) {e.execCommand("indent");} ],
	        forecolor: [ "글꼴 색", "ed_color_fg.gif", false, function(e) {e.execCommand("forecolor");} ],
	        hilitecolor: [ "면 색", "ed_color_bg.gif", false, function(e) {e.execCommand("hilitecolor");} ],
	        inserthorizontalrule: [ "선", "ed_hr.gif", false, function(e) {e.execCommand("inserthorizontalrule");} ],
	        createlink: [ "웹링크", "ed_link.gif", false, function(e) {e.execCommand("createlink", true);} ],
	        insertimage: [ "그림 삽입", "ed_image.gif", false, function(e) {e.execCommand("insertimage");} ],
	        inserttable: [ "표", "insert_table.gif", false, function(e) {e.execCommand("inserttable");} ],
	        htmlmode: [ "HTML 태그", "ed_html.gif", true, function(e) {e.execCommand("htmlmode");} ],
	        popupeditor: [ "편집창 크게", "fullscreen_maximize.gif", true, function(e) {e.execCommand("popupeditor");} ],
	        about: [ "정보", "ed_about.gif", true, function(e) {e.execCommand("about");} ],
	        showhelp: [ "참고문서", "ed_help.gif", true, function(e) {e.execCommand("showhelp");} ],
	        undo: [ "뒤로 되돌리기", "ed_undo.gif", false, function(e) {e.execCommand("undo");} ],
	        redo: [ "앞으로 되돌리기", "ed_redo.gif", false, function(e) {e.execCommand("redo");} ],
	        cut: [ "잘라내기", "ed_cut.gif", false, cut_copy_paste ],
	        copy: [ "복사", "ed_copy.gif", false, cut_copy_paste ],
	        paste: [ "붙여넣기", "ed_paste.gif", false, cut_copy_paste ],
	        lefttoright: [ "오른쪽으로 이동", "ed_left_to_right.gif", false, function(e) {e.execCommand("lefttoright");} ],
	        righttoleft: [ "왼쪽으로 이동", "ed_right_to_left.gif", false, function(e) {e.execCommand("righttoleft");} ],
	        removeformat: [ "모든 서식 지우기", "ed_rmformat.gif", false, function(e) {e.execCommand("removeformat");} ],
	        print: [ "인쇄", "ed_print.gif", false, function(e) {e._iframe.contentWindow.print();} ],
	        killword: [ "오피스 태그 지우기", "ed_killword.gif", false, function(e) {e.execCommand("killword");} ]
	    };

	    for (let i in this.btnList) {
	        let btn = this.btnList[i];
	        btn[1] = _editor_url + this.imgURL + btn[1];
	        if (typeof HTMLArea.I18N.tooltips[i] != "undefined") {
	            btn[0] = HTMLArea.I18N.tooltips[i];
	        }
	    }
	};

	HTMLArea.init();
	HTMLArea.onload = initEditor;

	$(".htmlarea").attr("style","width:100%; height:100%;");
	$(".htmlarea .toolbar > table").attr("style","width:100%;");
	$(".htmlarea > iframe").attr("style","border-width: 1px; width:100%;");


	 document.getElementById("editorArea").innerHTML = `${remarkDetails.appvReq}`;

	 document.getElementById('vsave').onclick = (event) => {
	     event.preventDefault()
	     Common.showLoader()
	     fetch("/sales/ccp/editRemarkRequest.do",{
	         method : "POST",
	         headers : {
	             "Content-Type" : "application/json",
	         },
	         body : JSON.stringify({editorId : $("#editorId").val(), editorArea : editor.getHTML().replace(/<p><\/p>/g,"<br/>")})
	     })
	     .then( r=> r.json())
	     .then(
	             data => {
	                 Common.removeLoader()
	                 Common.alert(data.message,fn_reload)
	             }
	      )
	 }
});
</script>

 <div class="popup_wrap size_big">
     <header class="pop_header">
         <h1>${remarkDetails.chsStus} - ${remarkDetails.chsRsn}</h1>
         <ul class="right_opt">
             <li><p class="btn_blue2"><a id="eclose">CLOSE</a></p></li>
         </ul>
     </header>
     <section class="pop_body">
        <input type="hidden" name="editorId"  id="editorId" value="${remarkDetails.remarkId}"/>
          <textarea id="editorArea" name="editorArea" style="width:100%;"></textarea>
        <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="vsave">SAVE</a></p></li>
            </ul>
     </section>
 </div>

