<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
.my-row-style_r {
    background:#00bd31;
}
.my-row-style_n {
    background:#ff0000;
}
</style>
<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var listGrid;
    var viewGrid;
    var leftGrid;
    var rightGrid;
    var statusList = [{"codeId": "1","codeName": "Active/Pending"},{"codeId": "36","codeName": "Closed"}];
    var transtatusList = [{"codeId": "4","codeName": "Receive"},{"codeId": "50","codeName": "Not Received"}];
 // AUIGrid 칼럼 설정                                                                            visible : false
    
    var trancolumnLayout = [
							{dataField:"boxid"     ,headerText:'<spring:message code="sal.title.text.boxId" />'     ,width:100   ,height:30 , visible:false},
							{dataField:"boxno"     ,headerText:'<spring:message code="sal.title.text.boxNo" />'     ,width:"33%" ,height:30 , visible:true},
							{dataField:"status"    ,headerText:'<spring:message code="sal.title.text.boxStatus" />' ,width:"34%" ,height:30 , visible:false},
							{dataField:"statusid"  ,headerText:'<spring:message code="sal.title.text.statusID" />'  ,width:100   ,height:30 , visible:false},
							{dataField:"statuscd"  ,headerText:'<spring:message code="sal.title.text.boxStatus" />' ,width:"34%" ,height:30 , visible:true},
							{dataField:"holder"    ,headerText:'<spring:message code="sal.title.text.location" />'   ,width:"15%" ,height:30 , visible:false},
							{dataField:"branchid"  ,headerText:'<spring:message code="sal.title.text.branchId" />'   ,width:120   ,height:30 , visible:false},
							{dataField:"branchcd"  ,headerText:'<spring:message code="sal.title.text.branchCode" />' ,width:120   ,height:30 , visible:false},
							{dataField:"branchnm"  ,headerText:'<spring:message code="sal.title.text.branchName" />' ,width:120   ,height:30 , visible:false},
							{dataField:"bookqty"   ,headerText:'<spring:message code="sal.title.text.bookQty" />'   ,width:"33%" ,height:30 , visible:true },
							{dataField:"scrapdt"   ,headerText:'<spring:message code="sal.title.text.scrapDate" />' ,width:"14%" ,height:30 , dataType : "date", formatString : "dd/mm/yyyy" ,visible:false },
							{dataField:"scrapdt2"  ,headerText:'<spring:message code="sal.title.text.scrapDate" />' ,width:"14%" ,height:30 , visible:false },
							{dataField:"crtdt"     ,headerText:'<spring:message code="sal.text.createAt" />'  ,width:"14%" ,height:30 , dataType : "date", formatString : "dd/mm/yyyy" ,visible:false },
							{dataField:"crtdt2"    ,headerText:'<spring:message code="sal.text.createAt" />'  ,width:"14%" ,height:30 , visible:false },
							{dataField:"opendt"    ,headerText:'<spring:message code="sal.title.text.openDt" />'    ,width:"14%" ,height:30 , dataType : "date", formatString : "dd/mm/yyyy" ,visible:false },
							{dataField:"opendt2"   ,headerText:'<spring:message code="sal.title.text.openDt" />'    ,width:"14%" ,height:30 , visible:false },
							{dataField:"crtname"   ,headerText:'<spring:message code="sal.text.createBy" />'  ,width:"15%" ,height:30 , visible:false },
							{dataField:"crtuser"   ,headerText:'<spring:message code="sal.title.text.createId" />'  ,width:120   ,height:30 , visible:false}
                           ];
    
    var tranoptions = {showStateColumn : false , editable : false, pageRowCount : 20, usePaging : false, useGroupingPanel : false };
    
    $(document).ready(function(){
    	doGetComboSepa('/misc/TRBox/selectTransferCodeList.do', 'branch' , ' - ' , '','receiver', 'S' , '');
        doGetComboSepa('/misc/TRBox/selectTransferCodeList.do', 'courier' , ' - ' , '','courier', 'S' , '');
        
    	leftGrid  = GridCommon.createAUIGrid("left_grid_wrap",  trancolumnLayout,"", tranoptions);
        rightGrid = GridCommon.createAUIGrid("right_grid_wrap", trancolumnLayout,"", tranoptions);
        
        
        var url = "/misc/TRBox/getSearchTrboxManagementList.do";
        var param = "bulkholder=${SESSION_INFO.code}";
        getSearchListAjax(url , param);
    });
    
    function postSearchListAjax(url , param){
        Common.ajax("POST" , url , param , function(data){
        	AUIGrid.setGridData(listGrid, data.data);
        });
    }
    
    function postActionAjax(url , param){
    	console.log(param);
    	Common.ajax("POST" , url , param , function(data){
            console.log(data);
            Common.alert(data.message);
            
            if (data.code == '00'){
            	$("#transitno").val(data.data);
            	$("#tranSaveBtn").hide();
            }
        });
    }

	function getSearchListAjax(url , param ){
		console.log(param);
        Common.ajax("GET" , url , param , function(data){
        	console.log(data);
        	AUIGrid.setGridData(leftGrid, data.data);
        });
    }
    
	$(function(){
    	$("#tranSaveBtn").click(function(){
    		if ($("#receiver").val() == ''){
    			Common.alert('<spring:message code="sal.title.text.noTransferToData" />');
    			return false;
    		}
    		if ($("#courier").val() == ''){
                Common.alert('<spring:message code="sal.title.text.noCourierData" />');
                return false;
            }
    		
    		var dat = GridCommon.getEditData(rightGrid);
            dat.form = $("#bulkform").serializeJSON();
            
            var url = "/misc/TRBox/postTrboxTransferInsertData.do";
            postActionAjax(url , dat);
            
    	});
    	$("#rightBtn").click(function(){
    		var selectedItems = AUIGrid.getSelectedItems(leftGrid);
            var bool = true;
            if (selectedItems.length > 0){
                var rowPos = "first";
                var item = new Object();
                var rowList = [];
                
                for (var i = 0 ; i < selectedItems.length ; i++){
                    console.log(selectedItems[i]);
                    var itm = selectedItems[i].item;
                    rowList[i] = {
                    		boxid     :  itm.boxid    ,
                            boxno     :  itm.boxno    ,
                            status    :  itm.status   ,
                            statusid  :  itm.statusid ,
                            statuscd  :  itm.statuscd ,
                            holder    :  itm.holder   ,
                            branchid  :  itm.branchid ,
                            branchcd  :  itm.branchcd ,
                            branchnm  :  itm.branchnm ,
                            bookqty   :  itm.bookqty  ,
                            scrapdt   :  itm.scrapdt  ,
                            scrapdt2  :  itm.scrapdt2 ,
                            crtdt     :  itm.crtdt    ,
                            crtdt2    :  itm.crtdt2   ,
                            opendt    :  itm.opendt   ,
                            opendt2   :  itm.opendt2  ,
                            crtname   :  itm.crtname  ,
                            crtuser   :  itm.crtuser  
                    }
                    
                   // AUIGrid.addUncheckedRowsByIds(leftGrid, selectedItems[i].rnum);
                    AUIGrid.removeRow(leftGrid, "selectedIndex");
                    AUIGrid.removeSoftRows(leftGrid);
                }
                
                AUIGrid.addRow(rightGrid, rowList, rowPos);
                
            }
        });
    	$("#leftBtn").click(function(){
    		var selectedItems = AUIGrid.getSelectedItems(rightGrid);
            var bool = true;
            if (selectedItems.length > 0){
                var rowPos = "first";
                var item = new Object();
                var rowList = [];
                
                for (var i = 0 ; i < selectedItems.length ; i++){
                    console.log(selectedItems[i]);
                    var itm = selectedItems[i].item;
                    rowList[i] = {
                    		boxid     :  itm.boxid    ,
                    		boxno     :  itm.boxno    ,
                    		status    :  itm.status   ,
                    		statusid  :  itm.statusid ,
                    		statuscd  :  itm.statuscd ,
                    		holder    :  itm.holder   ,
                    		branchid  :  itm.branchid ,
                    		branchcd  :  itm.branchcd ,
                    		branchnm  :  itm.branchnm ,
                    		bookqty   :  itm.bookqty  ,
                    		scrapdt   :  itm.scrapdt  ,
                    		scrapdt2  :  itm.scrapdt2 ,
                    		crtdt     :  itm.crtdt    ,
                    		crtdt2    :  itm.crtdt2   ,
                    		opendt    :  itm.opendt   ,
                    		opendt2   :  itm.opendt2  ,
                    		crtname   :  itm.crtname  ,
                    		crtuser   :  itm.crtuser    
                    }
                    
                   // AUIGrid.addUncheckedRowsByIds(leftGrid, selectedItems[i].rnum);
                    AUIGrid.removeRow(rightGrid, "selectedIndex");
                    AUIGrid.removeSoftRows(rightGrid);
                }
                
                AUIGrid.addRow(leftGrid, rowList, rowPos);
            }
        });
    	$("#Btnsrch").click(function(){
    		var url = "/misc/TRBox/getSearchTrboxManagementList.do";
    		 var param = "bulkholder=${SESSION_INFO.code}&boxno="+$("#pboxno").val();
    	     getSearchListAjax(url , param);
    	});
        $("#Btnclr").click(function(){
        	$("#pboxno").val('');
        });
        $("#showAllBtn").click(function(){
        	var url = "/misc/TRBox/getSearchTrboxManagementList.do";
        	var param = "bulkholder=${SESSION_INFO.code}";
            getSearchListAjax(url , param);
        });
        $("#filterBtn").click(function(){
            $("#filter_popup_wrap").show();
            $("#pboxno").val('');
        });
        
    });

