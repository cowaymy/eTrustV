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
#editWindow label, input { display:block; }
#editWindow input.text { margin-bottom:10px; width:95%; padding: 0.1em;  }
#editWindow fieldset { padding:0; border:0; margin-top:10px; }
</style>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    // AUIGrid 생성 후 반환 ID
    var listGrid;
    var deGrid;

    // 등록창
    var insDialog;
    // 수정창
    var dialog;
    
    var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "36","codeName": "Closed"}];
    var stockgradecomboData = [{"codeId": "A","codeName": "A"},{"codeId": "B","codeName": "B"}];
    var instockgradecomboData = [{"codeId": "A","codeName": "A"}];
    
    // AUIGrid 칼럼 설정                                                                            visible : false
    var columnLayout = [{dataField:"trnsitid"      ,headerText:"Transit ID"         ,width:"14%" ,height:30 , visible:true},
                        {dataField:"trnsitno"      ,headerText:"Transit No"         ,width:"14%" ,height:30 , visible:true},
                        {dataField:"trnsitdt"      ,headerText:"Transit Date"       ,width:"14%" ,height:30 , visible:true},
                        {dataField:"trnsitfr"      ,headerText:"From"               ,width:"14%" ,height:30 , visible:true},
                        {dataField:"trnsitto"      ,headerText:"To"                 ,width:"14%" ,height:30 , visible:true},
                        {dataField:"trnsitcur"     ,headerText:"Transit Curier"     ,width:"14%" ,height:30 , visible:false},
                        {dataField:"trnsitstusid"  ,headerText:"Status"             ,width:"14%" ,height:30 , visible:false},
                        {dataField:"trnsitstuscd"  ,headerText:"Status"             ,width:"14%" ,height:30 , visible:false},
                        {dataField:"trnsitstusnm"  ,headerText:"Status"             ,width:"14%" ,height:30 , visible:true},
                        {dataField:"crtuserid"     ,headerText:"Create By"          ,width:"14%" ,height:30 , visible:false},
                        {dataField:"crtusernm"     ,headerText:"Create By"          ,width:"14%" ,height:30 , visible:true},
                        {dataField:"trnsitcdt"     ,headerText:"Colse Dt"           ,width:"14%" ,height:30 , visible:false},
                        {dataField:"totitm"        ,headerText:"Total Transfer"     ,width:"16%" ,height:30 , visible:true},
                        {dataField:"totcnt"        ,headerText:"Total Count"        ,width:"14%" ,height:30 , visible:false}
                       ];
    
    //detailGrid
    var detailcolumn = [{dataField:"rnum"      ,headerText:"rnum"               ,width:"14%" ,height:30 , visible:false},
                        {dataField:"sno"       ,headerText:"Type"               ,width:"16%" ,height:30 , visible:true},
                        {dataField:"cdesc"     ,headerText:"Srim No"            ,width:"16%" ,height:30 , visible:true},
                        {dataField:"code"      ,headerText:"Status"             ,width:"16%" ,height:30 , visible:true},
                        {dataField:"ttcd"      ,headerText:"Close Date"         ,width:"16%" ,height:30 , visible:true},
                        {dataField:"uname"     ,headerText:"Update By"          ,width:"16%" ,height:30 , visible:true},
                        {dataField:"stod"      ,headerText:"Update Date"        ,width:"16%" ,height:30 , visible:true},
                        {dataField:"stii"      ,headerText:"Transit Curier"     ,width:"14%" ,height:30 , visible:false},
                        {dataField:"stid"      ,headerText:"Transit No"         ,width:"14%" ,height:30 , visible:false},
                        {dataField:"srsi"      ,headerText:"Transit Date"       ,width:"14%" ,height:30 , visible:false}
                        
                       ];
    var moptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };
    var doptions = {rowIdField : "rnum", showRowCheckColumn : true ,showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };
    var param = "";

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        listGrid   = GridCommon.createAUIGrid("grid_wrap",  columnLayout,"", moptions);
        deGrid     = GridCommon.createAUIGrid("detailGrid", detailcolumn,"", doptions);
        
        $("#detailView").hide();
        
        doDefCombo(comboData, '' ,'sStatus', 'S', ''); // status selected
        
        paramdata = { grade : 'A' , sLoc : ''};
        
        doGetComboData('/common/selectStockLocationList.do', paramdata, 'DSC-CSP','sfrloc', 'S' , '');
        AUIGrid.setGridData(listGrid, []);
        AUIGrid.bind(listGrid, "cellClick", function( event ) 
        {
        });
                
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(listGrid, "cellDoubleClick", function(event) 
        {   $("#trnsitno"  ).text(event.item.trnsitid    );
        	$("#trnsitdt"  ).text(event.item.trnsitdt    );
        	$("#trnsitstus").text(event.item.trnsitstusnm);
        	$("#trnsitby"  ).text(event.item.crtusernm   );
        	$("#closedt"   ).text(event.item.trnsitcdt   );
        	$("#tottrnsit" ).text(event.item.totitm      );
        	$("#location"  ).text(event.item.trnsitfr + ' TO ' + event.item.trnsitto  );
        	$("#courier"   ).text(event.item.trnsitcur   );

            
            $("#showall").find("a").attr("class", "on");
            
            param = "trnsitid="+event.item.trnsitid;
            
            detailSearchAjax(param);
            
            $("#detailView").show();
        });
        
        AUIGrid.bind(listGrid, "updateRow", function(event) {
        });
        
        
        AUIGrid.bind(listGrid, "ready", function(event) {
        	
        	
        });
        
        
        /* 팝업 드래그 start */
        $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
        /* 팝업 드래그 end */

    });

    $(function(){
        $("#loccd").keypress(function(event){
            if (event.which == '13') {
                $("#sUrl").val("/logistics/organization/locationCdSearch.do");
                Common.searchpopupWin("searchForm", "/common/searchPopList.do","location");
            }
        });
        $("#search").click(function(){
        	getListAjax();
        });
        $("#showall > a").click(function(){
        	var param = "trnsitid="+$("#trnsitno").text();
            detailSearchAjax(param);
        });
        $("#showpen > a").click(function(){
        	var param = "trnsitid="+$("#trnsitno").text()+"&statusid=44";
            detailSearchAjax(param);
        });
        $("#showcomp > a").click(function(){
        	var param = "trnsitid="+$("#trnsitno").text()+"&statusid=4";
            detailSearchAjax(param);
        });
        $("#showincom > a").click(function(){
        	var param = "trnsitid="+$("#trnsitno").text()+"&statusid=50";
            detailSearchAjax(param);
        });
    });
    
    function getListAjax() {
    	var url = "/logistics/sirim/selectSirimTransList.do";
    	var param = $("#searchForm").serializeJSON();
    	console.log(param);
    	Common.ajax("POST",url,param,function(result){
    		AUIGrid.setGridData(listGrid, result.data);
        });
    }
    
    function detailSearchAjax(param) {
        var url = "/logistics/sirim/selectSirimToTransit.do";
        Common.ajax("GET",url,param,function(result){
            AUIGrid.setGridData(deGrid, result.data);
        });
    }
     
