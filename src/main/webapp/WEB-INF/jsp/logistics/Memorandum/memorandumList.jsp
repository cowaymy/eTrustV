<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}


#editWindow {
    font-size:13px;
}
#editWindow label, input {}
#editWindow input.text { margin-bottom:10px; width:95%; padding: 0.1em;  }
#editWindow fieldset { padding:0; border:0; margin-top:10px; }
</style>
<!-- EDITOR -->
<script type="text/javaScript" language="javascript">
    _editor_area = "editorArea";        //  -> 페이지에 웹에디터가 들어갈 위치에 넣은 textarea ID
    _editor_url = "<c:url value='${pageContext.request.contextPath}/resources/htmlarea3.0/'/>";
</script>
<script type="text/javascript" src="<c:url value='${pageContext.request.contextPath}/resources/htmlarea3.0/htmlarea.js'/>">
</script>
<!-- EDITOR -->
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    // AUIGrid 생성 후 반환 ID
    var listGrid;
    var detailGrid;
    // 등록창
    var insdialog;
    // 수정창
    var dialog;
    var itemdata;

    // AUIGrid 칼럼 설정             // formatString : "mm/dd/yyyy",    dataType:"numeric", formatString : "#,##0"
var columnLayout = [{dataField: "memoid",headerText :"<spring:message code='log.head.memoid'/>"           ,width:120    ,height:30 , visible:false},
							{dataField: "memotitle",headerText :"<spring:message code='log.head.title'/>"              ,width:250    ,height:30 , visible:true},
							{dataField: "memocntnt",headerText :"<spring:message code='log.head.memocntnt'/>"          ,width:350    ,height:30 , visible:false},
							{dataField: "stusid",headerText :"<spring:message code='log.head.statuscode'/>"      ,width:140    ,height:30 , visible:false},
							{dataField: "stuscode",headerText :"<spring:message code='log.head.statuscode'/>"        ,width:140    ,height:30 , visible:false},
							{dataField: "stusname",headerText :"<spring:message code='log.head.statuscode'/>"        ,width:140    ,height:30 , visible:false},
							{dataField: "crtdt",headerText :"<spring:message code='log.head.createdate'/>"           ,width:140    ,height:30 , visible:true},
							{dataField: "fcrtdt",headerText :"<spring:message code='log.head.creator'/>"             ,width:140    ,height:30 , visible:false},
							{dataField: "crtuserid",headerText :"<spring:message code='log.head.creator'/>"          ,width:140    ,height:30 , visible:false},
							{dataField: "crtusernm",headerText :"<spring:message code='log.head.creator'/>"          ,width:140    ,height:30 , visible:true},
							{dataField: "department",headerText :"<spring:message code='log.head.department'/>"          ,width:170    ,height:30 , visible:true},
							{dataField: "upddt",headerText :"<spring:message code='log.head.creator'/>"          ,width:140    ,height:30 , visible:false},
							{dataField: "fupddt",headerText :"<spring:message code='log.head.creator'/>"             ,width:140    ,height:30 , visible:false},
							{dataField: "upduserid",headerText :"<spring:message code='log.head.creator'/>"          ,width:140    ,height:30 , visible:false},
							{dataField: "updusernm",headerText :"<spring:message code='log.head.creator'/>"          ,width:140    ,height:30 , visible:false},
							{dataField: "staffmemo",headerText :"<spring:message code='log.head.staff'/>"              ,width:140    ,height:30 , visible:true
                            , renderer :
                            {
                                type : "CheckBoxEditRenderer",
                                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                                checkValue : "1", // true, false 인 경우가 기본
                                unCheckValue : ""
                            }
                        },
                        {dataField:  "codymemo",headerText :"<spring:message code='log.head.cody'/>"         ,width:140    ,height:30 , visible:true
                            , renderer :
                            {
                                type : "CheckBoxEditRenderer",
                                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                                checkValue : "1", // true, false 인 경우가 기본
                                unCheckValue : ""

                            }
                        },
                        {dataField: "hpmemo",headerText :"<spring:message code='log.head.hp'/>"            ,width:140    ,height:30 , visible:true
                            , renderer :
                            {
                                type : "CheckBoxEditRenderer",
                                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                                checkValue : "1", // true, false 인 경우가 기본
                                unCheckValue : ""


                            }

                        },
                        {dataField:  "htmemo",headerText :"<spring:message code='log.head.ht'/>"         ,width:140    ,height:30 , visible:true
                            , renderer :
                            {
                                type : "CheckBoxEditRenderer",
                                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                                checkValue : "1", // true, false 인 경우가 기본
                                unCheckValue : ""

                            }
                        }
                       ];

    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false , fixedColumnCount:2};


    $(document).ready(function(){
    	HTMLArea.init();
        HTMLArea.onload = initEditor;

        doGetCombo('/services/tagMgmt/selectMainDept.do', '' , '', 'listDept' , 'S', '');

     	$("#editwindow").hide();

        // masterGrid 그리드를 생성합니다.
        listGrid = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);

        AUIGrid.bind(listGrid, "cellClick", function( event )
        {
        });

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(listGrid, "cellDoubleClick", function(event)
        {
        	$("#viewwindow").show();
        	var itm = event.item;
        	$("#vtitle").html(itm.memotitle);
        	$("#vcrtnm").html(itm.crtusernm);
        	$("#vcrtdt").html(itm.fcrtdt);
        	$("#vupdnm").html(itm.updusernm);
        	$("#vupddt").html(itm.upddt);
        	$("#vmemo").html(itm.memocntnt);

        });

        AUIGrid.bind(listGrid, "ready", function(event) {

        });

        //SearchListAjax();
    });

    $(function(){
    	$("#search").click(function(){
    		SearchListAjax();
    	});
    	$("#clear").click(function(){
    		$("#searchForm")[0].reset();
    	});
    	$("#vclose").click(function(){
    		$("#viewwindow").hide();
        });
    	$("#eclose").click(function(){
            $("#editwindow").hide();
        });
    	$("#vsave").click(function(){
            //$("#viewwindow").hide();
            $("#hedtor").val(editor.getHTML());
            var param = $("#edForm").serializeJSON();

            var selectedItem = AUIGrid.getSelectedIndex(listGrid);

            Common.ajax("POST", "/logistics/memorandum/memoSave.do", param, function (result) {

            	if (result.data != null){
            		AUIGrid.updateRow(listGrid, result.data, selectedItem[0]);
            		AUIGrid.resetUpdatedItems(listGrid, "all");
            	}

            	$("#editwindow").hide();
            	SearchListAjax();
            });
        });
    	$("#vdelete").click(function(){

            var selectedItem = AUIGrid.getSelectedIndex(listGrid);
            var memo=AUIGrid.getCellValue(listGrid, selectedItem[0], "memoid");
            var param ={memoid:memo };
            Common.ajax("GET", "/logistics/memorandum/memoDelete.do", param, function (result) {
            	$("#editwindow").hide();
            	 SearchListAjax();

            });
        });
    	$("#update").click(function(){
    		var selectIndex = AUIGrid.getSelectedIndex(listGrid);
    		if(selectIndex[0]<0){
    			Common.alert("Please Select data.");
    			return false;
    		}
    		$("#dataTitle2").text("Memorandum Edit");
    		$("#editwindow").show();
            $("#vdelete").show();

    		var selectedItems = AUIGrid.getSelectedItems(listGrid);
            var itm = selectedItems[0].item;

            $("#vmode").val("upd");
            $("#etitle").val(itm.memotitle);
            $("#hedtor").val(itm.memocntnt);
            $("#memoid").val(itm.memoid);

            if (itm.staffmemo == 1){
            	$("#staffmemo").prop("checked" , true);
            }else{
            	$("#staffmemo").prop("checked" , false);
            }
            if (itm.codymemo == 1){
                $("#codymemo").prop("checked" , true);
            }else{
                $("#codymemo").prop("checked" , false);
            }
            if (itm.hpmemo == 1){
                $("#hpmemo").prop("checked" , true);
            }else{
                $("#hpmemo").prop("checked" , false);
            }
            if (itm.htmemo == 1){
                $("#htmemo").prop("checked" , true);
            }else{
                $("#htmemo").prop("checked" , false);
            }

            //TODO : 추후 퍼블리싱 해결 해야함
            $(".htmlarea").attr("style","width:100%; height:100%;");
            $(".htmlarea .toolbar > table").attr("style","width:100%;");
            $(".htmlarea > iframe").attr("style","border-width: 1px; width:100%;");
			editor.setHTML("");
			editor.insertHTML(itm.memocntnt);

        });
    	$("#insert").click(function(){
    		$("#vdelete").hide();
    		$("#hedtor").val('');
    		$("#memoid").val('');
    		$("#staffmemo").attr("checked" , false);
    		$("#codymemo").attr("checked" , false);
    		$("#hpmemo").attr("checked" , false);
    		$("#htmemo").attr("checked" , false);
    		editor.setHTML("");
    		$("#editwindow").show();
    		$("#dataTitle2").text("Memorandum New");
            //TODO : 추후 퍼블리싱 해결 해야함
            $(".htmlarea").attr("style","width:100%; height:100%;");
    		$(".htmlarea .toolbar > table").attr("style","width:100%;");
    		$(".htmlarea .toolbar > table > tr").attr("style","width:100%;");
    		$(".htmlarea > iframe").attr("style","border-width: 1px; width:100%;");

    		$("#vmode").val("ins");

        });
    });

    function SearchListAjax() {

        var url = "/logistics/memorandum/memoSearchList.do";
        var param = $('#searchForm').serializeJSON();
        Common.ajax("POST" , url , param , function(data){
            AUIGrid.setGridData(listGrid, data.data);

        });
    }
