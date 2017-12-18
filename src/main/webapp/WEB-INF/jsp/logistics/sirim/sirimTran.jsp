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
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    // AUIGrid 생성 후 반환 ID
    var listGrid;
    var deGrid;
    var itmGrid;
    var updGrid;

    // 등록창
    var insDialog;
    // 수정창
    var dialog;
    
    var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "36","codeName": "Closed"}];
    var stockgradecomboData = [{"codeId": "A","codeName": "A"},{"codeId": "B","codeName": "B"}];
    var instockgradecomboData = [{"codeId": "A","codeName": "A"}];
    
    // AUIGrid 칼럼 설정                                                                            visible : false
var columnLayout = [{dataField: "trnsitid",headerText :"<spring:message code='log.head.transitid'/>"             ,width:    "14%"    ,height:30 , visible:true},                
							{dataField: "trnsitno",headerText :"<spring:message code='log.head.transitno'/>"             ,width:    "14%"    ,height:30 , visible:true},                
							{dataField: "trnsitdt",headerText :"<spring:message code='log.head.transitdate'/>"         ,width:  "14%"    ,height:30 , visible:true},                
							{dataField: "trnsitfr",headerText :"<spring:message code='log.head.from'/>"                ,width:  "14%"    ,height:30 , visible:true},                
							{dataField: "trnsitto",headerText :"<spring:message code='log.head.to'/>"                    ,width:    "14%"    ,height:30 , visible:true},                
							{dataField: "trnsitcur",headerText :"<spring:message code='log.head.transitcurier'/>"        ,width:    "14%"    ,height:30 , visible:false},               
							{dataField: "curiername",headerText :"<spring:message code='log.head.transitcurier'/>"       ,width:    "14%"    ,height:30 , visible:false},               
							{dataField: "trnsitstusid",headerText :"<spring:message code='log.head.status'/>"                ,width:    "14%"    ,height:30 , visible:false},               
							{dataField: "trnsitstuscd",headerText :"<spring:message code='log.head.status'/>"                ,width:    "14%"    ,height:30 , visible:false},               
							{dataField: "trnsitstusnm",headerText :"<spring:message code='log.head.status'/>"                ,width:    "14%"    ,height:30 , visible:true},                
							{dataField: "crtuserid",headerText :"<spring:message code='log.head.createby'/>"              ,width:   "14%"    ,height:30 , visible:false},               
							{dataField: "crtusernm",headerText :"<spring:message code='log.head.createby'/>"              ,width:   "16%"    ,height:30 , visible:true},                
							{dataField: "trnsitcdt",headerText :"<spring:message code='log.head.colsedt'/>"            ,width:  "14%"    ,height:30 , visible:false},               
							{dataField: "totitm",headerText :"<spring:message code='log.head.totaltransfer'/>"       ,width:    "16%"    ,height:30 , visible:true},                
							{dataField: "totcnt",headerText :"<spring:message code='log.head.totalcount'/>"         ,width: "14%"    ,height:30 , visible:false} 
                       ];
    
    //detailGrid
