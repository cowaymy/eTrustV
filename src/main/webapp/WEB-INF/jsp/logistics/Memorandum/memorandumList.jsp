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
<script type="text/javascript" src="<c:url value='${pageContext.request.contextPath}/resources/htmlarea3.0/htmlarea.js'/>"></script>
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
    var columnLayout = [{dataField:"memoid"          ,headerText:"memoid"          ,width:120    ,height:30 , visible:false},
                        {dataField:"memotitle"       ,headerText:"Title"           ,width:250    ,height:30 , visible:true},
                        {dataField:"memocntnt"       ,headerText:"memocntnt"       ,width:350    ,height:30 , visible:false},
                        {dataField:"stusid"          ,headerText:"Status Code"     ,width:140    ,height:30 , visible:false},
                        {dataField:"stuscode"        ,headerText:"Status Code"     ,width:140    ,height:30 , visible:false},
                        {dataField:"stusname"        ,headerText:"Status Code"     ,width:140    ,height:30 , visible:true},
                        {dataField:"crtdt"           ,headerText:"Create Date"         ,width:140    ,height:30 , visible:true},
                        {dataField:"fcrtdt"          ,headerText:"Creator"         ,width:140    ,height:30 , visible:false},
                        {dataField:"crtuserid"       ,headerText:"Creator"         ,width:140    ,height:30 , visible:false},
                        {dataField:"crtusernm"       ,headerText:"Creator"         ,width:140    ,height:30 , visible:true},
                        {dataField:"upddt"           ,headerText:"Creator"         ,width:140    ,height:30 , visible:false},
                        {dataField:"fupddt"          ,headerText:"Creator"         ,width:140    ,height:30 , visible:false},
                        {dataField:"upduserid"       ,headerText:"Creator"         ,width:140    ,height:30 , visible:false},
                        {dataField:"updusernm"       ,headerText:"Creator"         ,width:140    ,height:30 , visible:false},
                        {dataField:"staffmemo"       ,headerText:"Staff"           ,width:140    ,height:30 , visible:true
                            , renderer : 
                            {
                                type : "CheckBoxEditRenderer",
                                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                                checkValue : "1", // true, false 인 경우가 기본
                                unCheckValue : ""
                            }
                        },
                        {dataField:"codymemo"        ,headerText:"Cody"        ,width:140    ,height:30 , visible:true
                            , renderer : 
                            {
                                type : "CheckBoxEditRenderer",
                                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                                checkValue : "1", // true, false 인 경우가 기본
                                unCheckValue : ""
                                
                            }     
                        },
                        {dataField:"hpmemo"          ,headerText:"HP"           ,width:140    ,height:30 , visible:true
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
            	
            });
        });
    	$("#update").click(function(){
    		
    		$("#editwindow").show();
    		
    		var selectedItems = AUIGrid.getSelectedItems(listGrid);
            var itm = selectedItems[0].item;
            
            $("#vmode").val("upd");
            $("#etitle").val(itm.memotitle);
            $("#hedtor").val(itm.memocntnt);
            $("#memoid").val(itm.memoid);
            
            if (itm.staffmemo == 1){
            	$("#staffmemo").attr("checked" , true);
            }else{
            	$("#staffmemo").attr("checked" , false);
            }
            if (itm.codymemo == 1){
                $("#codymemo").attr("checked" , true);
            }else{
                $("#codymemo").attr("checked" , false);
            }
            if (itm.hpmemo == 1){
                $("#hpmemo").attr("checked" , true);
            }else{
                $("#hpmemo").attr("checked" , false);
            }

            //$(".htmlarea > iframe").attr("style","border-width: 1px; width:615px; height: 400px;");
            $(".htmlarea > iframe").attr("style","border-width: 1px; width:100%; height:100%;");
			editor.setHTML("");
			editor.insertHTML(itm.memocntnt);
            
        });
    	$("#insert").click(function(){
    		$("#hedtor").val('');
    		$("#memoid").val('');
    		$("#staffmemo").attr("checked" , false);
    		$("#codymemo").attr("checked" , false);
    		$("#hpmemo").attr("checked" , false);
    		editor.setHTML("");
    		$("#editwindow").show();
    		//$(".htmlarea > iframe").attr("style","border-width: 1px; width:615px; height: 400px;");
    		$(".htmlarea > iframe").attr("style","border-width: 1px; width:100%; height:100%;");
    		
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
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <%-- <li><p class="btn_grid"><a id="delete"><spring:message code='sys.btn.del' /></a></p></li> --%>
    <li><p class="btn_grid"><a id="update"><spring:message code='sys.btn.update' /></a></p></li>
    <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.add' /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" class="mt10" style="height:430px"></div>
</article><!-- grid_wrap end -->

</section>

<div class="popup_wrap" id="viewwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle">MEMO RANDUM VIEW</h1>
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
                    <td id="vmemo" colspan="4"></td>
                </tr>
            </tbody>
            </table>
        
           <!--  <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="vclose">CLOSE</a></p></li> 
            </ul> -->
            </form>
        
        </section>
    </div>
    <div class="popup_wrap" id="editwindow"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle">MEMO RANDUM EDIT</h1>
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
                    <td colspan="3"><input type="text" id="etitle" name="etitle" value=""></td>    
                </tr>
                <tr>    
                    <th scope="row">Memo Viewer</th>
                    <td id="vtitle" colspan="3">
                        <label><input type="checkbox" id='staffmemo' name='staffmemo'/><span> Staff Memo </span></label>
                        <label><input type="checkbox" id='codymemo'  name='codymemo'/><span> Cody Memo </span></label>
                        <label><input type="checkbox" id='hpmemo'    name='hpmemo'/><span> Hp Memo</span></label>
                    </td>
                </tr>
                <tr>    
                    <td id="ememo" colspan="4"><textarea id="editorArea" name="editorArea" cols="75" rows="14" style="width:100%; height:400px"></textarea></td>
                </tr>
            </tbody>
            </table>
        
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="vsave">SAVE</a></p></li> 
            </ul>
            </form>
        
        </section>
    </div>
</section>    