</script>
        
<!--****************************************************************************
    CONTENT START
*****************************************************************************-->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>MISC</li>
        <li>TR Box</li>
        <li>TR Box Management</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2><spring:message code="sal.title.text.bulkTransfer" /></h2>
	</aside><!-- title_line end -->
		
		
	<section class="search_table"><!-- search_table start -->
		<form id="bulkform" name="bulkform">
		<input type="hidden" id="sender" name="sender" value="${SESSION_INFO.code}">
		<aside class="title_line"><!-- title_line start -->
		  <h3><spring:message code="sal.alert.msg.transferInformation" /></h3>
		</aside><!-- title_line end -->
		
		<table class="type1"><!-- table start -->
			<caption>table</caption>
			<colgroup>
			    <col style="width:180px" />
			    <col style="width:*" />
			</colgroup>
			<tbody>
			<tr>
			    <th scope="row"><spring:message code="sal.title.transitNo" /></th>
			    <td>
			    <input type="text" id="transitno" name="transitno" title="" placeholder="" class="" disabled="true"/>
			    </td>
			</tr>
			<tr>
			    <th scope="row"><spring:message code="sal.alert.msg.transferTo" /></th>
			    <td><select class="w100p" id="receiver" name="receiver"></select></td>
			</tr>
			<tr>
			    <th scope="row"><spring:message code="sal.text.courier" /></th>
			    <td><select class="w100p" id="courier" name="courier"></select></td>
			</tr>
			</tbody>
		</table><!-- table end -->
		
		</ul>
		
		<aside class="title_line"><!-- title_line start -->
		<h3><spring:message code="sal.title.trBoxSelTrBoxSelection" /></h3>
		</aside><!-- title_line end -->
		
		<div class="divine_auto type2"><!-- divine_auto start -->
		
		<div style="width:50%;">
		
		<div class="border_box" style="height:200px;"><!-- border_box start -->
		
		<aside class="title_line"><!-- title_line start -->
		<h4 class="pt0"><spring:message code="sal.title.colesdBoxHolding" /></h4>
		</aside><!-- title_line end -->
		
		<article class="grid_wrap"><!-- grid_wrap start -->
		    <div id="left_grid_wrap" style="height:170px"></div>
		</article><!-- grid_wrap end -->
		
		</div><!-- border_box end -->
		
		</div>
		
		<div style="width:50%;">
		
		<div class="border_box" style="height:200px;"><!-- border_box start -->
		
		<aside class="title_line"><!-- title_line start -->
		<h4 class="pt0"><spring:message code="sal.title.text.boxToTransfer" /></h4>
		</aside><!-- title_line end -->
		
		<article class="grid_wrap"><!-- grid_wrap start -->
		    <div id="right_grid_wrap" style="height:170px"></div>
		</article><!-- grid_wrap end -->
		
		<ul class="btns">
		    <li><a id="leftBtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left.gif" alt="left" /></a></li>
            <li><a id="rightBtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right.gif" alt="right" /></a></li>
		</ul>
		
		</div><!-- border_box end -->
		
		</div>
		
		</div><!-- divine_auto end -->
		
		<ul class="left_btns mt10">
		    <li><p class="btn_blue2"><a id="filterBtn"><spring:message code="sal.title.text.filterList" /></a></p></li>
		    <li><p class="btn_blue2"><a id="showAllBtn"><spring:message code="sal.title.text.showAll" /></a></p></li>
		</ul>
		
		<ul class="center_btns">
		    <li><p class="btn_blue2 big"><a id="tranSaveBtn"><spring:message code="sal.btn.save" /></a></p></li>
		</ul>
		</form>
	</section>
    
    <div id="filter_popup_wrap" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->

        <header class="pop_header"><!-- pop_header start -->
        <h1><spring:message code="sal.title.text.filterBoxBookList" /></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
        </header><!-- pop_header end -->
        
        <section class="pop_body"><!-- pop_body start -->
        <form id="filterForm" name="filterForm">
          
        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:130px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.boxNo" /></th>
            <td>
            <input type="text" title="" id="pboxno" name="pboxno" placeholder="" class="w100p" />
            </td>
        </tr>
        </tbody>
        </table><!-- table end -->
        </form>
        <ul class="center_btns">
            <li><p class="btn_blue2 big"><a id="Btnsrch"><spring:message code="sal.btn.search" /></a></p></li>
            <li><p class="btn_blue2 big"><a id="Btnclr"><spring:message code="sal.btn.clear" /></a></p></li>
        </ul>
        </section><!-- pop_body end -->
    
    </div><!-- popup_wrap end -->
</section><!-- content end -->