</script>
</head>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Location</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Location</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">
<input type="hidden" id="sUrl" name="sUrl">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:200px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Transit No</th>
    <td>
    <input type="text" id="strnsitno" name="strnsitno" title="Code" placeholder="Transit No" class="w100p" />
    </td>
    <th scope="row">Transit Status</th>
    <td>
    <select class="w100p" id="sStatus" name="sStatus">
    </select>
    </td>
    <th scope="row">Transfer Warehouse</th>
    <td>
    <select id="sfrloc" class="w100p" name="sfrloc">
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">

    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.ins' /></a></p></li>
    
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->



<div id="detailView" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Sirim Transit Details</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Sirim Transit Details</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
    <tr>
        <th scope="row">Transit No</td>
        <td ID="trnsitno"></td>
        <th scope="row">Transit Date</td>
        <td ID="trnsitdt"></td>
    </tr>
    <tr>
        <th scope="row">Status</td>
        <td ID="trnsitstus"></td>
        <th scope="row">Transit By</td>
        <td ID="trnsitby"></td>            
    </tr>
    <tr>
        <th scope="row">Close Date</td>
        <td ID="closedt"></td>
        <th scope="row">Total Sirim Transit</td>
        <td ID="tottrnsit"></td>
    </tr>
    <tr>
        <th scope="row">Location</td>
        <td ID="location"></td>
       <th scope="row">Courier</td>
        <td ID="courier"></td>
    </tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Sirim To Transit</h2>
</aside><!-- title_line end -->

<section class="tap_wrap mt0"><!-- tap_wrap start -->
<ul class="tap_type1">  
    <li id="showall"><a href="#"> Show All </a></li>
    <li id="showpen"><a href="#"> Only Pending</a></li>
    <li id="showcomp"><a href="#"> Only Complete</a></li>
    <li id="showincom"><a href="#"> Only InComplete</a></li> 
</ul>

<article class="tap_area">
   <div id="detailGrid" height="280px"></div>
</article>
</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->


</section><!-- content end -->

