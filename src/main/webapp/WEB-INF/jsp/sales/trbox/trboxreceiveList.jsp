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
    var columnLayout = [{dataField:"trboxno"      ,headerText:"Box No"       ,width:100   ,height:30 , visible:false},
                        {dataField:"trnsitno"     ,headerText:"Transit No"   ,width:"14%" ,height:30 , visible:true },
                        {dataField:"trnsitdt"     ,headerText:"Date"         ,width:"15%" ,height:30 , dataType : "date", formatString : "dd/mm/yyyy" ,visible:true},
                        {dataField:"trnsitdt2"    ,headerText:"DATE"         ,width:100   ,height:30 , visible:false},
                        {dataField:"trnsitfr"     ,headerText:"From"         ,width:"14%" ,height:30 , visible:true },
                        {dataField:"trnsitto"     ,headerText:"To"           ,width:"15%" ,height:30 , visible:true },
                        {dataField:"trnsitstnm"   ,headerText:"Status"       ,width:"14%" ,height:30 , visible:true },
                        {dataField:"trnsitstcd"   ,headerText:"Status"       ,width:"14%" ,height:30 , visible:false},
                        {dataField:"trnsitstid"   ,headerText:"Status"       ,width:"14%" ,height:30 , visible:false},
                        
                        {dataField:"trnsitcrtid"  ,headerText:"By"           ,width:"14%" ,height:30 , visible:true },
                        {dataField:"trnsittotbox" ,headerText:"TotalBox"     ,width:"14%" ,height:30 , visible:true },
                        {dataField:"trnsitcldt"   ,headerText:"Close Dt"     ,width:"14%" ,height:30 , dataType : "date", formatString : "dd/mm/yyyy" , visible:false},
                        {dataField:"trnsitcldt2"  ,headerText:"Close Dt"     ,width:"14%" ,height:30 , visible:false},
                        {dataField:"trnsitcur"    ,headerText:"TrnCourier"   ,width:"15%" ,height:30 , visible:false},
                        {dataField:"trtrnsitid"   ,headerText:"trtrnsitid"   ,width:120   ,height:30 , visible:false},
                        {dataField:"trtrnsitstid" ,headerText:"trtrnsitstid" ,width:120   ,height:30 , visible:false},
                        {dataField:"trnsitid"     ,headerText:"Transit ID"   ,width:120   ,height:30 , visible:false}
                       ];
    
    var viewcolumnLayout = [{dataField:"TTDI"  ,headerText:"TR_TRNSIT_DET_ID"     ,width:"14%" ,height:30 , visible:false},
	                        {dataField:"TTRSI" ,headerText:"Close Dt"     ,width:"14%" ,height:30 , visible:false},
	                        {dataField:"TBN"   ,headerText:"Box No"   ,width:"33%" ,height:30 , visible:true},
	                        {dataField:"CNT"   ,headerText:"Total Book(s) In Box"  ,width:"34%",height:30 , visible:true},
	                        {dataField:"TBI"   ,headerText:"trtrnsitid"   ,width:120 ,height:30 , visible:false},
	                        {dataField:"CODE"  ,headerText:"Status" ,width:"33%" ,height:30 , visible:true}
	                       ];
    
    var trancolumnLayout = [{dataField:"TTDI"  ,headerText:"TR_TRNSIT_DET_ID"     ,width:"14%" ,height:30 , visible:false}, //
                            {dataField:"TTRSI" ,headerText:"Close Dt"             ,width:"14%" ,height:30 , visible:false}, //
                            {dataField:"TBN"   ,headerText:"Box No"               ,width:"33%" ,height:30 , visible:true},
                            {dataField:"CNT"   ,headerText:"Total Book(s) In Box" ,width:"34%" ,height:30 , visible:true},
                            {dataField:"TBI"   ,headerText:"trtrnsitid"           ,width:120   ,height:30 , visible:false},  //
                            {dataField:"CODE"  ,headerText:"Status"               ,width:"33%" ,height:30 , visible:true}
                           ];
    
    var gridoptions = {showStateColumn : true , editable : false, pageRowCount : 20, usePaging : true, useGroupingPanel : false };
    var tranoptions = {showStateColumn : false , editable : false, pageRowCount : 20, usePaging : false, useGroupingPanel : false };
    var viewgridoptions = {showStateColumn : false , editable : false, pageRowCount : 20, usePaging : true, useGroupingPanel : false , rowStyleFunction : function(rowIndex, item) {
    	if(item.TTRSI == "4") {
            return "my-row-style_r";
        }
        else if(item.TTRSI == "50") {
            return "my-row-style_n";
        }
    }};
    
    $(document).ready(function(){
    	doGetComboSepa('/common/selectBranchCodeList.do', '9' , ' - ' , '','branchid', 'S' , '');
        doDefCombo(statusList, '1' ,'status', 'S', '');
        doDefCombo(transtatusList, '1' ,'utrnstatuslist', 'S', '');
        listGrid  = GridCommon.createAUIGrid("grid_wrap",           columnLayout,"", gridoptions);
        viewGrid  = GridCommon.createAUIGrid("view_grid_wrap",      viewcolumnLayout,"", viewgridoptions);
        leftGrid  = GridCommon.createAUIGrid("upd_left_grid_wrap",  trancolumnLayout,"", tranoptions);
        rightGrid = GridCommon.createAUIGrid("upd_right_grid_wrap", trancolumnLayout,"", tranoptions);
        AUIGrid.bind(listGrid, "cellClick", function( event )
        {
            
        });
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
            
        });
        
    });
    
    function f_multiCombo(){
        $(function() {
            
        });
    }
    
    function postSearchListAjax(url , param){
        Common.ajax("POST" , url , param , function(data){
        	console.log(data);
            AUIGrid.setGridData(listGrid, data.data);
            
        });
    }
    
    function postActionAjax(url , param){
    	Common.ajax("POST" , url , param , function(data){
            console.log(data);
            if (data.code == '00'){
            	Common.alert(data.message);
            	$("#upd_popup_wrap").hide();
            	$("#btnSrch").click();
            }else{
            	Common.alert(data.message);
            }
            
        });
    }

	function getSearchListAjax(url , param , refunc){
        Common.ajax("GET" , url , param , function(data){
        	//AUIGrid.setGridData(listGrid, data.data);
        	if (refunc == 'view'){
                viewdraw(data);
            }else if (refunc == 'update'){
                upddraw(data);
            }else{
        		AUIGrid.setGridData(viewGrid, data);
                AUIGrid.resize(viewGrid);
        	}
        	
        });
    }

	function viewdraw(data){
		var itm = data.viewdata;
 		var cnt = data.cntmap;
 		var listdata = data.listmap;
 		$("#vtrnno"     ).text(itm.trnno);
 		$("#vtrndt"     ).text(itm.trndt);
 		$("#vtrnstatus" ).text(itm.trnstusnm);
 		$("#vtrnfr"     ).text(itm.trnfr + ' - ' +itm.trnfrnm);
 		$("#vtrnto"     ).text(itm.trnto + ' - ' +itm.trntonm);
 		$("#vclodt"     ).text(itm.trnclodt);
 		$("#vtotbox"    ).text(itm.trntotbox);
 		$("#vcourier"   ).text(itm.trncurnm);
 		$("#vcreator"   ).text(itm.trncrtuser);
		$("#vtotpend"   ).text(cnt.PENDINGCNT);
		$("#vtotrecv"   ).text(cnt.RECEIPTCNT);
		$("#vtotnotrecv").text(cnt.NOTRECEIPTCNT);
		$("#view_popup_wrap").show();
		AUIGrid.setGridData(viewGrid, listdata);
		AUIGrid.resize(viewGrid);
		
	}
	
	function upddraw(data){
		var itm = data.viewdata;
        var cnt = data.cntmap;
        var listdata = data.listmap;
        $("#utrnno"     ).text(itm.trnno);
        $("#transitid"  ).val(itm.trnid);
        $("#transitno"  ).val(itm.trnno);
        $("#utrndt"     ).text(itm.trndt);
        $("#utrnstatus" ).text(itm.trnstusnm);
        $("#transitstatus").val(itm.trnstusid);
        $("#utrnfr"     ).text(itm.trnfr + ' - ' +itm.trnfrnm);
        $("#sender").val(itm.trnfr);
        $("#utrnto"     ).text(itm.trnto + ' - ' +itm.trntonm);
        $("#receiver").val(itm.trnto);
        $("#uclodt"     ).text(itm.trnclodt);
        $("#utotbox"    ).text(itm.trntotbox);
        $("#ucourier"   ).text(itm.trncurnm);
        $("#courier").val(itm.trncur);
        $("#ucreator"   ).text(itm.trncrtuser);
        $("#utotpend"   ).text(cnt.PENDINGCNT);
        $("#utotrecv"   ).text(cnt.RECEIPTCNT);
        $("#utotnotrecv").text(cnt.NOTRECEIPTCNT);
        $("#upd_popup_wrap").show();
        AUIGrid.setGridData(leftGrid, listdata);
        AUIGrid.resize(leftGrid);
        AUIGrid.setGridData(rightGrid, []);
        AUIGrid.resize(rightGrid);
        
    }
    
	function viewGridFunc(code){
		var selectedItems = AUIGrid.getSelectedItems(listGrid); 
		var itm = selectedItems[0].item;
        var url = "/misc/TRBox/getSearchTrboxReceiveGridList.do";
        var param = "trnsitid="+itm.trnsitid + "&statuschk="+code;
        getSearchListAjax(url , param , '' );
	}
    $(function(){
    	$("#btnSrch").click(function(){
			var url = "/misc/TRBox/getSearchTrboxReceiveList.do";
			var param = $('#searchForm').serializeJSON();
			postSearchListAjax(url , param);
    	});
    	$("#viewinfoBtn").click(function(){
    		var selectedItems = AUIGrid.getSelectedItems(listGrid);
            if (selectedItems.length == 0 ){
                Common.alert("Selected Data");
                return false;
            }else{
                var itm = selectedItems[0].item;
				var url = "/misc/TRBox/getSearchTrboxReceiveViewData.do";
				var param = "trnsitid="+itm.trnsitid;
        
				getSearchListAjax(url , param ,'view' );

            }
    	});
    	$("#updrecBtn").click(function(){
    		var selectedItems = AUIGrid.getSelectedItems(listGrid);
            if (selectedItems.length == 0 ){
                Common.alert("Selected Data");
                return false;
            }else{
            	$("#utrnno"     ).text('');
                $("#transitid"  ).val('');
                $("#transitno"  ).val('');
                $("#utrndt"     ).text('');
                $("#utrnstatus" ).text('');
                $("#transitstatus").val('');
                $("#utrnfr"     ).text('');
                $("#sender").val('');
                $("#utrnto"     ).text('');
                $("#receiver").val('');
                $("#uclodt"     ).text('');
                $("#utotbox"    ).text('');
                $("#ucourier"   ).text('');
                $("#courier").val('');
                $("#ucreator"   ).text('');
                $("#utotpend"   ).text('');
                $("#utotrecv"   ).text('');
                $("#utotnotrecv").text('');
                
                AUIGrid.setGridData(leftGrid, []);
                AUIGrid.setGridData(rightGrid, []);
                
                var itm = selectedItems[0].item;
                var url = "/misc/TRBox/getSearchTrboxReceiveViewData.do";
                var param = "trnsitid="+itm.trnsitid;
        
                getSearchListAjax(url , param ,'update' );

            }
    	});
    	$("#tranSaveBtn").click(function(){
    		if ($("#utrnstatuslist").val() == ''){
    			Common.alert('No item to update transit status.<br />Please add item to transit.');
    		}else{
	    		var dat = GridCommon.getEditData(rightGrid);
	            dat.form = $("#recvForm").serializeJSON();
	            
	            var url = "/misc/TRBox/postTrboxReceiveInsertData.do";
	            postActionAjax(url , dat);
    		}
            
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
                                TTDI  : itm.TTDI  ,
                                TTRSI : itm.TTRSI ,
                                TBN   : itm.TBN   ,
                                CNT   : itm.CNT   ,
                                TBI   : itm.TBI   ,
                                CODE  : itm.CODE
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
                                TTDI  : itm.TTDI  ,
                                TTRSI : itm.TTRSI ,
                                TBN   : itm.TBN   ,
                                CNT   : itm.CNT   ,
                                TBI   : itm.TBI   ,
                                CODE  : itm.CODE
                    }
                    
                   // AUIGrid.addUncheckedRowsByIds(leftGrid, selectedItems[i].rnum);
                    AUIGrid.removeRow(rightGrid, "selectedIndex");
                    AUIGrid.removeSoftRows(rightGrid);
                }
                
                AUIGrid.addRow(leftGrid, rowList, rowPos);
            }
        });
    	$("#updclose").click(function(){
    		$("#upd_popup_wrap").hide();
    	});
    	$("#viewclose").click(function(){
            $("#view_popup_wrap").hide();
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
        <h2>TR Box Management </h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a id="btnSrch"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a id="btnClear"><span class="clear"></span>Clear</a></p></li>
        </ul>
    </aside><!-- title_line end -->


    <section class="search_table"><!-- search_table start -->
    <form name="searchForm" id="searchForm" method="post">

        <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
            <tr>
                <th scope="row">Transit No</th>
                <td>
                    <input type="text" title="Transit No" id="trnsitno" name="trnsitno" placeholder="Transit No" class="w100p" />
                </td>
                <th scope="row">Box No</th>
                <td>
                    <input type="text" title="Box No" id="boxno" name="boxno" placeholder="Box No" class="w100p" />
                </td>
                <th scope="row">Create Date</th>
                <td>
                    <input type="text" title="Create Date" name="crtdt" id="crtdt" placeholder="DD/MM/YYYY" class="j_date" />
                </td>
            </tr>
            <tr>
                <th scope="row">Create By</th>
                <td>
                    <input type="text" title="Create By" id="crtuser" name="crtuser" placeholder="Create By" class="w100p" />
                </td>
                <th scope="row">Status</th>
                <td>
                    <select class="w100p" id="status" name="status"></select>
                </td>
                <th scope="row">Transit To</th>
                <td>
                    <select class="w100p" id="branchid" name="branchid"></select>
                </td>
            </tr>
            </tbody>
        </table>
    </form>
    </section><!-- search_table end -->

    <section class="search_result"><!-- search_result start -->

        <ul class="right_btns">
            <li><p class="btn_grid"><a id="updrecBtn">Update Receive</a></p></li>
            <li><p class="btn_grid"><a id="viewinfoBtn">VIEW Info</a></p></li>
        </ul>

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="grid_wrap" style="height:500px"></div>
    </article><!-- grid_wrap end -->

    </section><!-- search_result end -->
    
    <div id="view_popup_wrap" class="popup_wrap" style="display:none"><!-- popup_wrap start -->

        <header class="pop_header"><!-- pop_header start -->
        <h1>Transit Receive View</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id="viewclose">CLOSE</a></p></li>
        </ul>
        </header><!-- pop_header end -->
        <section class="pop_body"><!-- pop_body start -->
        
        <aside class="title_line"><!-- title_line start -->
        <h2>Transit Information</h2>
        </aside><!-- title_line end -->
        
        <table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:160px" />
		    <col style="width:*" />
		    <col style="width:150px" />
		    <col style="width:*" />
		    <col style="width:130px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		<tr>
		    <th scope="row">Transit No</th>
		    <td>
		    <span id="vtrnno">1111</span>
		    </td>
		    <th scope="row">Transit Date</th>
		    <td id="vtrndt"></td>
		    <th scope="row">Transit Status </th>
		    <td id="vtrnstatus"></td>
		</tr>
		<tr>
		    <th scope="row">Transit From</th>
		    <td>
		    <span id="vtrnfr"></span>
		    </td>
		    <th scope="row">Transit To</th>
		    <td id="vtrnto"></td>
		    <th scope="row">Close Date</th>
		    <td id="vclodt"></td>
		</tr>
		<tr>
		    <th scope="row">Total Book</th>
		    <td>
		    <span id="vtotbox">1111</span>
		    </td>
		    <th scope="row">Courier</th>
		    <td id="vcourier"></td>
		    <th scope="row">Creator</th>
		    <td id="vcreator"></td>
		</tr>
		<tr>
		    <th scope="row">Total Pending</th>
		    <td>
		    <span id="vtotpend">1111</span>
		    </td>
		    <th scope="row">Total Received</th>
		    <td id="vtotrecv"></td>
		    <th scope="row">Total Not Received</th>
		    <td id="vtotnotrecv"></td>
		</tr>
		</tbody>
		</table><!-- table end -->
        
        <aside class="title_line"><!-- title_line start -->
		  <h3>Book Transit</h3>
		</aside><!-- title_line end -->
		
		<aside class="title_line"><!-- title_line start -->
		  <h4 id="viewh4">All Transit Book List</h4>
		</aside><!-- title_line end -->
        
        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="view_grid_wrap" style="height:180px"></div>
        </article><!-- grid_wrap end -->
        <div>
            <table>
                <tr >
                   <td class="left_btns mt10">
                    <li><p class="btn_blue2"><a href="javascript:viewGridFunc('')">All</a></p></li>
                    <li><p class="btn_blue2"><a href="javascript:viewGridFunc('4')">Receive</a></p></li>
                    <li><p class="btn_blue2"><a href="javascript:viewGridFunc('50')">Not Receive</a></p></li>
                   </td>
                   <td class="right_btns mt10">
                    <li><p>Pending</p></li>
                    <li><p class="green_text">Received</p></li>
                    <li><p class="red_text">Not Receive</p></li>
                </td>
                </tr>
            </table>
        </div>
        </section><!-- pop_body end -->
        
    </div><!-- popup_wrap end -->
    
    <div id="upd_popup_wrap" class="popup_wrap" style="display:none"><!-- popup_wrap start -->

        <header class="pop_header"><!-- pop_header start -->
        <h1>Transit Receive View</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id="updclose">CLOSE</a></p></li>
        </ul>
        </header><!-- pop_header end -->
        <section class="pop_body"><!-- pop_body start -->
        
        <aside class="title_line"><!-- title_line start -->
        <h2>Transit Information</h2>
        </aside><!-- title_line end -->
        <form id="recvForm" name="recvForm">
        <input type="hidden" id="transitstatus" name="transitstatus"/>
        <input type="hidden" id="sender" name="sender" >
        <input type="hidden" id="receiver" name="receiver" >
        <input type="hidden" id="courier" name="courier" >
        <input type="hidden" id="transitid" name="transitid" >
        <input type="hidden" id="transitno" name="transitno" >
        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:160px" />
            <col style="width:*" />
            <col style="width:150px" />
            <col style="width:*" />
            <col style="width:130px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row">Transit No</th>
            <td>
            <span id="utrnno"></span>
            </td>
            <th scope="row">Transit Date</th>
            <td id="utrndt"></td>
            <th scope="row">Transit Status </th>
            <td id="utrnstatus"></td>
            
        </tr>
        <tr>
            <th scope="row">Transit From</th>
            <td>
            <span id="utrnfr"></span>
            </td>
            <th scope="row">Transit To</th>
            <td id="utrnto"></td>
            
            <th scope="row">Close Date</th>
            <td id="uclodt"></td>
        </tr>
        <tr>
            <th scope="row">Total Book</th>
            <td>
            <span id="utotbox"></span>
            </td>
            <th scope="row">Courier</th>
            <td id="ucourier"></td>
            
            
            <th scope="row">Creator</th>
            <td id="ucreator"></td>
        </tr>
        <tr>
            <th scope="row">Total Pending</th>
            <td>
            <span id="utotpend"></span>
            </td>
            <th scope="row">Total Received</th>
            <td id="utotrecv"></td>
            <th scope="row">Total Not Received</th>
            <td id="utotnotrecv"></td>
        </tr>
        </tbody>
        </table><!-- table end -->
        
        <aside class="title_line"><!-- title_line start -->
          <h3>Transit Result</h3>
        </aside><!-- title_line end -->
        <table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:150px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		<tr>
		    <th scope="row">Transit Status</th>
		    <td>
		      <select id="utrnstatuslist" name="utrnstatuslist" class="w100p"></select>
		    </td>
		</tr>
		</tbody>
		</table>
        <section class="search_result"><!-- search_result start -->

			<div class="divine_auto type2 mt0"><!-- divine_auto start -->
			
			<div style="width:50%;">
			
			<div class="border_box" style="height:150px;"><!-- border_box start -->
			
			<aside class="title_line"><!-- title_line start -->
			<h4 class="pt0">Book In Transit</h4>
			</aside><!-- title_line end -->
			
			<article class="grid_wrap"><!-- grid_wrap start -->
			   <div id="upd_left_grid_wrap" style="height:120px"></div>
			</article><!-- grid_wrap end -->
			
			</div><!-- border_box end -->
			
			</div>
			
			<div style="width:50%;">
			
			<div class="border_box" style="height:150px;"><!-- border_box start -->
			
			<aside class="title_line"><!-- title_line start -->
			<h4 class="pt0">Action List</h4>
			</aside><!-- title_line end -->
			
			<article class="grid_wrap"><!-- grid_wrap start -->
			    <div id="upd_right_grid_wrap" style="height:120px"></div>
			</article><!-- grid_wrap end -->
			
			<ul class="btns">
			    <li><a id="leftBtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left.gif" alt="left" /></a></li>
			    <li><a id="rightBtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right.gif" alt="right" /></a></li>
			</ul>
			
			</div><!-- border_box end -->
			
			</div>
			
			</div><!-- divine_auto end -->
			
			<ul class="left_btns mt10">
			    <li><p class="btn_blue2"><a href="#">Filter List</a></p></li>
			    <li><p class="btn_blue2"><a href="#">Show All</a></p></li>
			</ul>
			</form>
			<ul class="center_btns mt20">
			    <li><p class="btn_blue2 big"><a id="tranSaveBtn">SAVE</a></p></li>
			</ul>
        </section>
        
   </section><!-- pop_body end -->
        
    </div><!-- popup_wrap end -->

</section><!-- content end -->