var detailcolumn = [{dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>"                ,width:  "14%"    ,height:30 , visible:false},               
							{dataField: "sno",headerText :"<spring:message code='log.head.type'/>"                 ,width:  "16%"    ,height:30 , visible:true},                
							{dataField: "cdesc",headerText :"<spring:message code='log.head.srimno'/>"              ,width: "16%"    ,height:30 , visible:true},                
							{dataField: "code",headerText :"<spring:message code='log.head.status'/>"                ,width:    "16%"    ,height:30 , visible:true},                
							{dataField: "ttcd",headerText :"<spring:message code='log.head.closedate'/>"             ,width:    "16%"    ,height:30 , visible:true},                
							{dataField: "uname",headerText :"<spring:message code='log.head.updateby'/>"              ,width:   "16%"    ,height:30 , visible:true},                
							{dataField: "stod",headerText :"<spring:message code='log.head.updatedate'/>"           ,width: "16%"    ,height:30 , visible:true},                
							{dataField: "stii",headerText :"<spring:message code='log.head.transitcurier'/>"         ,width:    "14%"    ,height:30 , visible:false},               
							{dataField: "stid",headerText :"<spring:message code='log.head.transitno'/>"             ,width:    "14%"    ,height:30 , visible:false},               
							{dataField: "srsi",headerText :"<spring:message code='log.head.transitdate'/>"         ,width:  "14%"    ,height:30 , visible:false}
                        
                       ];
    
  //detailGrid
var itmcolumn    = [{dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>"               ,width:   "33%"    ,height:30 , visible:false},               
							{dataField: "sno",headerText :"<spring:message code='log.head.sirimno'/>"             ,width:   "33%"    ,height:30 , visible:true},                
							{dataField: "stid",headerText :"<spring:message code='log.head.type'/>"               ,width:   "33%"    ,height:30 , visible:false},               
							{dataField: "stnm",headerText :"<spring:message code='log.head.type'/>"               ,width:   "33%"    ,height:30 , visible:true},                
							{dataField: "sloc",headerText :"<spring:message code='log.head.location'/>"           ,width:   "34%"    ,height:30 , visible:true},                
							{dataField: "sqty",headerText :"<spring:message code='log.head.qty'/>"                 ,width:  "16%"    ,height:30 , visible:false}
                        
                       ];
var updcolumn    = [{dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>"                ,width:  "14%"    ,height:30 , visible:false},               
                    {dataField: "cdesc",headerText :"<spring:message code='log.head.type'/>"                   ,width:  "15%"    ,height:30 , visible:true},                
                    {dataField: "sno",headerText :"<spring:message code='log.head.srimno'/>"                ,width: "15%"    ,height:30 , visible:true},                
                    {dataField: "code",headerText :"<spring:message code='log.head.status'/>"                ,width:    "12%"    ,height:30 , visible:true},                
                    {dataField: "ttcd",headerText :"<spring:message code='log.head.closedate'/>"             ,width:    "13%"    ,height:30 , visible:true},                
                    {dataField: "uname",headerText :"<spring:message code='log.head.updateby'/>"              ,width:   "13%"    ,height:30 , visible:true},                
                    {dataField: "stod",headerText :"<spring:message code='log.head.updatedate'/>"           ,width: "13%"    ,height:30 , visible:true},                
                     {dataField:    "stii",headerText :"<spring:message code='log.head.transitcurier'/>"         ,width:    "14%"    ,height:30 , visible:false},               
                     {dataField:    "stid",headerText :"<spring:message code='log.head.transitno'/>"             ,width:    "14%"    ,height:30 , visible:false},               
                     {dataField:    "srsi",headerText :"<spring:message code='log.head.transitdate'/>"         ,width:  "14%"    ,height:30 , visible:false},       
                        {
                            dataField : "undefined",
                            headerText : "",
                            renderer : {
                                type : "ButtonRenderer",
                                labelText : "Remove",
                                onclick : function(rowIndex, columnIndex, value, item) {
                                    f_remove(item);
                                }
                            }
                        }
                       ];
  
    var moptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };
    var doptions = {rowIdField : "rnum", showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };
    var ioptions = {showStateColumn : false , editable : false, useGroupingPanel : false , usePaging : false };
    var param = "";

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        listGrid   = GridCommon.createAUIGrid("grid_wrap"  ,  columnLayout ,"", moptions);
        deGrid     = GridCommon.createAUIGrid("detailGrid" ,  detailcolumn ,"", doptions);
        itmGrid    = GridCommon.createAUIGrid("itemGrid"   ,  itmcolumn    ,"", ioptions);
        updGrid    = GridCommon.createAUIGrid("updGrid"    ,  updcolumn    ,"", doptions);
        
        $("#detailView").hide();
        $("#newView").hide();
        $("#updView").hide();
        
        doDefCombo(comboData, '' ,'sStatus', 'S', ''); // status selected
        
        paramdata = { grade : 'A' , sLoc : ''}; // sloc : session location cd
        
        doGetComboData('/common/selectStockLocationList.do', paramdata, 'DSC-CSP','sfrloc', 'S' , '');
        
        paramdata = { grade : 'A' , sLoc : '' , brnch : 42}; // brnch : session branchid
        doGetComboData('/common/selectStockLocationList.do', paramdata, '','nfrloc', 'S' , '');
        
        paramdata = { grade : 'B' , sLoc : '' , equv : 'N'};
        doGetComboData('/common/selectStockLocationList.do', paramdata, '','ntoloc', 'S' , '');

        paramdata = {};
        doGetComboData('/logistics/courier/selectCourierComboList.do', paramdata, '','ncourier', 'S' , '');
        
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
            
            detailSearchAjax("/logistics/sirim/selectSirimToTransit.do" , param , deGrid);
            
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
        $("#clear").click(function(){
        	$("#searchForm")[0].reset();
        });
        $("#showall > a").click(function(){
        	var param = "trnsitid="+$("#trnsitno").text();
            detailSearchAjax("/logistics/sirim/selectSirimToTransit.do" , param , deGrid);
        });
        $("#showpen > a").click(function(){
        	var param = "trnsitid="+$("#trnsitno").text()+"&statusid=44";
            detailSearchAjax("/logistics/sirim/selectSirimToTransit.do" , param , deGrid);
        });
        $("#showcomp > a").click(function(){
        	var param = "trnsitid="+$("#trnsitno").text()+"&statusid=4";
            detailSearchAjax("/logistics/sirim/selectSirimToTransit.do" , param , deGrid);
        });
        $("#showincom > a").click(function(){
        	var param = "trnsitid="+$("#trnsitno").text()+"&statusid=50";
            detailSearchAjax("/logistics/sirim/selectSirimToTransit.do" , param , deGrid);
        });
        $("#updall > a").click(function(){
            var param = "trnsitid="+$("#utrnsitno").text();
            detailSearchAjax("/logistics/sirim/selectSirimToTransit.do" , param , updGrid);
        });
        $("#updpen > a").click(function(){
            var param = "trnsitid="+$("#utrnsitno").text()+"&statusid=44";
            detailSearchAjax("/logistics/sirim/selectSirimToTransit.do" , param , updGrid);
        });
        $("#updcomp > a").click(function(){
            var param = "trnsitid="+$("#utrnsitno").text()+"&statusid=4";
            detailSearchAjax("/logistics/sirim/selectSirimToTransit.do" , param , updGrid);
        });
        $("#updincom > a").click(function(){
            var param = "trnsitid="+$("#utrnsitno").text()+"&statusid=50";
            detailSearchAjax("/logistics/sirim/selectSirimToTransit.do" , param , updGrid);
        });
        $("#newtran").click(function(){
        	$("#newView").show();
        });
        $("#updbtn").click(function(){
            if(updValidatChk()){
        	    Common.ajax("POST","/logistics/sirim/doUpdateSirimTransit.do",$("#updForm").serializeJSON(),function(result){
                	Common.alert('Transit info successfully updated.');
                	getListAjax();
                },function (result){
                	Common.alert('Failed to update sirim transit info. Please try again later.');
                });
                
            }else{
            	return false;
            }
        });
        $("#updtran").click(function(){
        	var selectedItems = AUIGrid.getSelectedItems(listGrid);
        	
        	if (selectedItems.length > 0){
        		param = "trnsitid="+selectedItems[0].item.trnsitid;
        		
        		Common.ajax("GET","/logistics/sirim/selectSirimModDetail.do",param,function(result){
        			
        			$("#utrnsitno"  ).text(result.data[0].stn    );
                    $("#utrnsitdt"  ).text(result.data[0].std    );
                    //$("#utrnsitstus").text(result.data[0].tsn    );
                    $("#utrnsitby"  ).text(result.data[0].sun    );
                    $("#utottrnsit" ).text(result.data[0].tti      );
                    $("#ulocation"  ).text(result.data[0].stf + ' TO ' + result.data[0].stt  );
                    
                    $("#updall").find("a").attr("class", "on");
                    if (result.data[0].stsi != '1'){
                    	$("#updbutton").hide();
                    }
                    var cparam ={};
                    doGetComboData('/logistics/courier/selectCourierComboList.do', cparam, result.data[0].stc,'ucourier', 'S' , '');
                    
                    var scomboData = [{"codeId": "1","codeName": "Active"},{"codeId": "8","codeName": "Deactivate"}];
                    doDefCombo(scomboData, result.data[0].stsi ,'utrnsitstus', 'S', ''); // status selected
                    
                    $('#hupdstatus').val(result.data[0].stsi);
                    $('#hupdcur'   ).val(result.data[0].stc);
                    $('#hsrsi'     ).val(result.data[0].stsi);
                    $('#htranid'   ).val(result.data[0].sti);
                });
        		
                
        		
                detailSearchAjax("/logistics/sirim/selectSirimToTransit.do" , param , updGrid);
                
                $("#updView").show();
        	}else{
        		Common.alert('Please Selected Grid Data');
        	}
        	
        });
        $(".numberAmt").keyup(function(e) {
            //regex = /^[0-9]+(\.[0-9]+)?$/g;
            regex = /[^.0-9]/gi;

            v = $(this).val();
            if (regex.test(v)) {
                var nn = v.replace(regex, '');
                $(this).val(v.replace(regex, ''));
                $(this).focus();
                return;
            }
        });
    });
    
    function getListAjax() {
    	var url = "/logistics/sirim/selectSirimTransList.do";
    	var param = $("#searchForm").serializeJSON();
    	
    	Common.ajax("POST",url,param,function(result){
    		AUIGrid.setGridData(listGrid, result.data);
        });
    }
    
    function detailSearchAjax(url ,param , grid) {
        
        Common.ajax("GET",url,param,function(result){
            AUIGrid.setGridData(grid, result.data);
        });
    }
    
    function getSirim(){
    	if ($("#getsirim").text() == "Re Key"){
    		$("#getsirim").text("Get Sirim");
    		$("#ntoloc").attr("disabled" , false);
            $("#ncourier").attr("disabled" , false);
            $("#nfrloc").attr("disabled" , false);
            $("#nprefix").val();
            $("#nprefix").attr("readonly" , false);
            $("#nsirimfr").val();
            $("#nsirimfr").attr("readonly" , false);
            $("#nqty").val();
            $("#nqty").attr("readonly" , false);
            $("#nsirimto").val();
            $("#nsirimto").attr("readonly" , true);
    	}else{
	    	if (validSirim()){
	    		var url = "/logistics/sirim/selectTransitItemlist.do";
	    		var param = $("#newtrans").serialize();
	    		
	    		Common.ajax("GET",url,param,function(result){
	                AUIGrid.setGridData(itmGrid, result.data);
	                $("#ntoloc").attr("disable" , true);
	                $("#ncourier").attr("disable" , true);
	                $("#nfrloc").attr("disable" , true);
	                $("#nprefix").attr("readonly" , true);
	                $("#nsirimfr").attr("readonly" , true);
	                $("#nqty").attr("readonly" , true);
	                $("#nsirimto").attr("readonly" , true);
	            });
	    		$("#getsirim").text("Re Key");	
	    	}else{
	    		return false;
	    	}
    	}
    }
    
    function getSave(){
    	var url = "/logistics/sirim/insertSirimToTransitItem.do";
    	var param = AUIGrid.getGridData(itmGrid);
    	var data = {};
    	data.add = param;
    	data.form = $("#newtrans").serializeJSON();
    	
    	Common.ajax("POST",url,data,function(result){
            Common.alert(result.message);
            $("#ntrnsitno").val(result.data);
        });
    	
    }
    function updValidatChk(){
    	var bool = true; 
    	if ($("#ucourier").val() == ''){
    		   bool = false;
    		   Common.alert('You must fill up all the required fields before update.');
    	}
    	if ($("#utrnsitstus").val() == ''){
            bool = false;
            Common.alert('You must fill up all the required fields before update.');
        }
    	if ($('#hupdstatus').val() == $("#utrnsitstus").val() && $('#hupdcur'   ).val() == $("#ucourier").val()){
    		bool = false;
    		Common.alert('No changes in this sirim transit.<br />Update is not required.');
    	}
    	if ($("#utrnsitstus").val() == "8")
        {
    		var pm = "trnsitid="+$('#htranid'   ).val();
        	Common.ajaxSync("GET","/logistics/sirim/selecthasItemReceiveByReceiverCnt.do",pm,function(result){
                if (result.data <= 0 ){
                	bool = false;
                	Common.alert('There are some items have been received.<br />Transit deactivation is disallowed.');
                }
            });
        }
    	return bool;
    }
    function validSirim(){
    	var bool = true;
    	
    	if ($("#ntoloc").val() == ''){
    		bool = false;
    		Common.alert('Warehouse(To) Selected');
    		return bool;
    	}
    	if ($("#ncourier").val() == ''){
            bool = false;
            Common.alert('Courier Selected');
            return bool;
        }
    	if ($("#nfrloc").val() == ''){
            bool = false;
            Common.alert('Warehouse(From) Selected');
            return bool;
        }if ($("#nprefix").val() == ''){
            bool = false;
            Common.alert('Prefix Input Data');
            return bool;
        }if ($("#nsirimfr").val() == ''){
            bool = false;
            Common.alert('Sirim No (From) Input Data');
            return bool;
        }if ($("#nqty").val() == ''){
            bool = false;
            Common.alert('Quantity Input Data');
            return bool;
        }
        try{
	        var ssirim = $("#nsirimfr").val();
	        var tsirim = $("#nsirimto").val();
	        tsirim = (Number(ssirim) + (Number($("#nqty").val()) - 1)).toString();
	        for (var i = 0 ; i < ssirim.length - tsirim.length ; i++){
	            tsirim = '0'+tsirim;
	        }
	        $("#nsirimto").val(tsirim);
	    }catch (e) {
	    	Common.alert('System Error.\n Try Again please.');
	    	return false;
	    }
        
        return bool
    }
    
    function f_remove(itm){
    	var url = "/logistics/sirim/updateSirimTranItemDetail.do";
        var param = AUIGrid.getGridData(itmGrid);
        
        var param = "stii="+itm.stii;
        Common.ajax("GET",url,param,function(result){
            AUIGrid.removeRow(updGrid, "selectedIndex");
            AUIGrid.removeSoftRows(updGrid);
            Common.alert(result.message.message);
            
        });
    }
    
    
    function updateValidation(){
    	var bool = true;
    	
    	return bool;
    }
     