</script>

<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Memorandum</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Memorandum</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
     <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Title</th>
    <td><input type="text" id="stitle" name="stitle" class="w100p"/></td>
    <th scope="row">Creator</th>
    <td><input type="text" id="screator" name="screator" class="w100p"/></td>
    <th scope="row">Create Date</th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
        <p><input id="crtsdt" name="crtsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>
        <span>To</span>
        <p><input id="crtedt" name="crtedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date "></p>
        </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Department </th>
    <td><select id="listDept" name="listDept" class="w100p"></select></td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
<ul class="right_btns">
    <%-- <li><p class="btn_grid"><a id="delete"><spring:message code='sys.btn.del' /></a></p></li> --%>
    <li><p class="btn_grid"><a id="update"><spring:message code='sys.btn.update' /></a></p></li>
    <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.add' /></a></p></li>
</ul>
</c:if>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" class="mt10" style="height:430px"></div>
</article><!-- grid_wrap end -->

</section>

<div class="popup_wrap" id="viewwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle">MEMORANDUM VIEW</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->

        <section class="pop_body"><!-- pop_body start -->
            <form id="grForm" name="grForm" method="POST">
            <table class="type1">
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:180px" />
                <col style="width:*" />
               <!--  <col style="width:30px" /> -->
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Title</th>
                    <td id="vtitle" colspan="2"></td>
                   <td align="right"><div class="search_100p" align="right"><input name="pdf" type="button" value="PDF" /></div></td>
                </tr>
                <tr>
                    <th scope="row">Creator</th>
                    <td id="vcrtnm"></td>
                    <th scope="row">Create Date</th>
                    <td id="vcrtdt"></td>
                </tr>
                <tr>
                    <th scope="row">Updator</th>
                    <td id="vupdnm"></td>
                    <th scope="row">Update Date</th>
                    <td id="vupddt" ></td>
                </tr>
                <tr>
                    <td colspan="4"><span id="vmemo"></span></td>
                </tr>
            </tbody>
            </table>

           <!--  <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="vclose">CLOSE</a></p></li>
            </ul> -->
            </form>

        </section>
    </div>
    <div class="popup_wrap size_big" id="editwindow"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle2"></h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a id="eclose">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->

        <section class="pop_body"><!-- pop_body start -->
            <form id="edForm" name="edForm" method="POST">
            <input type="hidden" name="vmode"  id="vmode" />
            <input type="hidden" name="hedtor" id="hedtor" />
            <input type="hidden" name="memoid" id="memoid" />
            <table class="type1">
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Title</th>
                    <td colspan="3"><input type="text" id="etitle" name="etitle" value="" class="w100p"></td>
                </tr>
                <tr>
                    <th scope="row">Memo Viewer</th>
                    <td id="vtitle" colspan="3">
                        <label><input type="checkbox" id='staffmemo' name='staffmemo'/><span> Staff Memo </span></label>
                        <label><input type="checkbox" id='codymemo'  name='codymemo'/><span> Cody Memo </span></label>
                        <label><input type="checkbox" id='hpmemo'    name='hpmemo'/><span> Hp Memo</span></label>
                        <label><input type="checkbox" id='htmemo'    name='htmemo'/><span> HT Memo</span></label>
                    </td>
                </tr>
            </tbody>
            </table>
              <textarea id="editorArea" name="editorArea" style="width:100%;"></textarea>
              <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="vsave">SAVE</a></p></li>
                <li><p class="btn_blue2 big"><a id="vdelete">DELETE</a></p></li>
            </ul>
            </form>

        </section>
    </div>
</section>