</script>
</head>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Sirim Management</li>
    <li>Sirim Transfer</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Sirim Transfer</h2>
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


</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">

    <li><p class="btn_grid"><a id="updtran"><spring:message code='sys.btn.update' /></a></p></li>
    <li><p class="btn_grid"><a id="newtran"><spring:message code='sys.btn.ins' /></a></p></li>
    
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


<div id="newView" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New Sirim Transfer</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Sirim Transfer Information</h2>
</aside><!-- title_line end -->
<form id="newtrans" name="newtrans" method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
    <tr>
        <th scope="row">Transit No</td>
        <td ><input type="text" name="ntrnsitno" id="ntrnsitno" placeholder="Transit No" class="w100p" readonly=true/></td>
    </tr>
    <tr>
        <th scope="row">Warehouse(To)</td>
        <td ><select id="ntoloc" class="w100p" name="ntoloc"></select></td>
    </tr>
    <tr>
        <th scope="row">Courier</td>
        <td ><select id="ncourier" class="w100p" name="ncourier"></select></td>
    </tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Sirim To Transit</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
    <tr>
        <th scope="row">Warehouse(From)</td>
        <td colspan='3'><select id="nfrloc" class="w100p" name="nfrloc"></select></td>
         <th scope="row">Quantity</td>
        <td ><input type="text" name="nqty" id="nqty" placeholder="" class="w100p numberAmt"/></td>
    </tr>
    <tr>
        <th scope="row">Prefix</td>
        <td><input type="text" name="nprefix" id="nprefix" placeholder="" class="w100p"/></td>
        <th scope="row">Sirim No (From)</td>
        <td ><input type="text" name="nsirimfr" id="nsirimfr" placeholder="" class="w100p"/></td>
        <th scope="row">Sirim No (To)</td>
        <td ><input type="text" name="nsirimto" id="nsirimto" placeholder="" class="w100p" readonly=true/></td>
    </tr>
</tbody>
</table><!-- table end -->
<ul class="center_btns">
      <li><p class="btn_blue2 big"><a id="getsirim" onclick="javascript:getSirim();">Get Sirim</a></p></li> 
</ul>
</form>
<article class="grid_wrap" id="selItmgrid">
   <div id="itemGrid" height="280px"></div>
   <ul class="center_btns">
      <li><p class="btn_blue2 big"><a onclick="javascript:getSave();">SAVE</a></p></li> 
    </ul>
</article>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->


<div id="updView" class="popup_wrap"><!-- popup_wrap start -->

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
<form id='updForm' name='updForm' method='POST'>
<input type='hidden' name='hupdstatus' id='hupdstatus'/>
<input type='hidden' name='hupdcur'    id='hupdcur'/>
<input type='hidden' name='hsrsi'      id='hsrsi'/>
<input type='hidden' name='htranid'    id='htranid'/>
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
        <td ID="utrnsitno"></td>
        <th scope="row">Transit Date</td>
        <td ID="utrnsitdt"></td>
    </tr>
    <tr>
        <th scope="row">Status</td>
        <td ><select id="utrnsitstus" class="w100p" name="utrnsitstus"></select></td>
        <th scope="row">Transit By</td>
        <td ID="utrnsitby"></td>            
    </tr>
    <tr>
        <th scope="row">Location</td>
        <td ID="ulocation"></td>
        <th scope="row">Courier</td>
        <td><select id="ucourier" class="w100p" name="ucourier"></select></td>
    </tr>
    <tr>
        <th scope="row">Total Sirim Transit</td>
        <td ID="utottrnsit" colspan="3"></td>
    </tr>
</tbody>
</table><!-- table end -->
<article class="grid_wrap" id="selItmgrid">
   
   <ul class="center_btns">
      <li id="updbutton"><p class="btn_blue2 big"><a id="updbtn">Update</a></p></li> 
    </ul>
</article>
<aside class="title_line"><!-- title_line start -->
<h2>Sirim To Transit</h2>
</aside><!-- title_line end -->
</form>
<section class="tap_wrap mt0"><!-- tap_wrap start -->
<ul class="tap_type1">  
    <li id="updall"><a href="#"> Show All </a></li>
    <li id="updpen"><a href="#"> Only Pending</a></li>
    <li id="updcomp"><a href="#"> Only Complete</a></li>
    <li id="updincom"><a href="#"> Only InComplete</a></li> 
</ul>

<article class="tap_area">
   <div id="updGrid" height="280px"></div>
</article>
</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->


</section><!-- content end -->

